import 'package:dart_time/dart_time.dart';

/// default slot interval
const kDefaultSlotInterval = Duration(minutes: 15);

/// default search limit in days
const kDefaultSearchLimitInDays = 30;

/// [ActivityScheduler] provides utilities for finding available time slots
/// for scheduling activities, meetings, or appointments.
class ActivityScheduler {
  /// Finds the next available time slot [from] the given datetime.
  ///
  /// Returns `null` if no slot is found
  /// within [searchLimitInDays].
  ///
  /// Parameters:
  /// - [from]: The datetime from which to search for a slot
  /// - [slotDuration]: The required duration of the slot
  /// - [busySlots]: List of already booked time ranges to avoid
  /// - [workingHours]: A function that returns the working hours
  /// for a given date
  /// - [workCalendar]: Optional business calendar for holidays and working days
  /// - [searchLimitInDays]: Maximum days to search ahead
  /// (default: [kDefaultSearchLimitInDays])
  /// - [slotInterval]: Minimum time between slot start times
  /// (default: [kDefaultSlotInterval])
  ///
  /// Example:
  /// ```dart
  /// final scheduler = ActivityScheduler();
  /// final workingHours = ClockTimeRange(
  ///   start: ClockTime(9),
  ///   end: ClockTime(17),
  /// );
  ///
  /// final nextSlot = scheduler.findNextSlot(
  ///   from: DateTime.now(),
  ///   slotDuration: Duration(hours: 1),
  ///   busySlots: [
  ///     DartDateRange(
  ///       start: DateTime(2024, 1, 15, 10),
  ///       end: DateTime(2024, 1, 15, 12),
  ///     ),
  ///   ],
  ///   workingHours: (date) => [workingHours],
  /// );
  /// ```
  static DateTime? findNextSlot({
    required DateTime from,
    required Duration slotDuration,
    required Duration slotInterval,
    required List<DartDateRange> busySlots,
    required List<ClockTimeRange> Function(DateTime date) workingHours,
    WorkCalendar? workCalendar,
    int searchLimitInDays = kDefaultSearchLimitInDays,
  }) {
    if (slotDuration.inMicroseconds <= 0) {
      throw _ActivitySchedulerError.slotDurationNegativeError(slotDuration);
    }

    if (slotInterval.inMicroseconds <= 0) {
      throw _ActivitySchedulerError.slotIntervalNegativeError(slotInterval);
    }

    // Start searching from the next minute (rounded up)
    var searchDate = from.copyWith();
    final searchEnd = from.add(Duration(days: searchLimitInDays));

    // Remove busy slots that start after search end
    final sortedBusySlots = List<DartDateRange>.from(busySlots)
      ..removeWhere((slot) => slot.start.isAfter(searchEnd))
      ..sort((a, b) => a.start.compareTo(b.start));

    while (searchDate.isBefore(searchEnd)) {
      // Skip non-working days if calendar is provided
      if (workCalendar != null && !workCalendar.isWorkingDay(searchDate)) {
        searchDate = searchDate.addDays(1).startOfDay;
        continue;
      }

      // Get working hours for this day
      final dayWorkingHours = workingHours(searchDate);

      for (final workingHour in dayWorkingHours) {
        final effectiveRange = workingHour.effectiveRange(searchDate);

        // Start search from max of current search time or day start
        var currentTime = searchDate.isBefore(effectiveRange.start)
            ? effectiveRange.start
            : searchDate;

        // Search within this day's working hours
        while (
            currentTime.add(slotDuration).isSameOrBefore(effectiveRange.end)) {
          final potentialSlot = DartDateRange(
            start: currentTime,
            end: currentTime.add(slotDuration),
          );

          // Check if this slot conflicts with any busy slots
          final hasConflict = _hasConflict(potentialSlot, sortedBusySlots);

          if (!hasConflict) {
            return currentTime;
          }

          // Move to next time slot
          currentTime = currentTime.add(slotInterval);
        }
      }
      // Move to next day
      searchDate = searchDate.addDays(1).startOfDay;
    }

    return null; // No slot found within search limit
  }

  /// Finds all available time slots within the given period.
  ///
  /// Returns a list of DateTime objects representing the start times
  /// of available slots.
  ///
  /// Parameters:
  /// - [period]: The time period to search within
  /// - [slotDuration]: The required duration of each slot
  /// - [busySlots]: List of already booked time ranges to avoid
  /// - [workingHours]: A function that returns the working hours
  /// for a given date
  /// - [workCalendar]: Optional business calendar for holidays and working days
  /// - [maxSlots]: Maximum number of slots to return (optional)
  /// - [slotInterval]: Minimum time between slot start times
  /// (default: [kDefaultSlotInterval])
  ///
  /// Example:
  /// ```dart
  /// final scheduler = ActivityScheduler();
  /// final workingHours = ClockTimeRange(
  ///   start: ClockTime(9),
  ///   end: ClockTime(17),
  /// );
  ///
  /// final availableSlots = scheduler.findAvailableSlots(
  ///   period: DartDateRange(
  ///     start: DateTime(2024, 1, 15),
  ///     end: DateTime(2024, 1, 19),
  ///   ),
  ///   slotDuration: Duration(hours: 1),
  ///   busySlots: [],
  ///   workingHours: (date) => [workingHours],
  ///   maxSlots: 10,
  /// );
  /// ```
  static List<DateTime> findAvailableSlots({
    required DartDateRange period,
    required Duration slotDuration,
    required List<DartDateRange> busySlots,
    required List<ClockTimeRange> Function(DateTime date) workingHours,
    WorkCalendar? workCalendar,
    int? maxSlots,
    Duration slotInterval = kDefaultSlotInterval,
  }) {
    if (slotDuration.inMicroseconds <= 0) {
      throw _ActivitySchedulerError.slotDurationNegativeError(slotDuration);
    }

    if (slotInterval.inMicroseconds <= 0) {
      throw _ActivitySchedulerError.slotIntervalNegativeError(slotInterval);
    }

    final availableSlots = <DateTime>[];
    var searchDate = period.start.startOfDay;
    final sortedBusySlots = List<DartDateRange>.from(busySlots)
      ..removeWhere((slot) => slot.start.isAfter(period.end))
      ..sort((a, b) => a.start.compareTo(b.start));

    while (searchDate.isSameOrBefore(period.end) &&
        (maxSlots == null || availableSlots.length < maxSlots)) {
      // Skip non-working days if calendar is provided
      if (workCalendar != null && !workCalendar.isWorkingDay(searchDate)) {
        searchDate = searchDate.addDays(1);
        continue;
      }

      final dayWorkingHours = workingHours(searchDate);
      for (final workingHour in dayWorkingHours) {
        final effectiveRange = workingHour.effectiveRange(searchDate);

        // Start search from max of period start or day start
        var currentTime = period.start.isAfter(effectiveRange.start)
            ? period.start
            : effectiveRange.start;

        // Search within this day's working hours
        while (
            currentTime.add(slotDuration).isSameOrBefore(effectiveRange.end) &&
                currentTime.isSameOrBefore(period.end) &&
                (maxSlots == null || availableSlots.length < maxSlots)) {
          final potentialSlot = DartDateRange(
            start: currentTime,
            end: currentTime.add(slotDuration),
          );

          // Check if this slot is within our search period
          if (potentialSlot.start.isSameOrAfter(period.start) &&
              potentialSlot.end.isSameOrBefore(period.end)) {
            // Check if this slot conflicts with any busy slots
            final hasConflict = _hasConflict(potentialSlot, sortedBusySlots);

            if (!hasConflict) {
              availableSlots.add(currentTime);
            }
          }

          // Move to next time slot
          currentTime = currentTime.add(slotInterval);
        }
      }
      // Move to next day
      searchDate = searchDate.addDays(1);
    }

    return availableSlots;
  }

  /// check if [potentialSlot] cross any [sortedBusySlots].
  ///
  /// [sortedBusySlots] must be sorted by start date.
  static bool _hasConflict(
    DartDateRange potentialSlot,
    List<DartDateRange> sortedBusySlots,
  ) {
    for (final busySlot in sortedBusySlots) {
      // Since busySlots are sorted by start time, if this busySlot starts
      // after our potential slot ends, no more conflicts are possible
      if (busySlot.start.isSameOrAfter(potentialSlot.end)) {
        break;
      }

      // Check for overlap
      if (busySlot.end.isAfter(potentialSlot.start) &&
          potentialSlot.end.isAfter(busySlot.start)) {
        return true;
      }
    }
    return false;
  }
}

abstract class _ActivitySchedulerError {
  static ArgumentError slotIntervalNegativeError(Duration slotInterval) =>
      ArgumentError.value(
        slotInterval,
        'slotInterval',
        'Interval must be positive',
      );

  static ArgumentError slotDurationNegativeError(Duration slotDuration) =>
      ArgumentError.value(
        slotDuration,
        'slotDuration',
        'Duration must be positive',
      );
}

import 'package:dart_time/dart_time.dart';
import 'package:meta/meta.dart';

const Set<int> _defaultWorkingDays = {
  DateTime.monday,
  DateTime.tuesday,
  DateTime.wednesday,
  DateTime.thursday,
  DateTime.friday,
};

/// [WorkCalendar] represents a business calendar with working days and holidays.
///
/// This class helps determine working days, calculate business day differences,
/// and navigate between working days while respecting holidays and weekends.
///
/// **Key Features:**
/// - Define custom working days (default: Monday-Friday)
/// - Manage holidays (full-day events)
/// - Calculate business days between dates
/// - Navigate to next/previous working days
/// - Check if specific dates are working days
///
/// **Example:**
/// ```dart
/// // Standard business calendar (Mon-Fri, with holidays)
/// final calendar = WorkCalendar(
///   holidays: {
///     DateTime(2024, 1, 1),   // New Year's Day
///     DateTime(2024, 12, 25), // Christmas
///     DateTime(2024, 7, 4),   // Independence Day
///   },
/// );
///
/// // Check if today is a working day
/// if (calendar.isWorkingDay(DateTime.now())) {
///   print('Today is a working day!');
/// }
///
/// // Find next working day
/// final nextWorkDay = calendar.nextWorkingDay(DateTime.now());
/// print('Next working day: $nextWorkDay');
///
/// // Calculate business days between dates
/// final businessDays = calendar.businessDaysBetween(
///   DateTime(2024, 1, 1),
///   DateTime(2024, 1, 31),
/// );
/// print('Business days in January: $businessDays');
/// ```
///
/// **Custom Working Schedule:**
/// ```dart
/// // 6-day work week (exclude Sunday only)
/// final calendar = WorkCalendar(
///   workingDays: {
///     DateTime.monday,
///     DateTime.tuesday,
///     DateTime.wednesday,
///     DateTime.thursday,
///     DateTime.friday,
///     DateTime.saturday,
///   },
///   holidays: {DateTime(2024, 12, 25)},
/// );
/// ```
@immutable
class WorkCalendar {
  /// Creates a new [WorkCalendar] instance.
  ///
  /// **Parameters:**
  /// - [holidays]: Set of dates that are considered non-working days.
  ///   If not provided, defaults to an empty set.
  ///   **Important:** Only the date part is considered (year, month, day).
  ///   Time components (hours, minutes, seconds) are ignored and normalized
  ///   to midnight (00:00:00.000).
  ///
  /// - [workingDays]: Set of weekday numbers (1-7) that are considered
  ///   working days. Uses [DateTime] constants:
  ///   - `DateTime.monday` (1)
  ///   - `DateTime.tuesday` (2)
  ///   - `DateTime.wednesday` (3)
  ///   - `DateTime.thursday` (4)
  ///   - `DateTime.friday` (5)
  ///   - `DateTime.saturday` (6)
  ///   - `DateTime.sunday` (7)
  ///
  ///   If not provided, defaults to Monday through Friday.
  ///
  /// **Holiday Normalization:**
  /// All holidays are automatically normalized to start-of-day (midnight)
  /// to ensure consistent comparison regardless of the time provided.
  ///
  /// **Example:**
  /// ```dart
  /// final calendar = WorkCalendar(
  ///   holidays: {
  ///     DateTime(2024, 1, 1, 15, 30), // Normalized to 2024-01-01 00:00:00
  ///     DateTime(2024, 12, 25),       // Already at 2024-12-25 00:00:00
  ///   },
  ///   workingDays: {
  ///     DateTime.monday,
  ///     DateTime.tuesday,
  ///     DateTime.wednesday,
  ///     DateTime.thursday,
  ///     DateTime.friday,
  ///   },
  /// );
  /// ```
  factory WorkCalendar({
    Set<DateTime>? holidays,
    Set<int>? workingDays,
  }) {
    // Validate working days
    if (workingDays != null) {
      for (final day in workingDays) {
        if (day < DateTime.monday || day > DateTime.sunday) {
          throw _WorkCalendarError.workingDayOutOfRangeError(day);
        }
      }

      if (workingDays.isEmpty) {
        throw _WorkCalendarError.workingDaysEmptyError(workingDays);
      }
    }

    return WorkCalendar._(
      // set all holidays to start-of-day
      holidays:
          (holidays ?? <DateTime>{}).map((date) => date.startOfDay).toSet(),
      workingDays: workingDays ?? _defaultWorkingDays,
    );
  }

  const WorkCalendar._({
    required this.holidays,
    required this.workingDays,
  });

  /// Set of holidays (normalized to start-of-day).
  ///
  /// All dates in this set represent full-day holidays and are normalized
  /// to midnight (00:00:00.000) for consistent comparison.
  final Set<DateTime> holidays;

  /// Set of working weekday numbers (1-7).
  ///
  /// Uses [DateTime] weekday constants:
  /// - 1 = Monday
  /// - 2 = Tuesday
  /// - 3 = Wednesday
  /// - 4 = Thursday
  /// - 5 = Friday
  /// - 6 = Saturday
  /// - 7 = Sunday
  final Set<int> workingDays;

  /// Checks if the given [date] is a working day.
  ///
  /// A date is considered a working day if:
  /// 1. Its weekday is in the [workingDays] set
  /// 2. It is not a holiday
  ///
  /// The time component of [date] is ignored.
  ///
  /// **Example:**
  /// ```dart
  /// final calendar = WorkCalendar(
  ///   holidays: {DateTime(2024, 1, 1)}, // New Year's Day
  /// );
  ///
  /// // Monday, not a holiday
  /// calendar.isWorkingDay(DateTime(2024, 1, 8));    // true
  ///
  /// // Saturday (weekend)
  /// calendar.isWorkingDay(DateTime(2024, 1, 6));    // false
  ///
  /// // Monday, but it's New Year's Day (holiday)
  /// calendar.isWorkingDay(DateTime(2024, 1, 1));    // false
  /// ```
  bool isWorkingDay(DateTime date) {
    return workingDays.contains(date.weekday) && !isHoliday(date);
  }

  /// Gets the next working day after the given [date].
  ///
  /// Searches forward from [date] + 1 day until a working day is found.
  /// The returned date will be at the start of the working day (midnight).
  ///
  /// **Note:** This method can potentially search indefinitely if there are
  /// no working days defined. Use [nextWorkingDayWithLimit] for safer operation.
  ///
  /// **Example:**
  /// ```dart
  /// final calendar = WorkCalendar();
  ///
  /// // Friday -> Monday (skips weekend)
  /// final friday = DateTime(2024, 1, 5);
  /// final nextWorking = calendar.nextWorkingDay(friday);
  /// // Returns: 2024-01-08 00:00:00.000 (Monday)
  /// ```
  DateTime nextWorkingDay(DateTime date) {
    var nextDate = date.addDays(1).startOfDay;
    while (!isWorkingDay(nextDate)) {
      nextDate = nextDate.addDays(1);
    }
    return nextDate;
  }

  /// Gets the next working day after [date] with a search limit.
  ///
  /// Similar to [nextWorkingDay] but stops searching after [maxDays] days
  /// to prevent infinite loops.
  ///
  /// Returns `null` if no working day is found within the limit.
  ///
  /// **Example:**
  /// ```dart
  /// final calendar = WorkCalendar();
  /// final nextWorking = calendar.nextWorkingDayWithLimit(
  ///   DateTime(2024, 1, 5),
  ///   maxDays: 10,
  /// );
  /// ```
  DateTime? nextWorkingDayWithLimit(
    DateTime date, {
    int maxDays = 365,
  }) {
    if (maxDays <= 0) {
      throw _WorkCalendarError.maxDaysNegativeError(maxDays);
    }

    var nextDate = date.addDays(1).startOfDay;
    var daysSearched = 0;

    while (daysSearched < maxDays) {
      if (isWorkingDay(nextDate)) {
        return nextDate;
      }
      nextDate = nextDate.addDays(1);
      daysSearched++;
    }

    return null;
  }

  /// Gets the previous working day before the given [date].
  ///
  /// Searches backward from [date] - 1 day until a working day is found.
  /// The returned date will be at the start of the working day (midnight).
  ///
  /// **Example:**
  /// ```dart
  /// final calendar = WorkCalendar();
  ///
  /// // Monday -> Friday (skips weekend)
  /// final monday = DateTime(2024, 1, 8);
  /// final prevWorking = calendar.previousWorkingDay(monday);
  /// // Returns: 2024-01-05 00:00:00.000 (Friday)
  /// ```
  DateTime previousWorkingDay(DateTime date) {
    var prevDate = date.addDays(-1).startOfDay;
    while (!isWorkingDay(prevDate)) {
      prevDate = prevDate.addDays(-1);
    }
    return prevDate;
  }

  /// Gets the previous working day before [date] with a search limit.
  ///
  /// Similar to [previousWorkingDay] but stops searching after [maxDays] days
  /// to prevent infinite loops.
  ///
  /// Returns `null` if no working day is found within the limit.
  DateTime? previousWorkingDayWithLimit(
    DateTime date, {
    int maxDays = 365,
  }) {
    if (maxDays <= 0) {
      throw _WorkCalendarError.maxDaysNegativeError(maxDays);
    }

    var prevDate = date.addDays(-1).startOfDay;
    var daysSearched = 0;

    while (daysSearched < maxDays) {
      if (isWorkingDay(prevDate)) {
        return prevDate;
      }
      prevDate = prevDate.addDays(-1);
      daysSearched++;
    }

    return null;
  }

  /// Checks if the given [date] is a holiday.
  ///
  /// Only considers the date part (year, month, day). Time components
  /// are ignored by normalizing to start-of-day before comparison.
  ///
  /// **Example:**
  /// ```dart
  /// final calendar = WorkCalendar(
  ///   holidays: {DateTime(2024, 12, 25)},
  /// );
  ///
  /// // All of these return true (time is ignored)
  /// calendar.isHoliday(DateTime(2024, 12, 25));
  /// calendar.isHoliday(DateTime(2024, 12, 25, 15, 30));
  /// calendar.isHoliday(DateTime(2024, 12, 25, 23, 59, 59));
  /// ```
  bool isHoliday(DateTime date) {
    return holidays.contains(date.startOfDay);
  }

  /// Creates a copy of this calendar with modified properties.
  ///
  /// **Example:**
  /// ```dart
  /// final original = WorkCalendar();
  /// final withHolidays = original.copyWith(
  ///   holidays: {DateTime(2024, 12, 25), DateTime(2024, 1, 1)},
  /// );
  /// ```
  WorkCalendar copyWith({
    Set<DateTime>? holidays,
    Set<int>? workingDays,
  }) {
    return WorkCalendar(
      holidays: holidays ?? this.holidays,
      workingDays: workingDays ?? this.workingDays,
    );
  }

  /// Gets all working days within the specified date range.
  ///
  /// Returns a list of DateTime objects representing working days
  /// between [start] and [end].
  ///
  /// throws an [ArgumentError] if [start] is after [end].
  ///
  /// [inclusive] determines if the [start]
  /// and [end] dates are included in the result.
  ///
  /// **Example:**
  /// ```dart
  /// final calendar = WorkCalendar();
  /// final workingDays = calendar.getWorkingDaysInRange(
  ///   DateTime(2024, 1, 1),  // Monday
  ///   DateTime(2024, 1, 7),  // Sunday
  /// );
  /// // Returns: [2024-01-01, 2024-01-02, 2024-01-03, 2024-01-04, 2024-01-05]
  /// ```
  List<DateTime> workingDaysBetween({
    required DateTime start,
    required DateTime end,
    bool? inclusive,
  }) {
    final normalizedStart = start.startOfDay;
    final normalizedEnd = end.startOfDay;

    if (normalizedStart.isAfter(normalizedEnd)) {
      throw _WorkCalendarError.startAfterEndError(
        normalizedStart,
        normalizedEnd,
      );
    }

    inclusive ??= false;

    final workingDays = <DateTime>[];
    var currentDate = inclusive ? normalizedStart : normalizedStart.addDays(1);

    final endDate = inclusive ? normalizedEnd : normalizedEnd.addDays(-1);

    while (currentDate.isSameOrBefore(endDate)) {
      if (isWorkingDay(currentDate)) {
        workingDays.add(currentDate);
      }
      currentDate = currentDate.addDays(1);
    }

    return workingDays;
  }

  /// Checks if all dates in the range are working days.
  ///
  /// Returns `true` if every date between [start] and [end] (inclusive)
  /// is a working day. Returns `false` if any date is a weekend or holiday.
  ///
  /// throws an [ArgumentError] if [start] is after [end].
  ///
  /// **Example:**
  /// ```dart
  /// final calendar = WorkCalendar();
  ///
  /// // Monday to Friday (all working days)
  /// calendar.isWorkingPeriod(
  ///   DateTime(2024, 1, 8),  // Monday
  ///   DateTime(2024, 1, 12), // Friday
  /// ); // true
  ///
  /// // Friday to Monday (includes weekend)
  /// calendar.isWorkingPeriod(
  ///   DateTime(2024, 1, 5),  // Friday
  ///   DateTime(2024, 1, 8),  // Monday
  /// ); // false
  /// ```
  bool isWorkingPeriod({
    required DateTime start,
    required DateTime end,
  }) {
    final normalizedStart = start.startOfDay;
    final normalizedEnd = end.startOfDay;

    if (normalizedStart.isAfter(normalizedEnd)) {
      throw _WorkCalendarError.startAfterEndError(
        normalizedStart,
        normalizedEnd,
      );
    }

    var currentDate = normalizedStart;
    while (currentDate.isSameOrBefore(normalizedEnd)) {
      if (!isWorkingDay(currentDate)) {
        return false;
      }
      currentDate = currentDate.addDays(1);
    }

    return true;
  }

  @override
  bool operator ==(Object other) {
    if (other is WorkCalendar) {
      return holidays == other.holidays && workingDays == other.workingDays;
    }
    return false;
  }

  @override
  int get hashCode => Object.hashAll([holidays, workingDays]);

  @override
  String toString() =>
      'WorkCalendar(holidays: $holidays, workingDays: $workingDays)';
}

abstract class _WorkCalendarError {
  static ArgumentError startAfterEndError(DateTime start, DateTime end) =>
      ArgumentError.value(
        start,
        'start',
        'Start date must be before or equal to end date',
      );

  static ArgumentError maxDaysNegativeError(int maxDays) => ArgumentError.value(
        maxDays,
        'maxDays',
        'Must be positive',
      );

  static ArgumentError workingDaysEmptyError(Set<int> workingDays) =>
      ArgumentError.value(
        workingDays,
        'workingDays',
        'Must have at least one working day',
      );

  static ArgumentError workingDayOutOfRangeError(int workingDay) =>
      ArgumentError.value(
        workingDay,
        'workingDay',
        'Working day must be between ${DateTime.monday}'
            ' and ${DateTime.sunday}',
      );
}

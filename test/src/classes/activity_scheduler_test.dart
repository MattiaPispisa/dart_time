import 'package:dart_time/dart_time.dart';
import 'package:test/test.dart';

void main() {
  group('ActivityScheduler', () {
    // Common test data
    final workingHours = [
      ClockTimeRange(
        start: ClockTime(9),
        end: ClockTime(17),
      ),
    ];

    List<ClockTimeRange> workingHoursFunction(DateTime _) => workingHours;

    final nightShiftHours = [
      ClockTimeRange(
        start: ClockTime(22),
        end: ClockTime(6), // Crosses midnight
      ),
    ];

    final splitShiftHours = [
      ClockTimeRange(
        start: ClockTime(9),
        end: ClockTime(12),
      ),
      ClockTimeRange(
        start: ClockTime(14),
        end: ClockTime(17),
      ),
    ];

    final monday = DateTimeHelper.named(
      year: 2024,
      month: DateTime.january,
      day: 8,
    ); // Monday
    final tuesday = DateTimeHelper.named(
      year: 2024,
      month: DateTime.january,
      day: 9,
    ); // Tuesday
    final wednesday = DateTimeHelper.named(
      year: 2024,
      month: DateTime.january,
      day: 10,
    ); // Wednesday
    final friday = DateTimeHelper.named(
      year: 2024,
      month: DateTime.january,
      day: 12,
    ); // Friday
    final saturday = DateTimeHelper.named(
      year: 2024,
      month: DateTime.january,
      day: 13,
    ); // Saturday

    group('findNextSlot', () {
      test('should find next available slot in working hours', () {
        final from = monday.copyWith(hour: 8); // Monday 08:00
        const slotDuration = Duration(hours: 1);

        final nextSlot = ActivityScheduler.findNextSlot(
          from: from,
          slotDuration: slotDuration,
          slotInterval: kDefaultSlotInterval,
          busySlots: [],
          workingHours: workingHoursFunction,
        );

        expect(nextSlot, isNotNull);
        expect(nextSlot!.isAfter(from), isTrue);
        expect(
          nextSlot.hour,
          greaterThanOrEqualTo(9),
          reason: 'should be after start of working hours',
        );
        expect(
          nextSlot.hour,
          lessThanOrEqualTo(17),
          reason: 'should be before end of working hours',
        );
      });

      test('should skip busy slots', () {
        final from = monday.copyWith(hour: 9); // Monday 9:00
        const slotDuration = Duration(hours: 1);
        final busySlot = DartDateRange(
          start: monday.copyWith(hour: 9, minute: 30),
          end: monday.copyWith(hour: 12),
        );

        final nextSlot = ActivityScheduler.findNextSlot(
          from: from,
          slotDuration: slotDuration,
          slotInterval: kDefaultSlotInterval,
          busySlots: [busySlot],
          workingHours: workingHoursFunction,
        );

        expect(nextSlot, isNotNull);
        expect(nextSlot!.isSameDay(monday), isTrue);
        expect(nextSlot.hour, 12);
      });

      test('should skip weekends when using WorkCalendar', () {
        final calendar = WorkCalendar(); // Default Mon-Fri
        final from = friday.copyWith(hour: 16); // Friday 16:00
        const slotDuration = Duration(hours: 2);

        final nextSlot = ActivityScheduler.findNextSlot(
          from: from,
          slotDuration: slotDuration,
          slotInterval: kDefaultSlotInterval,
          busySlots: [],
          workingHours: workingHoursFunction,
          workCalendar: calendar,
        );

        expect(nextSlot, isNotNull);
        expect(
          nextSlot!.weekday,
          equals(DateTime.monday),
          reason: 'should be on next working day',
        );
      });

      test('should skip holidays when using WorkCalendar', () {
        final calendar = WorkCalendar(
          holidays: {tuesday}, // Tuesday is a holiday
        );
        final from = monday.copyWith(hour: 16); // Monday 16:00
        const slotDuration = Duration(hours: 2);

        final nextSlot = ActivityScheduler.findNextSlot(
          from: from,
          slotDuration: slotDuration,
          slotInterval: kDefaultSlotInterval,
          busySlots: [],
          workingHours: workingHoursFunction,
          workCalendar: calendar,
        );

        expect(nextSlot, isNotNull);
        expect(
          nextSlot!.weekday,
          equals(DateTime.wednesday),
          reason: 'Should skip Tuesday (holiday) and be on Wednesday',
        );
      });

      test('should handle overnight shifts - start before midnight', () {
        List<ClockTimeRange> nightShiftFunction(DateTime date) =>
            nightShiftHours;
        final from = monday.copyWith(hour: 23); // Monday 23:00
        const slotDuration = Duration(hours: 2);

        final nextSlot = ActivityScheduler.findNextSlot(
          from: from,
          slotDuration: slotDuration,
          slotInterval: kDefaultSlotInterval,
          busySlots: [],
          workingHours: nightShiftFunction,
        );

        expect(nextSlot, isNotNull);
        // Should start at 23:00 and cross midnight
        expect(nextSlot!.hour, equals(23));
        expect(nextSlot.isSameDay(monday), isTrue);
      });

      test('should handle overnight shifts - cross midnight boundary', () {
        List<ClockTimeRange> nightShiftFunction(DateTime date) =>
            nightShiftHours;
        final from =
            tuesday.copyWith(hour: 23); // Tuesday 01:00 (early morning)
        const slotDuration = Duration(hours: 2);

        final nextSlot = ActivityScheduler.findNextSlot(
          from: from,
          slotDuration: slotDuration,
          slotInterval: kDefaultSlotInterval,
          busySlots: [],
          workingHours: nightShiftFunction,
        );

        expect(nextSlot, isNotNull);
        // Should find slot in early morning hours (before 6:00)
        expect(nextSlot!.hour, 23); // 6:00 - 2 hours
        expect(nextSlot.isSameDay(tuesday), isTrue);
      });

      test('should handle overnight shifts - slot spans midnight', () {
        List<ClockTimeRange> nightShiftFunction(DateTime date) =>
            nightShiftHours;
        final from = monday.copyWith(hour: 22, minute: 30); // Monday 22:30
        const slotDuration = Duration(hours: 3); // Spans midnight

        final nextSlot = ActivityScheduler.findNextSlot(
          from: from,
          slotDuration: slotDuration,
          slotInterval: kDefaultSlotInterval,
          busySlots: [],
          workingHours: nightShiftFunction,
        );

        expect(nextSlot, isNotNull);
        // Should start before midnight but end after midnight
        expect(nextSlot!.hour, greaterThanOrEqualTo(22));

        // Verify the slot actually spans midnight by checking end time
        final slotEnd = nextSlot.add(slotDuration);
        expect(slotEnd.day, equals(nextSlot.day + 1));
        expect(slotEnd.hour, lessThanOrEqualTo(6));
      });

      test('should handle split shift schedules', () {
        List<ClockTimeRange> splitShiftFunction(DateTime date) =>
            splitShiftHours;
        final from = monday.copyWith(hour: 11, minute: 30); // Monday 11:30
        const slotDuration = Duration(hours: 1);

        final nextSlot = ActivityScheduler.findNextSlot(
          from: from,
          slotDuration: slotDuration,
          slotInterval: kDefaultSlotInterval,
          busySlots: [],
          workingHours: splitShiftFunction,
        );

        expect(nextSlot, isNotNull);
        // Should be in afternoon shift (14:00-17:00)
        expect(nextSlot!.hour, greaterThanOrEqualTo(14));
        expect(nextSlot.hour, lessThanOrEqualTo(16)); // 17:00 - 1 hour
      });

      test('should respect custom slot intervals', () {
        final from = monday.copyWith(hour: 9); // Monday 9:00
        const slotDuration = Duration(minutes: 30);
        const customInterval = Duration(minutes: 30);

        final nextSlot = ActivityScheduler.findNextSlot(
          from: from,
          slotDuration: slotDuration,
          slotInterval: customInterval,
          busySlots: [],
          workingHours: workingHoursFunction,
        );

        expect(nextSlot, isNotNull);
        // Should be aligned to 30-minute intervals
        expect(nextSlot!.minute % 30, equals(0));
      });

      test('should return null when no slot found within search limit', () {
        // Create a scenario where no slots are available
        final from = monday.copyWith(hour: 9);
        const slotDuration = Duration(hours: 10); // Too long for working hours

        final nextSlot = ActivityScheduler.findNextSlot(
          from: from,
          slotDuration: slotDuration,
          slotInterval: kDefaultSlotInterval,
          busySlots: [],
          workingHours: workingHoursFunction,
          searchLimitInDays: 1, // Very short search limit
        );

        expect(nextSlot, isNull);
      });

      test('should throw error for negative slot duration', () {
        final from = monday.copyWith(hour: 9);
        const negativeDuration = Duration(hours: -1);

        expect(
          () => ActivityScheduler.findNextSlot(
            from: from,
            slotDuration: negativeDuration,
            slotInterval: kDefaultSlotInterval,
            busySlots: [],
            workingHours: workingHoursFunction,
          ),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should throw error for negative slot interval', () {
        final from = monday.copyWith(hour: 9);
        const slotDuration = Duration(hours: 1);
        const negativeInterval = Duration(minutes: -15);

        expect(
          () => ActivityScheduler.findNextSlot(
            from: from,
            slotDuration: slotDuration,
            slotInterval: negativeInterval,
            busySlots: [],
            workingHours: workingHoursFunction,
          ),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should handle multiple busy slots efficiently', () {
        final from = monday.copyWith(hour: 9);
        const slotDuration = Duration(hours: 1);
        final busySlots = [
          DartDateRange(
            start: monday.copyWith(hour: 10),
            end: monday.copyWith(hour: 11),
          ),
          DartDateRange(
            start: monday.copyWith(hour: 14),
            end: monday.copyWith(hour: 15),
          ),
          DartDateRange(
            start: monday.copyWith(hour: 16),
            end: monday.copyWith(hour: 17),
          ),
        ];

        final nextSlot = ActivityScheduler.findNextSlot(
          from: from,
          slotDuration: slotDuration,
          slotInterval: kDefaultSlotInterval,
          busySlots: busySlots,
          workingHours: workingHoursFunction,
        );

        expect(nextSlot, isNotNull);
        // Should find available slot between busy periods
        expect(
          nextSlot!.isBetween(
                monday.copyWith(hour: 9),
                monday.copyWith(hour: 10),
              ) ||
              nextSlot.isBetween(
                monday.copyWith(hour: 11),
                monday.copyWith(hour: 14),
              ) ||
              nextSlot.isBetween(
                monday.copyWith(hour: 15),
                monday.copyWith(hour: 16),
              ),
          isTrue,
        );
      });
    });

    group('findAvailableSlots', () {
      test('should find all available slots in period', () {
        final period = DartDateRange(
          start: monday.copyWith(hour: 9),
          end: monday.copyWith(hour: 17),
        );
        const slotDuration = Duration(hours: 1);

        final availableSlots = ActivityScheduler.findAvailableSlots(
          period: period,
          slotDuration: slotDuration,
          busySlots: [],
          workingHours: workingHoursFunction,
        );

        expect(availableSlots, isNotEmpty);
        // Should have multiple slots (8 hours / 1 hour each, with 15-min intervals)
        expect(availableSlots.length, greaterThan(1));

        // All slots should be within working hours
        for (final slot in availableSlots) {
          expect(slot.hour, greaterThanOrEqualTo(9));
          expect(
            slot.hour,
            lessThanOrEqualTo(16),
          ); // Last possible start for 1-hour slot
        }
      });

      test('should respect maxSlots parameter', () {
        final period = DartDateRange(
          start: monday.copyWith(hour: 9),
          end: monday.copyWith(hour: 17),
        );
        const slotDuration = Duration(minutes: 30);
        const maxSlots = 5;

        final availableSlots = ActivityScheduler.findAvailableSlots(
          period: period,
          slotDuration: slotDuration,
          busySlots: [],
          workingHours: workingHoursFunction,
          maxSlots: maxSlots,
        );

        expect(availableSlots.length, lessThanOrEqualTo(maxSlots));
      });

      test('should exclude busy slots from results', () {
        final period = DartDateRange(
          start: monday.copyWith(hour: 9),
          end: monday.copyWith(hour: 17),
        );
        const slotDuration = Duration(hours: 1);
        final busySlot = DartDateRange(
          start: monday.copyWith(hour: 11),
          end: monday.copyWith(hour: 13),
        );

        final availableSlots = ActivityScheduler.findAvailableSlots(
          period: period,
          slotDuration: slotDuration,
          busySlots: [busySlot],
          workingHours: workingHoursFunction,
        );

        // No slots should overlap with busy period
        for (final slot in availableSlots) {
          final slotEnd = slot.add(slotDuration);
          expect(
            slot.isSameOrAfter(monday.copyWith(hour: 13)) ||
                slotEnd.isSameOrBefore(monday.copyWith(hour: 11)),
            isTrue,
          );
        }
      });

      test('should work across multiple days', () {
        final period = DartDateRange(
          start: monday.copyWith(hour: 16),
          end: wednesday.copyWith(hour: 11),
        );
        const slotDuration = Duration(hours: 1);

        final availableSlots = ActivityScheduler.findAvailableSlots(
          period: period,
          slotDuration: slotDuration,
          busySlots: [],
          workingHours: workingHoursFunction,
        );

        expect(availableSlots, isNotEmpty);

        // Should have slots across multiple days
        final uniqueDays = availableSlots.map((slot) => slot.day).toSet();
        expect(uniqueDays.length, greaterThan(1));
      });

      test('should respect WorkCalendar when provided', () {
        final calendar = WorkCalendar(
          holidays: {tuesday}, // Tuesday is a holiday
        );
        final period = DartDateRange(
          start: monday.copyWith(hour: 9),
          end: wednesday.copyWith(hour: 17),
        );
        const slotDuration = Duration(hours: 1);

        final availableSlots = ActivityScheduler.findAvailableSlots(
          period: period,
          slotDuration: slotDuration,
          busySlots: [],
          workingHours: workingHoursFunction,
          workCalendar: calendar,
        );

        // No slots should be on Tuesday (holiday)
        final tuesdaySlots =
            availableSlots.where((slot) => slot.day == tuesday.day);
        expect(tuesdaySlots, isEmpty);
      });

      test('should handle split shift schedules', () {
        List<ClockTimeRange> splitShiftFunction(DateTime date) =>
            splitShiftHours;
        final period = DartDateRange(
          start: monday.copyWith(hour: 8),
          end: monday.copyWith(hour: 18),
        );
        const slotDuration = Duration(hours: 1);

        final availableSlots = ActivityScheduler.findAvailableSlots(
          period: period,
          slotDuration: slotDuration,
          busySlots: [],
          workingHours: splitShiftFunction,
        );

        // All slots should be within working hours (9-12 or 14-17)
        for (final slot in availableSlots) {
          expect(
            (slot.hour >= 9 && slot.hour <= 11) ||
                (slot.hour >= 14 && slot.hour <= 16),
            isTrue,
          );
        }
      });

      test('should handle custom slot intervals', () {
        final period = DartDateRange(
          start: monday.copyWith(hour: 9),
          end: monday.copyWith(hour: 11),
        );
        const slotDuration = Duration(minutes: 30);
        const customInterval = Duration(minutes: 30);

        final availableSlots = ActivityScheduler.findAvailableSlots(
          period: period,
          slotDuration: slotDuration,
          busySlots: [],
          workingHours: workingHoursFunction,
          slotInterval: customInterval,
        );

        // Slots should be 30 minutes apart
        for (var i = 1; i < availableSlots.length; i++) {
          final timeDiff = availableSlots[i].difference(availableSlots[i - 1]);
          expect(timeDiff, greaterThanOrEqualTo(customInterval));
        }
      });

      test('should handle overnight shifts in findAvailableSlots', () {
        List<ClockTimeRange> nightShiftFunction(DateTime date) =>
            nightShiftHours;
        final period = DartDateRange(
          start: monday.copyWith(hour: 22),
          end: tuesday.copyWith(hour: 7), // Cross midnight
        );
        const slotDuration = Duration(hours: 1);

        final availableSlots = ActivityScheduler.findAvailableSlots(
          period: period,
          slotDuration: slotDuration,
          busySlots: [],
          workingHours: nightShiftFunction,
        );

        expect(availableSlots, isNotEmpty);

        // Should have slots both before and after midnight
        final slotsBeforeMidnight = availableSlots
            .where((slot) => slot.day == monday.day && slot.hour >= 22);
        final slotsAfterMidnight = availableSlots
            .where((slot) => slot.day == tuesday.day && slot.hour < 6);

        expect(slotsBeforeMidnight, isNotEmpty);
        expect(slotsAfterMidnight, isNotEmpty);
      });

      test('should throw error for negative slot duration', () {
        final period = DartDateRange(
          start: monday.copyWith(hour: 9),
          end: monday.copyWith(hour: 17),
        );
        const negativeDuration = Duration(hours: -1);

        expect(
          () => ActivityScheduler.findAvailableSlots(
            period: period,
            slotDuration: negativeDuration,
            busySlots: [],
            workingHours: workingHoursFunction,
          ),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should throw error for negative slot interval', () {
        final period = DartDateRange(
          start: monday.copyWith(hour: 9),
          end: monday.copyWith(hour: 17),
        );
        const slotDuration = Duration(hours: 1);
        const negativeInterval = Duration(minutes: -15);

        expect(
          () => ActivityScheduler.findAvailableSlots(
            period: period,
            slotDuration: slotDuration,
            busySlots: [],
            workingHours: workingHoursFunction,
            slotInterval: negativeInterval,
          ),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should return empty list when no slots available', () {
        final period = DartDateRange(
          start: saturday.copyWith(hour: 9), // Saturday (weekend)
          end: saturday.copyWith(hour: 17),
        );
        final calendar = WorkCalendar(); // Default Mon-Fri
        const slotDuration = Duration(hours: 1);

        final availableSlots = ActivityScheduler.findAvailableSlots(
          period: period,
          slotDuration: slotDuration,
          busySlots: [],
          workingHours: workingHoursFunction,
          workCalendar: calendar,
        );

        expect(availableSlots, isEmpty);
      });

      test('should handle period entirely within busy slots', () {
        final period = DartDateRange(
          start: monday.copyWith(hour: 10),
          end: monday.copyWith(hour: 12),
        );
        final busySlot = DartDateRange(
          start: monday.copyWith(hour: 9),
          end: monday.copyWith(hour: 13),
        );
        const slotDuration = Duration(hours: 1);

        final availableSlots = ActivityScheduler.findAvailableSlots(
          period: period,
          slotDuration: slotDuration,
          busySlots: [busySlot],
          workingHours: workingHoursFunction,
        );

        expect(availableSlots, isEmpty);
      });
    });

    group('Edge Cases and Integration', () {
      test('should handle very short slots', () {
        final from = monday.copyWith(hour: 9);
        const veryShortDuration = Duration(minutes: 1);

        final nextSlot = ActivityScheduler.findNextSlot(
          from: from,
          slotDuration: veryShortDuration,
          slotInterval: kDefaultSlotInterval,
          busySlots: [],
          workingHours: workingHoursFunction,
        );

        expect(nextSlot, isNotNull);
        expect(nextSlot!.isSameDay(monday), isTrue);
        expect(nextSlot.hour, 9);
      });

      test('should handle very long slots', () {
        final from = monday.copyWith(hour: 9);
        const veryLongDuration = Duration(hours: 8);

        final nextSlot = ActivityScheduler.findNextSlot(
          from: from,
          slotDuration: veryLongDuration,
          slotInterval: kDefaultSlotInterval,
          busySlots: [],
          workingHours: workingHoursFunction,
        );

        expect(nextSlot, isNotNull);
        // Should fit exactly in working hours (9-17 = 8 hours)
        expect(nextSlot!.hour, equals(9));
      });

      test('should handle empty working hours', () {
        List<ClockTimeRange> emptyWorkingHours(DateTime date) =>
            <ClockTimeRange>[];
        final from = monday.copyWith(hour: 9);
        const slotDuration = Duration(hours: 1);

        final nextSlot = ActivityScheduler.findNextSlot(
          from: from,
          slotDuration: slotDuration,
          slotInterval: kDefaultSlotInterval,
          busySlots: [],
          workingHours: emptyWorkingHours,
        );

        expect(nextSlot, isNull);
      });

      test('should handle midnight edge cases', () {
        final from = monday.copyWith(hour: 23, minute: 30);
        List<ClockTimeRange> nightShiftFunction(DateTime date) =>
            nightShiftHours;
        const slotDuration = Duration(hours: 1);

        final nextSlot = ActivityScheduler.findNextSlot(
          from: from,
          slotDuration: slotDuration,
          slotInterval: kDefaultSlotInterval,
          busySlots: [],
          workingHours: nightShiftFunction,
        );

        expect(nextSlot, isNotNull);
        // Should handle transition across midnight
      });

      test('should handle zero duration slots', () {
        final from = monday.copyWith(hour: 9);
        const zeroDuration = Duration.zero;

        expect(
          () => ActivityScheduler.findNextSlot(
            from: from,
            slotDuration: zeroDuration,
            slotInterval: kDefaultSlotInterval,
            busySlots: [],
            workingHours: workingHoursFunction,
          ),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should optimize with sorted busy slots', () {
        final from = monday.copyWith(hour: 9);
        const slotDuration = Duration(hours: 1);

        // Create many busy slots out of order
        final busySlots = <DartDateRange>[];
        for (var i = 20; i >= 10; i--) {
          busySlots.add(
            DartDateRange(
              start: monday.copyWith(hour: i),
              end: monday.copyWith(hour: i + 1),
            ),
          );
        }

        final nextSlot = ActivityScheduler.findNextSlot(
          from: from,
          slotDuration: slotDuration,
          slotInterval: kDefaultSlotInterval,
          busySlots: busySlots,
          workingHours: workingHoursFunction,
        );

        expect(nextSlot, isNotNull);
        expect(nextSlot!.isSameDay(monday), isTrue);
        expect(nextSlot.hour, 9);
      });
    });

    group('Constants', () {
      test('should use correct default values', () {
        expect(kDefaultSlotInterval, equals(const Duration(minutes: 15)));
        expect(kDefaultSearchLimitInDays, equals(30));
      });
    });
  });
}

// Helper extension for testing
extension DateTimeTestHelpers on DateTime {
  bool isBetween(DateTime start, DateTime end) {
    return isSameOrAfter(start) && isSameOrBefore(end);
  }
}

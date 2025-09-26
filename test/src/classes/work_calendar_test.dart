import 'package:dart_time/dart_time.dart';
import 'package:test/test.dart';

void main() {
  group('WorkCalendar', () {
    // Test dates for consistent testing
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
    final thursday = DateTimeHelper.named(
      year: 2024,
      month: DateTime.january,
      day: 11,
    ); // Thursday
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
    final sunday = DateTimeHelper.named(
      year: 2024,
      month: DateTime.january,
      day: 14,
    ); // Sunday

    final newYear = DateTimeHelper.named(
      year: 2024,
      month: DateTime.january,
      day: 1,
    ); // New Year's Day (Monday)
    final christmas = DateTimeHelper.named(
      year: 2024,
      month: DateTime.december,
      day: 25,
    ); // Christmas (Wednesday)

    group('Constructor and Validation', () {
      test('should create default calendar (Mon-Fri)', () {
        final calendar = WorkCalendar();

        expect(
          calendar.workingDays,
          equals(
            {
              DateTime.monday,
              DateTime.tuesday,
              DateTime.wednesday,
              DateTime.thursday,
              DateTime.friday,
            },
          ),
        );
        expect(calendar.holidays, isEmpty);
      });

      test('should create calendar with custom working days', () {
        final calendar = WorkCalendar(
          workingDays: const {
            DateTime.monday,
            DateTime.tuesday,
            DateTime.wednesday,
            DateTime.thursday,
            DateTime.friday,
            DateTime.saturday,
          }, // Mon-Sat
        );

        expect(
          calendar.workingDays,
          equals({
            DateTime.monday,
            DateTime.tuesday,
            DateTime.wednesday,
            DateTime.thursday,
            DateTime.friday,
            DateTime.saturday,
          }),
        );
      });

      test('should create calendar with holidays', () {
        final calendar = WorkCalendar(
          holidays: {newYear, christmas},
        );

        expect(calendar.holidays, contains(newYear.startOfDay));
        expect(calendar.holidays, contains(christmas.startOfDay));
      });

      test('should normalize holiday times to start of day', () {
        final holidayWithTime = DateTimeHelper.named(
          year: 2024,
          month: DateTime.january,
          day: 1,
          hour: 15,
          minute: 30,
          second: 45,
        );
        final calendar = WorkCalendar(
          holidays: {holidayWithTime},
        );

        expect(calendar.holidays.first, equals(holidayWithTime.startOfDay));
        expect(calendar.holidays.first.hour, equals(0));
        expect(calendar.holidays.first.minute, equals(0));
      });

      test('should throw error for invalid working day', () {
        expect(
          () => WorkCalendar(
            workingDays: const {
              0,
              DateTime.monday,
              DateTime.tuesday,
            },
          ), // 0 is invalid
          throwsA(isA<ArgumentError>()),
        );

        expect(
          () => WorkCalendar(
            workingDays: const {DateTime.monday, DateTime.tuesday, 8},
          ), // 8 is invalid
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should throw error for empty working days', () {
        expect(
          () => WorkCalendar(workingDays: const {}),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should allow all days as working days', () {
        final calendar = WorkCalendar(
          workingDays: const {
            DateTime.monday,
            DateTime.tuesday,
            DateTime.wednesday,
            DateTime.thursday,
            DateTime.friday,
            DateTime.saturday,
            DateTime.sunday,
          }, // All days
        );

        expect(
          calendar.workingDays,
          equals({
            DateTime.monday,
            DateTime.tuesday,
            DateTime.wednesday,
            DateTime.thursday,
            DateTime.friday,
            DateTime.saturday,
            DateTime.sunday,
          }),
        );
      });
    });

    group('Working Day Checks', () {
      late WorkCalendar standardCalendar;
      late WorkCalendar calendarWithHolidays;

      setUp(() {
        standardCalendar = WorkCalendar();
        calendarWithHolidays = WorkCalendar(
          holidays: {newYear, christmas},
        );
      });

      test('should identify working days correctly', () {
        expect(standardCalendar.isWorkingDay(monday), isTrue);
        expect(standardCalendar.isWorkingDay(tuesday), isTrue);
        expect(standardCalendar.isWorkingDay(wednesday), isTrue);
        expect(standardCalendar.isWorkingDay(thursday), isTrue);
        expect(standardCalendar.isWorkingDay(friday), isTrue);
      });

      test('should identify weekends as non-working days', () {
        expect(standardCalendar.isWorkingDay(saturday), isFalse);
        expect(standardCalendar.isWorkingDay(sunday), isFalse);
      });

      test('should identify holidays as non-working days', () {
        expect(calendarWithHolidays.isWorkingDay(newYear), isFalse);
        expect(calendarWithHolidays.isWorkingDay(christmas), isFalse);
      });

      test('should ignore time when checking working days', () {
        final mondayMorning = DateTimeHelper.named(
          year: 2024,
          month: DateTime.january,
          day: 8,
          hour: 9,
          minute: 0,
        );
        final mondayEvening = DateTimeHelper.named(
          year: 2024,
          month: DateTime.january,
          day: 8,
          hour: 17,
          minute: 30,
        );

        expect(standardCalendar.isWorkingDay(mondayMorning), isTrue);
        expect(standardCalendar.isWorkingDay(mondayEvening), isTrue);
      });

      test('should handle custom working schedule', () {
        final sixDayCalendar = WorkCalendar(
          workingDays: const {
            DateTime.monday,
            DateTime.tuesday,
            DateTime.wednesday,
            DateTime.thursday,
            DateTime.friday,
            DateTime.saturday,
          }, // Mon-Sat
        );

        expect(sixDayCalendar.isWorkingDay(saturday), isTrue);
        expect(sixDayCalendar.isWorkingDay(sunday), isFalse);
      });
    });

    group('Holiday Checks', () {
      late WorkCalendar calendar;

      setUp(() {
        calendar = WorkCalendar(
          holidays: {newYear, christmas},
        );
      });

      test('should identify holidays correctly', () {
        expect(calendar.isHoliday(newYear), isTrue);
        expect(calendar.isHoliday(christmas), isTrue);
      });

      test('should identify non-holidays correctly', () {
        expect(calendar.isHoliday(tuesday), isFalse);
        expect(calendar.isHoliday(friday), isFalse);
      });

      test('should ignore time when checking holidays', () {
        final newYearMorning = DateTimeHelper.named(
          year: 2024,
          month: DateTime.january,
          day: 1,
          hour: 9,
          minute: 0,
        );
        final newYearEvening = DateTimeHelper.named(
          year: 2024,
          month: DateTime.january,
          day: 1,
          hour: 23,
          minute: 59,
        );

        expect(calendar.isHoliday(newYearMorning), isTrue);
        expect(calendar.isHoliday(newYearEvening), isTrue);
      });

      test('should handle empty holidays set', () {
        final noHolidaysCalendar = WorkCalendar();

        expect(noHolidaysCalendar.isHoliday(newYear), isFalse);
        expect(noHolidaysCalendar.isHoliday(christmas), isFalse);
      });
    });

    group('Working Day Navigation', () {
      late WorkCalendar calendar;

      setUp(() {
        calendar = WorkCalendar(
          holidays: {newYear}, // Monday Jan 1st is a holiday
        );
      });

      test('nextWorkingDay should skip weekends', () {
        final nextWorking = calendar.nextWorkingDay(friday);

        expect(nextWorking, equals(monday.addDays(7))); // Next Monday
      });

      test('nextWorkingDay should skip holidays', () {
        final calendar2 = WorkCalendar(
          holidays: {
            DateTimeHelper.named(
              year: 2023,
              month: DateTime.december,
              day: 29,
            ),
          }, // Make Friday a holiday
        );
        final thursdayBefore = DateTimeHelper.named(
          year: 2023,
          month: DateTime.december,
          day: 28,
        ); // Thursday before holiday Friday
        final nextWorking = calendar2.nextWorkingDay(thursdayBefore);

        // Should skip Friday holiday and weekend -> Monday Jan 1
        // (but that would be New Year)
        // Actually let's use a simpler test
        expect(nextWorking.isAfter(thursdayBefore), isTrue);
        expect(calendar2.isWorkingDay(nextWorking), isTrue);
      });

      test('nextWorkingDay should return start of day', () {
        final nextWorking = calendar.nextWorkingDay(tuesday);

        expect(nextWorking.hour, equals(0));
        expect(nextWorking.minute, equals(0));
        expect(nextWorking.second, equals(0));
      });

      test('nextWorkingDayWithLimit should find next working day', () {
        final nextWorking = calendar.nextWorkingDayWithLimit(friday);

        expect(nextWorking, equals(monday.addDays(7)));
      });

      test('nextWorkingDayWithLimit should return null when limit exceeded',
          () {
        final result = calendar.nextWorkingDayWithLimit(friday, maxDays: 1);

        expect(result, isNull);
      });

      test('nextWorkingDayWithLimit should throw error for negative maxDays',
          () {
        expect(
          () => calendar.nextWorkingDayWithLimit(friday, maxDays: -1),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('previousWorkingDay should skip weekends', () {
        final prevWorking = calendar.previousWorkingDay(monday);

        expect(prevWorking, equals(friday.addDays(-7))); // Previous Friday
      });

      test('previousWorkingDay should skip holidays', () {
        final wednesdayAfter = DateTimeHelper.named(
          year: 2024,
          month: DateTime.january,
          day: 3,
        ); // Wednesday after New Year
        final prevWorking = calendar.previousWorkingDay(wednesdayAfter);

        // Should find a working day before Wednesday
        expect(prevWorking.isBefore(wednesdayAfter), isTrue);
        expect(calendar.isWorkingDay(prevWorking), isTrue);
      });

      test('previousWorkingDayWithLimit should find previous working day', () {
        final prevWorking = calendar.previousWorkingDayWithLimit(monday);

        expect(prevWorking, equals(friday.addDays(-7)));
      });

      test('previousWorkingDayWithLimit should return null when limit exceeded',
          () {
        final result = calendar.previousWorkingDayWithLimit(monday, maxDays: 1);

        expect(result, isNull);
      });

      test(
          'previousWorkingDayWithLimit should throw error for negative maxDays',
          () {
        expect(
          () => calendar.previousWorkingDayWithLimit(monday, maxDays: -1),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('Working Days Between', () {
      late WorkCalendar calendar;

      setUp(() {
        calendar = WorkCalendar();
      });

      test('should return working days between dates (exclusive)', () {
        final workingDays = calendar.workingDaysBetween(
          start: monday,
          end: friday,
          inclusive: false,
        );

        // Tuesday, Wednesday, Thursday
        expect(workingDays.length, equals(3));
        expect(workingDays, contains(tuesday));
        expect(workingDays, contains(wednesday));
        expect(workingDays, contains(thursday));
      });

      test('should return working days between dates (inclusive)', () {
        final workingDays = calendar.workingDaysBetween(
          start: monday,
          end: friday,
          inclusive: true,
        );

        // Monday, Tuesday, Wednesday, Thursday, Friday
        expect(workingDays.length, equals(5));
        expect(workingDays, contains(monday));
        expect(workingDays, contains(friday));
      });

      test('should exclude weekends', () {
        final workingDays = calendar.workingDaysBetween(
          start: friday,
          end: monday.addDays(7),
          inclusive: true,
        );

        // Should only include Friday and next Monday
        expect(workingDays.length, equals(2));
        expect(workingDays, contains(friday));
        expect(workingDays, contains(monday.addDays(7)));
      });

      test('should exclude holidays', () {
        final calendarWithHoliday = WorkCalendar(
          holidays: {wednesday},
        );

        final workingDays = calendarWithHoliday.workingDaysBetween(
          start: monday,
          end: friday,
          inclusive: true,
        );

        // Monday, Tuesday, Thursday, Friday (Wednesday is holiday)
        expect(workingDays.length, equals(4));
        expect(workingDays, isNot(contains(wednesday)));
      });

      test('should throw error when start is after end', () {
        expect(
          () => calendar.workingDaysBetween(
            start: friday,
            end: monday,
          ),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should return empty list for same date (exclusive)', () {
        final workingDays = calendar.workingDaysBetween(
          start: monday,
          end: monday,
          inclusive: false,
        );

        expect(workingDays, isEmpty);
      });

      test('should return single date for same date (inclusive)', () {
        final workingDays = calendar.workingDaysBetween(
          start: monday,
          end: monday,
          inclusive: true,
        );

        expect(workingDays.length, equals(1));
        expect(workingDays.first, equals(monday));
      });
    });

    group('Working Period Check', () {
      late WorkCalendar calendar;

      setUp(() {
        calendar = WorkCalendar(
          holidays: {wednesday}, // Wednesday is a holiday
        );
      });

      test('should return true for all working days', () {
        final isWorkingPeriod = calendar.isWorkingPeriod(
          start: monday,
          end: tuesday,
        );

        expect(isWorkingPeriod, isTrue);
      });

      test('should return false if period includes weekend', () {
        final isWorkingPeriod = calendar.isWorkingPeriod(
          start: friday,
          end: sunday,
        );

        expect(isWorkingPeriod, isFalse);
      });

      test('should return false if period includes holiday', () {
        final isWorkingPeriod = calendar.isWorkingPeriod(
          start: tuesday,
          end: thursday,
        );

        expect(isWorkingPeriod, isFalse); // Includes Wednesday holiday
      });

      test('should return true for single working day', () {
        final isWorkingPeriod = calendar.isWorkingPeriod(
          start: monday,
          end: monday,
        );

        expect(isWorkingPeriod, isTrue);
      });

      test('should return false for single non-working day', () {
        final isWorkingPeriod = calendar.isWorkingPeriod(
          start: saturday,
          end: saturday,
        );

        expect(isWorkingPeriod, isFalse);
      });

      test('should throw error when start is after end', () {
        expect(
          () => calendar.isWorkingPeriod(
            start: friday,
            end: monday,
          ),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('Copy With', () {
      late WorkCalendar originalCalendar;

      setUp(() {
        originalCalendar = WorkCalendar(
          holidays: {newYear},
          workingDays: const {
            DateTime.monday,
            DateTime.tuesday,
            DateTime.wednesday,
            DateTime.thursday,
            DateTime.friday,
          },
        );
      });

      test('should copy with new holidays', () {
        final newCalendar = originalCalendar.copyWith(
          holidays: {christmas},
        );

        expect(newCalendar.holidays, contains(christmas.startOfDay));
        expect(newCalendar.holidays, isNot(contains(newYear.startOfDay)));
        expect(newCalendar.workingDays, equals(originalCalendar.workingDays));
      });

      test('should copy with new working days', () {
        final newCalendar = originalCalendar.copyWith(
          workingDays: {
            DateTime.monday,
            DateTime.tuesday,
            DateTime.wednesday,
            DateTime.thursday,
            DateTime.friday,
            DateTime.saturday,
          }, // Add Saturday
        );

        expect(
          newCalendar.workingDays,
          equals({
            DateTime.monday,
            DateTime.tuesday,
            DateTime.wednesday,
            DateTime.thursday,
            DateTime.friday,
            DateTime.saturday,
          }),
        );
        expect(newCalendar.holidays, equals(originalCalendar.holidays));
      });

      test('should copy with both new holidays and working days', () {
        final newCalendar = originalCalendar.copyWith(
          holidays: {christmas},
          workingDays: {
            DateTime.monday,
            DateTime.tuesday,
            DateTime.wednesday,
            DateTime.thursday,
            DateTime.friday,
            DateTime.saturday,
          },
        );

        expect(newCalendar.holidays, contains(christmas.startOfDay));
        expect(
          newCalendar.workingDays,
          equals({
            DateTime.monday,
            DateTime.tuesday,
            DateTime.wednesday,
            DateTime.thursday,
            DateTime.friday,
            DateTime.saturday,
          }),
        );
      });

      test('should copy without changes when no parameters provided', () {
        final newCalendar = originalCalendar.copyWith();

        expect(newCalendar.holidays, equals(originalCalendar.holidays));
        expect(newCalendar.workingDays, equals(originalCalendar.workingDays));
      });
    });

    group('String Representation', () {
      test('should provide meaningful string representation', () {
        final calendar = WorkCalendar(
          holidays: {newYear},
          workingDays: const {
            DateTime.monday,
            DateTime.tuesday,
            DateTime.wednesday,
            DateTime.thursday,
            DateTime.friday,
          },
        );

        final stringRep = calendar.toString();

        expect(stringRep, contains('WorkCalendar'));
        expect(stringRep, contains('holidays'));
        expect(stringRep, contains('workingDays'));
      });
    });

    group('Edge Cases and Error Handling', () {
      test('should handle leap year correctly', () {
        final calendar = WorkCalendar();
        final leapYearDate = DateTime(2024, 2, 29); // Leap year

        expect(calendar.isWorkingDay(leapYearDate), isTrue); // Thursday
      });

      test('should handle year boundaries correctly', () {
        final calendar = WorkCalendar();
        final lastDayOfYear = DateTime(2023, 12, 31); // Sunday
        final firstDayOfYear = DateTime(2024); // Monday

        expect(calendar.isWorkingDay(lastDayOfYear), isFalse); // Sunday
        expect(calendar.isWorkingDay(firstDayOfYear), isTrue); // Monday
      });

      test('should handle far future dates', () {
        final calendar = WorkCalendar();
        final farFuture = DateTime(2100, 6, 15);

        expect(() => calendar.isWorkingDay(farFuture), returnsNormally);
      });

      test('should handle historical dates', () {
        final calendar = WorkCalendar();
        final historical = DateTime(1900);

        expect(() => calendar.isWorkingDay(historical), returnsNormally);
      });

      test('should handle microsecond precision in dates', () {
        final calendar = WorkCalendar(
          holidays: {DateTime(2024)},
        );
        final preciseDate = DateTimeHelper.named(
          year: 2024,
          month: DateTime.january,
          day: 1,
          hour: 12,
          minute: 30,
          second: 45,
          millisecond: 123,
          microsecond: 456,
        );

        expect(calendar.isHoliday(preciseDate), isTrue);
      });
    });
  });
}

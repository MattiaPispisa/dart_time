import 'package:dart_time/dart_time.dart';
import 'package:test/test.dart';

void main() {
  group('DateTimeHelper', () {
    final testDate = DateTimeHelper.named(
      year: 2023,
      month: 6,
      day: 15,
      hour: 14,
      minute: 30,
      second: 45,
      millisecond: 123,
      microsecond: 456,
    );

    group('named constructor', () {
      test('should create DateTime with all parameters', () {
        final date = DateTimeHelper.named(
          year: 2023,
          month: 6,
          day: 15,
          hour: 14,
          minute: 30,
          second: 45,
          millisecond: 123,
          microsecond: 456,
        );

        expect(date.year, equals(2023));
        expect(date.month, equals(6));
        expect(date.day, equals(15));
        expect(date.hour, equals(14));
        expect(date.minute, equals(30));
        expect(date.second, equals(45));
        expect(date.millisecond, equals(123));
        expect(date.microsecond, equals(456));
      });

      test('should create DateTime with only year', () {
        final date = DateTimeHelper.named(year: 2023);

        expect(date.year, equals(2023));
        expect(date.month, equals(1));
        expect(date.day, equals(1));
        expect(date.hour, equals(0));
        expect(date.minute, equals(0));
        expect(date.second, equals(0));
        expect(date.millisecond, equals(0));
        expect(date.microsecond, equals(0));
      });
    });

    group('copyWith', () {
      test('should copy with new values', () {
        final copied = testDate.copyWith(year: 2024, month: 7);

        expect(copied.year, equals(2024));
        expect(copied.month, equals(7));
        expect(copied.day, equals(15));
        expect(copied.hour, equals(14));
        expect(copied.minute, equals(30));
        expect(copied.second, equals(45));
        expect(copied.millisecond, equals(123));
        expect(copied.microsecond, equals(456));
      });

      test('should copy with no changes', () {
        final copied = testDate.copyWith();

        expect(copied, equals(testDate));
      });
    });

    group('copyTime', () {
      test('should copy ClockTime to DateTime', () {
        final time = ClockTime(
          10,
          minute: 20,
          second: 30,
          millisecond: 100,
          microsecond: 200,
        );
        final copied = testDate.copyTime(time);

        expect(copied.year, equals(2023));
        expect(copied.month, equals(6));
        expect(copied.day, equals(15));
        expect(copied.hour, equals(10));
        expect(copied.minute, equals(20));
        expect(copied.second, equals(30));
        expect(copied.millisecond, equals(100));
        expect(copied.microsecond, equals(200));
      });
    });

    group('start of period methods', () {
      test('startOfYear should work correctly', () {
        final result = testDate.startOfYear;

        expect(result.year, equals(2023));
        expect(result.month, equals(1));
        expect(result.day, equals(1));
        expect(result.hour, equals(0));
        expect(result.minute, equals(0));
        expect(result.second, equals(0));
        expect(result.millisecond, equals(0));
        expect(result.microsecond, equals(0));
      });

      test('startOfMonth should work correctly', () {
        final result = testDate.startOfMonth;

        expect(result.year, equals(2023));
        expect(result.month, equals(6));
        expect(result.day, equals(1));
        expect(result.hour, equals(0));
        expect(result.minute, equals(0));
        expect(result.second, equals(0));
        expect(result.millisecond, equals(0));
        expect(result.microsecond, equals(0));
      });

      test('startOfDay should work correctly', () {
        final result = testDate.startOfDay;

        expect(result.year, equals(2023));
        expect(result.month, equals(6));
        expect(result.day, equals(15));
        expect(result.hour, equals(0));
        expect(result.minute, equals(0));
        expect(result.second, equals(0));
        expect(result.millisecond, equals(0));
        expect(result.microsecond, equals(0));
      });

      test('startOfHour should work correctly', () {
        final result = testDate.startOfHour;

        expect(result.year, equals(2023));
        expect(result.month, equals(6));
        expect(result.day, equals(15));
        expect(result.hour, equals(14));
        expect(result.minute, equals(0));
        expect(result.second, equals(0));
        expect(result.millisecond, equals(0));
        expect(result.microsecond, equals(0));
      });

      test('startOfMinute should work correctly', () {
        final result = testDate.startOfMinute;

        expect(result.year, equals(2023));
        expect(result.month, equals(6));
        expect(result.day, equals(15));
        expect(result.hour, equals(14));
        expect(result.minute, equals(30));
        expect(result.second, equals(0));
        expect(result.millisecond, equals(0));
        expect(result.microsecond, equals(0));
      });

      test('startOfSecond should work correctly', () {
        final result = testDate.startOfSecond;

        expect(result.year, equals(2023));
        expect(result.month, equals(6));
        expect(result.day, equals(15));
        expect(result.hour, equals(14));
        expect(result.minute, equals(30));
        expect(result.second, equals(45));
        expect(result.millisecond, equals(0));
        expect(result.microsecond, equals(0));
      });
    });

    group('end of period methods', () {
      test('endOfYear should work correctly', () {
        final result = testDate.endOfYear;

        expect(result.year, equals(2023));
        expect(result.month, equals(12));
        expect(result.day, equals(31));
        expect(result.hour, equals(23));
        expect(result.minute, equals(59));
        expect(result.second, equals(59));
        expect(result.millisecond, equals(999));
        expect(result.microsecond, equals(999));
      });

      test('endOfMonth should work correctly', () {
        final result = testDate.endOfMonth;

        expect(result.year, equals(2023));
        expect(result.month, equals(6));
        expect(result.day, equals(30)); // June has 30 days, not 31
        expect(result.hour, equals(23));
        expect(result.minute, equals(59));
        expect(result.second, equals(59));
        expect(result.millisecond, equals(999));
        expect(result.microsecond, equals(999));
      });

      test('endOfMonth should handle different months correctly', () {
        // January - 31 days
        expect(DateTime(2023, 1, 15).endOfMonth.day, equals(31));

        // February non-leap year - 28 days
        expect(DateTime(2023, 2, 15).endOfMonth.day, equals(28));
        expect(DateTime(2023, 2, 15).endOfMonth.millisecond, equals(999));
        expect(DateTime(2023, 2, 15).endOfMonth.microsecond, equals(999));

        // February leap year - 29 days
        expect(DateTime(2020, 2, 15).endOfMonth.day, equals(29));

        // April - 30 days
        expect(DateTime(2023, 4, 15).endOfMonth.day, equals(30));

        // December - 31 days
        expect(DateTime(2023, 12, 15).endOfMonth.day, equals(31));
      });

      test('endOfDay should work correctly', () {
        final result = testDate.endOfDay;

        expect(result.year, equals(2023));
        expect(result.month, equals(6));
        expect(result.day, equals(15));
        expect(result.hour, equals(23));
        expect(result.minute, equals(59));
        expect(result.second, equals(59));
        expect(result.millisecond, equals(999));
        expect(result.microsecond, equals(999));
      });

      test('endOfHour should work correctly', () {
        final result = testDate.endOfHour;

        expect(result.year, equals(2023));
        expect(result.month, equals(6));
        expect(result.day, equals(15));
        expect(result.hour, equals(14));
        expect(result.minute, equals(59));
        expect(result.second, equals(59));
        expect(result.millisecond, equals(999));
        expect(result.microsecond, equals(999));
      });

      test('endOfMinute should work correctly', () {
        final result = testDate.endOfMinute;

        expect(result.year, equals(2023));
        expect(result.month, equals(6));
        expect(result.day, equals(15));
        expect(result.hour, equals(14));
        expect(result.minute, equals(30));
        expect(result.second, equals(59));
        expect(result.millisecond, equals(999));
        expect(result.microsecond, equals(999));
      });

      test('endOfSecond should work correctly', () {
        final result = testDate.endOfSecond;

        expect(result.year, equals(2023));
        expect(result.month, equals(6));
        expect(result.day, equals(15));
        expect(result.hour, equals(14));
        expect(result.minute, equals(30));
        expect(result.second, equals(45));
        expect(result.millisecond, equals(999));
        expect(result.microsecond, equals(999));
      });
    });

    group('navigation methods', () {
      test('nextDay should work correctly', () {
        final result = testDate.nextDay;

        expect(result.day, equals(16));
        expect(result.hour, equals(14));
        expect(result.minute, equals(30));
        expect(result.second, equals(45));
        expect(result.millisecond, equals(123));
        expect(result.microsecond, equals(456));
      });

      test('previousDay should work correctly', () {
        final result = testDate.previousDay;

        expect(result.day, equals(14));
        expect(result.hour, equals(14));
        expect(result.minute, equals(30));
        expect(result.second, equals(45));
        expect(result.millisecond, equals(123));
        expect(result.microsecond, equals(456));
      });
    });

    group('granular comparison methods', () {
      test('isGranularSame should work correctly', () {
        final other = DateTimeHelper.named(
          year: 2023,
          month: 6,
          day: 15,
          hour: 10,
          minute: 20,
          second: 30,
        );

        expect(testDate.isGranularSame(other, TimeGranularity.day), isTrue);
        expect(testDate.isGranularSame(other, TimeGranularity.hour), isFalse);
        expect(testDate.isGranularSame(testDate), isTrue);
      });

      test('isGranularSame should work correctly with second granularity', () {
        // testDate: 2023-06-15 14:30:45.123456
        final sameSecond = DateTimeHelper.named(
          year: 2023,
          month: 6,
          day: 15,
          hour: 14,
          minute: 30,
          second: 45,
          millisecond: 999, // Different milliseconds
          microsecond: 999, // Different microseconds
        );

        final differentSecond = DateTimeHelper.named(
          year: 2023,
          month: 6,
          day: 15,
          hour: 14,
          minute: 30,
          second: 44, // Different second
        );

        expect(
          testDate.isGranularSame(sameSecond, TimeGranularity.second),
          isTrue,
        );
        expect(
          testDate.isGranularSame(differentSecond, TimeGranularity.second),
          isFalse,
        );
      });

      test('isGranularSame should work correctly with milliseconds granularity',
          () {
        // testDate: 2023-06-15 14:30:45.123456
        final sameMillisecond = DateTimeHelper.named(
          year: 2023,
          month: 6,
          day: 15,
          hour: 14,
          minute: 30,
          second: 45,
          millisecond: 123,
          microsecond: 999, // Different microseconds
        );

        final differentMillisecond = DateTimeHelper.named(
          year: 2023,
          month: 6,
          day: 15,
          hour: 14,
          minute: 30,
          second: 45,
          millisecond: 124, // Different millisecond
          microsecond: 456,
        );

        expect(
          testDate.isGranularSame(
            sameMillisecond,
            TimeGranularity.milliseconds,
          ),
          isTrue,
        );
        expect(
          testDate.isGranularSame(
            differentMillisecond,
            TimeGranularity.milliseconds,
          ),
          isFalse,
        );
      });

      test('isGranularSame should work correctly with microseconds granularity',
          () {
        // testDate: 2023-06-15 14:30:45.123456
        final exactSame = DateTimeHelper.named(
          year: 2023,
          month: 6,
          day: 15,
          hour: 14,
          minute: 30,
          second: 45,
          millisecond: 123,
          microsecond: 456,
        );

        final differentMicrosecond = DateTimeHelper.named(
          year: 2023,
          month: 6,
          day: 15,
          hour: 14,
          minute: 30,
          second: 45,
          millisecond: 123,
          microsecond: 457, // Different microsecond
        );

        expect(testDate.isGranularSame(exactSame), isTrue);
        expect(testDate.isGranularSame(differentMicrosecond), isFalse);
      });

      test('isSameYear should work correctly', () {
        final sameYear = DateTime(2023, 12);
        final differentYear = DateTime(2024, 6, 15);

        expect(testDate.isSameYear(sameYear), isTrue);
        expect(testDate.isSameYear(differentYear), isFalse);
      });

      test('isSameMonth should work correctly', () {
        final sameMonth = DateTime(2023, 6);
        final differentMonth = DateTime(2023, 7, 15);

        expect(testDate.isSameMonth(sameMonth), isTrue);
        expect(testDate.isSameMonth(differentMonth), isFalse);
      });

      test('isSameDay should work correctly', () {
        final sameDay = DateTime(2023, 6, 15, 10);
        final differentDay = DateTime(2023, 6, 16);

        expect(testDate.isSameDay(sameDay), isTrue);
        expect(testDate.isSameDay(differentDay), isFalse);
      });

      test('isSameHour should work correctly', () {
        final sameHour = DateTime(2023, 6, 15, 14, 10);
        final differentHour = DateTime(2023, 6, 15, 15);

        expect(testDate.isSameHour(sameHour), isTrue);
        expect(testDate.isSameHour(differentHour), isFalse);
      });

      test('isSameMinute should work correctly', () {
        final sameMinute = DateTime(2023, 6, 15, 14, 30, 10);
        final differentMinute = DateTime(2023, 6, 15, 14, 31);

        expect(testDate.isSameMinute(sameMinute), isTrue);
        expect(testDate.isSameMinute(differentMinute), isFalse);
      });
    });

    group('week methods', () {
      test('isSameWeek should work correctly with default first day (Monday)',
          () {
        final monday = DateTime(2023, 6, 12); // Monday
        final friday = DateTime(2023, 6, 16); // Friday same week
        final nextMonday = DateTime(2023, 6, 19); // Monday next week

        expect(monday.isSameWeek(friday), isTrue);
        expect(monday.isSameWeek(nextMonday), isFalse);
      });

      test('isSameWeek should work correctly with custom first day', () {
        final sunday = DateTime(2023, 6, 11); // Sunday
        final monday = DateTime(2023, 6, 12); // Monday

        // With Sunday as first day of week
        expect(sunday.isSameWeek(monday, DateTime.sunday), isTrue);
        // With Monday as first day of week (default)
        expect(sunday.isSameWeek(monday), isFalse);
      });

      test('weekOfYear should return correct week number', () {
        // Test specific ISO 8601 week numbers for 2023

        // Sunday, should be week 52 of 2022
        final jan1_2023 = DateTimeHelper.named(year: 2023, month: 1, day: 1);

        // Monday, should be week 1 of 2023
        final jan2_2023 = DateTime(2023, 1, 2);

        // Sunday, should be week 2 of 2023
        final jan15_2023 = DateTime(2023, 1, 15);

        // Thursday, should be around week 24
        final jun15_2023 = DateTime(2023, 6, 15);

        // Sunday, should be week 52 of 2023
        final dec31_2023 = DateTime(2023, 12, 31);

        // Jan 1, 2023 is a Sunday and belongs to the previous year's last week
        expect(jan1_2023.isoWeekOfYear, equals(52));

        // Jan 2, 2023 is a Monday and starts week 1 of 2023
        expect(jan2_2023.isoWeekOfYear, equals(1));

        // Jan 15, 2023 should be week 2
        expect(jan15_2023.isoWeekOfYear, equals(2));

        // June 15, 2023 should be around week 24
        expect(jun15_2023.isoWeekOfYear, equals(24));

        // Dec 31, 2023 should be week 52
        expect(dec31_2023.isoWeekOfYear, equals(52));

        // Test with leap year boundary

        // Wednesday, should be week 1
        final jan1_2020 = DateTimeHelper.named(year: 2020, month: 1, day: 1);
        expect(jan1_2020.isoWeekOfYear, equals(1));
      });
    });

    group('leap year methods', () {
      test('isLeapYear should work correctly', () {
        expect(DateTime(2020).isLeapYear, isTrue); // Divisible by 4
        expect(DateTime(2021).isLeapYear, isFalse); // Not divisible by 4
        expect(DateTime(1900).isLeapYear, isFalse); // Divisible by 100, not 400
        expect(DateTime(2000).isLeapYear, isTrue); // Divisible by 400
        expect(DateTime(2004).isLeapYear, isTrue); // Divisible by 4
      });
    });

    group('quarter methods', () {
      test('quarter should return correct quarter', () {
        expect(DateTime(2023, 1, 15).quarter, equals(1));
        expect(DateTime(2023, 3, 31).quarter, equals(1));
        expect(DateTime(2023, 4).quarter, equals(2));
        expect(DateTime(2023, 6, 30).quarter, equals(2));
        expect(DateTime(2023, 7).quarter, equals(3));
        expect(DateTime(2023, 9, 30).quarter, equals(3));
        expect(DateTime(2023, 10).quarter, equals(4));
        expect(DateTime(2023, 12, 31).quarter, equals(4));
      });

      test('startOfQuarter should work correctly', () {
        final q1Date = DateTime(2023, 2, 15);
        final q2Date = DateTime(2023, 5, 15);
        final q3Date = DateTime(2023, 8, 15);
        final q4Date = DateTime(2023, 11, 15);

        expect(q1Date.startOfQuarter, equals(DateTime(2023)));
        expect(q2Date.startOfQuarter, equals(DateTime(2023, 4)));
        expect(q3Date.startOfQuarter, equals(DateTime(2023, 7)));
        expect(q4Date.startOfQuarter, equals(DateTime(2023, 10)));
      });

      test('endOfQuarter should work correctly', () {
        final q1Date = DateTime(2023, 2, 15);
        final q2Date = DateTime(2023, 5, 15);
        final q3Date = DateTime(2023, 8, 15);
        final q4Date = DateTime(2023, 11, 15);

        expect(q1Date.endOfQuarter.month, equals(3));
        expect(q1Date.endOfQuarter.day, equals(31));
        expect(q2Date.endOfQuarter.month, equals(6));
        expect(q2Date.endOfQuarter.day, equals(30));
        expect(q3Date.endOfQuarter.month, equals(9));
        expect(q3Date.endOfQuarter.day, equals(30));
        expect(q4Date.endOfQuarter.month, equals(12));
        expect(q4Date.endOfQuarter.day, equals(31));
      });

      test('isSameQuarter should work correctly', () {
        final jan = DateTime(2023, 1, 15);
        final mar = DateTime(2023, 3, 20);
        final jul = DateTime(2023, 7, 10);
        final janNextYear = DateTime(2024, 1, 15);

        expect(jan.isSameQuarter(mar), isTrue);
        expect(jan.isSameQuarter(jul), isFalse);
        expect(jan.isSameQuarter(janNextYear), isFalse);
      });
    });

    group('daysInYear', () {
      test('should return correct days in year', () {
        expect(DateTime(2020, 6, 15).daysInYear, equals(366)); // Leap year
        expect(DateTime(2021, 6, 15).daysInYear, equals(365)); // Regular year
        expect(DateTime(2000).daysInYear, equals(366)); // Leap year
        expect(DateTime(1900).daysInYear, equals(365)); // Not leap year
      });
    });

    group('daysInMonth', () {
      test('should return correct days in month', () {
        // Months with 31 days
        expect(DateTime(2023, 1, 15).daysInMonth, equals(31)); // January
        expect(DateTime(2023, 3, 15).daysInMonth, equals(31)); // March
        expect(DateTime(2023, 5, 15).daysInMonth, equals(31)); // May
        expect(DateTime(2023, 7, 15).daysInMonth, equals(31)); // July
        expect(DateTime(2023, 8, 15).daysInMonth, equals(31)); // August
        expect(DateTime(2023, 10, 15).daysInMonth, equals(31)); // October
        expect(DateTime(2023, 12, 15).daysInMonth, equals(31)); // December

        // Months with 30 days
        expect(DateTime(2023, 4, 15).daysInMonth, equals(30)); // April
        expect(DateTime(2023, 6, 15).daysInMonth, equals(30)); // June
        expect(DateTime(2023, 9, 15).daysInMonth, equals(30)); // September
        expect(DateTime(2023, 11, 15).daysInMonth, equals(30)); // November

        // February in non-leap year
        expect(DateTime(2023, 2, 15).daysInMonth, equals(28));

        // February in leap year
        expect(DateTime(2020, 2, 15).daysInMonth, equals(29));
        expect(DateTime(2000, 2, 15).daysInMonth, equals(29));

        // February in non-leap year (divisible by 100 but not 400)
        expect(DateTime(1900, 2, 15).daysInMonth, equals(28));
      });
    });

    group('comparison operators', () {
      test('isFuture should work correctly', () {
        final future = DateTime.now().addDays(1);
        final past = DateTime.now().subDays(2);

        expect(future.isFuture, isTrue);
        expect(past.isFuture, isFalse);
      });

      test('isPast should work correctly', () {
        final future = DateTime.now().addDays(1);
        final past = DateTime.now().subDays(2);

        expect(future.isPast, isFalse);
        expect(past.isPast, isTrue);
      });

      test('isSameOrAfter should work correctly', () {
        final earlier = DateTime(2023, 6, 14);
        final same = DateTime(2023, 6, 15, 14, 30, 45, 123, 456);
        final later = DateTime(2023, 6, 16);

        expect(testDate.isSameOrAfter(earlier), isTrue);
        expect(testDate.isSameOrAfter(same), isTrue);
        expect(testDate.isSameOrAfter(later), isFalse);

        // Test with second granularity
        final sameSecond =
            DateTime(2023, 6, 15, 14, 30, 45, 999); // Same second, different ms
        final earlierSecond =
            DateTime(2023, 6, 15, 14, 30, 44); // 1 second earlier
        expect(
          testDate.isSameOrAfter(sameSecond, TimeGranularity.second),
          isTrue,
        );
        expect(
          testDate.isSameOrAfter(earlierSecond, TimeGranularity.second),
          isTrue,
        );

        // Test with milliseconds granularity
        final sameMs = DateTime(
          2023,
          6,
          15,
          14,
          30,
          45,
          123,
          999,
        ); // Same ms, different μs
        final earlierMs = DateTime(2023, 6, 15, 14, 30, 45, 122); // 1ms earlier
        expect(
          testDate.isSameOrAfter(sameMs, TimeGranularity.milliseconds),
          isTrue,
        );
        expect(
          testDate.isSameOrAfter(earlierMs, TimeGranularity.milliseconds),
          isTrue,
        );
      });

      test('isSameOrBefore should work correctly', () {
        final earlier = DateTime(2023, 6, 14);
        final same = DateTime(2023, 6, 15, 14, 30, 45, 123, 456);
        final later = DateTime(2023, 6, 16);

        expect(testDate.isSameOrBefore(earlier), isFalse);
        expect(testDate.isSameOrBefore(same), isTrue);
        expect(testDate.isSameOrBefore(later), isTrue);

        // Test with second granularity
        final sameSecond =
            DateTime(2023, 6, 15, 14, 30, 45, 999); // Same second, different ms
        final laterSecond = DateTime(2023, 6, 15, 14, 30, 46); // 1 second later
        expect(
          testDate.isSameOrBefore(sameSecond, TimeGranularity.second),
          isTrue,
        );
        expect(
          testDate.isSameOrBefore(laterSecond, TimeGranularity.second),
          isTrue,
        );

        // Test with milliseconds granularity
        final sameMs = DateTime(
          2023,
          6,
          15,
          14,
          30,
          45,
          123,
          999,
        ); // Same ms, different μs
        final laterMs = DateTime(2023, 6, 15, 14, 30, 45, 124); // 1ms later
        expect(
          testDate.isSameOrBefore(sameMs, TimeGranularity.milliseconds),
          isTrue,
        );
        expect(
          testDate.isSameOrBefore(laterMs, TimeGranularity.milliseconds),
          isTrue,
        );
      });

      test('isGranularAfter should work correctly', () {
        final earlier = DateTime(2023, 6, 14);
        final later = DateTime(2023, 6, 16);
        final sameDay = DateTime(2023, 6, 15, 10, 20, 30);

        // Default granularity (microseconds)
        expect(testDate.isGranularAfter(earlier), isTrue);
        expect(testDate.isGranularAfter(later), isFalse);
        expect(testDate.isGranularAfter(sameDay), isTrue);

        // Day granularity
        expect(testDate.isGranularAfter(earlier, TimeGranularity.day), isTrue);
        expect(testDate.isGranularAfter(later, TimeGranularity.day), isFalse);
        expect(testDate.isGranularAfter(sameDay, TimeGranularity.day), isFalse);

        // Hour granularity
        expect(testDate.isGranularAfter(sameDay, TimeGranularity.hour), isTrue);

        // Second granularity
        final earlierSecond =
            DateTime(2023, 6, 15, 14, 30, 44); // 1 second earlier
        final laterSecond = DateTime(2023, 6, 15, 14, 30, 46); // 1 second later
        expect(
          testDate.isGranularAfter(earlierSecond, TimeGranularity.second),
          isTrue,
        );
        expect(
          testDate.isGranularAfter(laterSecond, TimeGranularity.second),
          isFalse,
        );

        // Milliseconds granularity
        final earlierMs = DateTime(2023, 6, 15, 14, 30, 45, 122); // 1ms earlier
        final laterMs = DateTime(2023, 6, 15, 14, 30, 45, 124); // 1ms later
        expect(
          testDate.isGranularAfter(earlierMs, TimeGranularity.milliseconds),
          isTrue,
        );
        expect(
          testDate.isGranularAfter(laterMs, TimeGranularity.milliseconds),
          isFalse,
        );
      });

      test('isGranularBefore should work correctly', () {
        final earlier = DateTime(2023, 6, 14);
        final later = DateTime(2023, 6, 16);
        final sameDay = DateTime(2023, 6, 15, 16, 40, 50);

        // Default granularity (microseconds)
        expect(testDate.isGranularBefore(earlier), isFalse);
        expect(testDate.isGranularBefore(later), isTrue);
        expect(testDate.isGranularBefore(sameDay), isTrue);

        // Day granularity
        expect(
          testDate.isGranularBefore(earlier, TimeGranularity.day),
          isFalse,
        );
        expect(testDate.isGranularBefore(later, TimeGranularity.day), isTrue);
        expect(
          testDate.isGranularBefore(sameDay, TimeGranularity.day),
          isFalse,
        );

        // Hour granularity
        expect(
          testDate.isGranularBefore(sameDay, TimeGranularity.hour),
          isTrue,
        );

        // Second granularity
        final earlierSecond =
            DateTime(2023, 6, 15, 14, 30, 44); // 1 second earlier
        final laterSecond = DateTime(2023, 6, 15, 14, 30, 46); // 1 second later
        expect(
          testDate.isGranularBefore(earlierSecond, TimeGranularity.second),
          isFalse,
        );
        expect(
          testDate.isGranularBefore(laterSecond, TimeGranularity.second),
          isTrue,
        );

        // Milliseconds granularity
        final earlierMs = DateTime(2023, 6, 15, 14, 30, 45, 122); // 1ms earlier
        final laterMs = DateTime(2023, 6, 15, 14, 30, 45, 124); // 1ms later
        expect(
          testDate.isGranularBefore(earlierMs, TimeGranularity.milliseconds),
          isFalse,
        );
        expect(
          testDate.isGranularBefore(laterMs, TimeGranularity.milliseconds),
          isTrue,
        );
      });

      test('operators should work correctly', () {
        final earlier = DateTime(2023, 6, 14);
        final later = DateTime(2023, 6, 16);

        expect(testDate < later, isTrue);
        expect(testDate <= testDate, isTrue);
        expect(testDate > earlier, isTrue);
        expect(testDate >= testDate, isTrue);
      });

      test('arithmetic operators should work correctly', () {
        const duration = Duration(days: 1);
        final result1 = testDate + duration;
        final result2 = testDate - duration;

        expect(result1.day, equals(16));
        expect(result2.day, equals(14));
      });
    });

    group('add/subtract methods', () {
      test('addYears should work correctly', () {
        final result = testDate.addYears(2);

        expect(result.year, equals(2025));
        expect(result.month, equals(6));
        expect(result.day, equals(15));
      });

      test('addMonths should work correctly', () {
        final result = testDate.addMonths(3);

        expect(result.year, equals(2023));
        expect(result.month, equals(9));
        expect(result.day, equals(15));
      });

      test('addDays should work correctly without DST', () {
        final result = testDate.addDays(5);

        expect(result.day, equals(20));
      });

      test('addDays should work correctly with DST ignored', () {
        final result = testDate.addDays(5, ignoreDaylightSavings: true);

        expect(result.day, equals(20));
        expect(result.hour, equals(14));
        expect(result.minute, equals(30));
      });

      test('addHours should work correctly', () {
        final result = testDate.addHours(5);

        expect(result.hour, equals(19));
      });

      test('addHours should work correctly with ignoreDaylightSavings', () {
        final result = testDate.addHours(5, ignoreDaylightSavings: true);

        expect(result.hour, equals(19));
        expect(result.minute, equals(30));
        expect(result.second, equals(45));

        // Test hour overflow
        final overflowResult =
            testDate.addHours(10, ignoreDaylightSavings: true);
        expect(overflowResult.day, equals(16)); // Should wrap to next day
        expect(overflowResult.hour, equals(0)); // 14 + 10 = 24 -> 0
      });

      test('addMinutes should work correctly', () {
        final result = testDate.addMinutes(45);

        expect(result.minute, equals(15)); // This will overflow to next hour
      });

      test('addMinutes should work correctly with ignoreDaylightSavings', () {
        final result = testDate.addMinutes(45, ignoreDaylightSavings: true);

        expect(result.hour, equals(15)); // 30 + 45 = 75 -> 15 (next hour)
        expect(result.minute, equals(15)); // 75 % 60 = 15
        expect(result.second, equals(45));

        // Test minute overflow across day boundary
        final overflowResult =
            testDate.addMinutes(600, ignoreDaylightSavings: true); // 10 hours
        expect(overflowResult.day, equals(16)); // Should wrap to next day
        expect(overflowResult.hour, equals(0)); // 14 + 10 = 24 -> 0
        expect(overflowResult.minute, equals(30));
      });

      test('addSeconds should work correctly', () {
        final result = testDate.addSeconds(30);

        expect(result.second, equals(15)); // This will overflow to next minute
      });

      test('addSeconds should work correctly with ignoreDaylightSavings', () {
        final result = testDate.addSeconds(30, ignoreDaylightSavings: true);

        expect(result.minute, equals(31)); // 45 + 30 = 75 -> 31 (next minute)
        expect(result.second, equals(15)); // 75 % 60 = 15
        expect(result.hour, equals(14));

        // Test second overflow across hour boundary
        final overflowResult = testDate.addSeconds(
          1800,
          ignoreDaylightSavings: true,
        ); // 30 minutes
        expect(overflowResult.hour, equals(15)); // Should wrap to next hour
        expect(overflowResult.minute, equals(0)); // 30 + 30 = 60 -> 0
        expect(overflowResult.second, equals(45));
      });

      test('addMilliseconds should work correctly', () {
        final result = testDate.addMilliseconds(500);

        expect(result.millisecond, equals(623));
      });

      test('addMilliseconds should work correctly with ignoreDaylightSavings',
          () {
        final result =
            testDate.addMilliseconds(500, ignoreDaylightSavings: true);

        expect(result.millisecond, equals(623)); // 123 + 500 = 623
        expect(result.second, equals(45));

        // Test millisecond overflow
        final overflowResult =
            testDate.addMilliseconds(1500, ignoreDaylightSavings: true);
        expect(
          overflowResult.second,
          equals(46),
        ); // 45 + 1 = 46 (overflow from 1500ms)
        expect(
          overflowResult.millisecond,
          equals(623),
        ); // (123 + 1500) % 1000 = 623
      });

      test('addMicroseconds should work correctly', () {
        final result = testDate.addMicroseconds(300);

        expect(result.microsecond, equals(756));
      });

      test('addMicroseconds should work correctly with ignoreDaylightSavings',
          () {
        final result =
            testDate.addMicroseconds(300, ignoreDaylightSavings: true);

        expect(result.microsecond, equals(756)); // 456 + 300 = 756
        expect(result.millisecond, equals(123));

        // Test microsecond overflow
        final overflowResult =
            testDate.addMicroseconds(1500, ignoreDaylightSavings: true);
        expect(
          overflowResult.millisecond,
          equals(124),
        ); // 123 + 1 = 124 (overflow from 1500μs)
        expect(
          overflowResult.microsecond,
          equals(956),
        ); // (456 + 1500) % 1000 = 956
      });
    });

    group('subtract methods', () {
      test('subYears should work correctly', () {
        final result = testDate.subYears(2);

        expect(result.year, equals(2021));
      });

      test('subMonths should work correctly', () {
        final result = testDate.subMonths(3);

        expect(result.month, equals(3));
      });

      test('subDays should work correctly', () {
        final result = testDate.subDays(5);

        expect(result.day, equals(10));
      });

      test('subHours should work correctly', () {
        final result = testDate.subHours(5);

        expect(result.hour, equals(9));
      });

      test('subMinutes should work correctly', () {
        final result = testDate.subMinutes(15);

        expect(result.minute, equals(15));
      });

      test('subSeconds should work correctly', () {
        final result = testDate.subSeconds(30);

        expect(result.second, equals(15));
      });

      test('subMilliseconds should work correctly', () {
        final result = testDate.subMilliseconds(50);

        expect(result.millisecond, equals(73));
      });

      test('subMicroseconds should work correctly', () {
        final result = testDate.subMicroseconds(200);

        expect(result.microsecond, equals(256));
      });
    });

    group('clockTime', () {
      test('should return ClockTime correctly', () {
        final clockTime = testDate.clockTime;

        expect(clockTime.hour, equals(14));
        expect(clockTime.minute, equals(30));
        expect(clockTime.second, equals(45));
        expect(clockTime.millisecond, equals(123));
        expect(clockTime.microsecond, equals(456));
      });
    });

    group('weekday methods', () {
      test('isMonday should work correctly', () {
        final monday = DateTime(2023, 6, 12); // Monday
        final tuesday = DateTime(2023, 6, 13); // Tuesday

        expect(monday.isMonday, isTrue);
        expect(tuesday.isMonday, isFalse);
      });

      test('isTuesday should work correctly', () {
        final tuesday = DateTime(2023, 6, 13); // Tuesday
        final wednesday = DateTime(2023, 6, 14); // Wednesday

        expect(tuesday.isTuesday, isTrue);
        expect(wednesday.isTuesday, isFalse);
      });

      test('isWednesday should work correctly', () {
        final wednesday = DateTime(2023, 6, 14); // Wednesday
        final thursday = DateTime(2023, 6, 15); // Thursday

        expect(wednesday.isWednesday, isTrue);
        expect(thursday.isWednesday, isFalse);
      });

      test('isThursday should work correctly', () {
        final thursday = DateTime(2023, 6, 15); // Thursday
        final friday = DateTime(2023, 6, 16); // Friday

        expect(thursday.isThursday, isTrue);
        expect(friday.isThursday, isFalse);
      });

      test('isFriday should work correctly', () {
        final friday = DateTime(2023, 6, 16); // Friday
        final saturday = DateTime(2023, 6, 17); // Saturday

        expect(friday.isFriday, isTrue);
        expect(saturday.isFriday, isFalse);
      });

      test('isSaturday should work correctly', () {
        final saturday = DateTime(2023, 6, 17); // Saturday
        final sunday = DateTime(2023, 6, 18); // Sunday

        expect(saturday.isSaturday, isTrue);
        expect(sunday.isSaturday, isFalse);
      });

      test('isSunday should work correctly', () {
        final sunday = DateTime(2023, 6, 18); // Sunday
        final monday = DateTime(2023, 6, 19); // Monday

        expect(sunday.isSunday, isTrue);
        expect(monday.isSunday, isFalse);
      });

      test('isWeekend should work correctly', () {
        final saturday = DateTime(2023, 6, 17); // Saturday
        final sunday = DateTime(2023, 6, 18); // Sunday
        final monday = DateTime(2023, 6, 19); // Monday
        final friday = DateTime(2023, 6, 16); // Friday

        expect(saturday.isWeekend, isTrue);
        expect(sunday.isWeekend, isTrue);
        expect(monday.isWeekend, isFalse);
        expect(friday.isWeekend, isFalse);
      });

      test('isWeekday should work correctly', () {
        final monday = DateTime(2023, 6, 12); // Monday
        final tuesday = DateTime(2023, 6, 13); // Tuesday
        final wednesday = DateTime(2023, 6, 14); // Wednesday
        final thursday = DateTime(2023, 6, 15); // Thursday
        final friday = DateTime(2023, 6, 16); // Friday
        final saturday = DateTime(2023, 6, 17); // Saturday
        final sunday = DateTime(2023, 6, 18); // Sunday

        expect(monday.isWeekday, isTrue);
        expect(tuesday.isWeekday, isTrue);
        expect(wednesday.isWeekday, isTrue);
        expect(thursday.isWeekday, isTrue);
        expect(friday.isWeekday, isTrue);
        expect(saturday.isWeekday, isFalse);
        expect(sunday.isWeekday, isFalse);
      });

      test('all weekday methods should work with different times', () {
        // Test with different times on the same days to ensure time doesn't affect weekday
        final mondayMorning = DateTime(2023, 6, 12, 8, 30);
        final mondayEvening = DateTime(2023, 6, 12, 22, 45);

        expect(mondayMorning.isMonday, isTrue);
        expect(mondayEvening.isMonday, isTrue);
        expect(mondayMorning.isWeekday, isTrue);
        expect(mondayEvening.isWeekday, isTrue);

        final saturdayMorning = DateTime(2023, 6, 17, 9, 0);
        final saturdayEvening = DateTime(2023, 6, 17, 23, 59);

        expect(saturdayMorning.isSaturday, isTrue);
        expect(saturdayEvening.isSaturday, isTrue);
        expect(saturdayMorning.isWeekend, isTrue);
        expect(saturdayEvening.isWeekend, isTrue);
      });
    });
  });
}

import 'package:dart_time/dart_time.dart';
import 'package:test/test.dart';

void main() {
  group('IterableDateTimeHelper', () {
    final date1 = DateTime(2023, 1, 15);
    final date2 = DateTime(2023, 6, 10);
    final date3 = DateTime(2023, 12, 20);
    final date4 = DateTime(2022, 8, 5);
    final date5 = DateTime(2024, 3, 25);

    group('max', () {
      test('should return maximum date from iterable', () {
        final dates = [date1, date2, date3, date4, date5];
        final maxDate = dates.max();

        expect(maxDate, equals(date5)); // 2024-03-25 is the latest
      });

      test('should work with single element', () {
        final dates = [date1];
        final maxDate = dates.max();

        expect(maxDate, equals(date1));
      });

      test('should work with two elements', () {
        final dates = [date1, date2];
        final maxDate = dates.max();

        expect(maxDate, equals(date2)); // 2023-06-10 > 2023-01-15
      });

      test('should work with unsorted dates', () {
        final dates = [date3, date1, date5, date4, date2];
        final maxDate = dates.max();

        expect(maxDate, equals(date5)); // 2024-03-25 is still the latest
      });

      test('should work with duplicate dates', () {
        final duplicateDate = DateTime(2023, 6, 10);
        final dates = [date1, date2, duplicateDate, date3];
        final maxDate = dates.max();

        expect(maxDate, equals(date3)); // 2023-12-20 is the latest
      });

      test('should handle same dates correctly', () {
        final sameDate1 = DateTime(2023, 5, 15, 10, 30);
        final sameDate2 = DateTime(2023, 5, 15, 14, 45);
        final dates = [sameDate1, sameDate2];
        final maxDate = dates.max();

        expect(maxDate, equals(sameDate2)); // Later time on same day
      });
    });

    group('min', () {
      test('should return minimum date from iterable', () {
        final dates = [date1, date2, date3, date4, date5];
        final minDate = dates.min();

        expect(minDate, equals(date4)); // 2022-08-05 is the earliest
      });

      test('should work with single element', () {
        final dates = [date1];
        final minDate = dates.min();

        expect(minDate, equals(date1));
      });

      test('should work with two elements', () {
        final dates = [date2, date1];
        final minDate = dates.min();

        expect(minDate, equals(date1)); // 2023-01-15 < 2023-06-10
      });

      test('should work with unsorted dates', () {
        final dates = [date3, date1, date5, date4, date2];
        final minDate = dates.min();

        expect(minDate, equals(date4)); // 2022-08-05 is still the earliest
      });

      test('should work with duplicate dates', () {
        final duplicateDate = DateTime(2022, 8, 5);
        final dates = [date1, date2, duplicateDate, date3];
        final minDate = dates.min();

        // Should return the first occurrence of the minimum date
        expect(minDate, equals(duplicateDate));
      });

      test('should handle same dates correctly', () {
        final sameDate1 = DateTime(2023, 5, 15, 14, 45);
        final sameDate2 = DateTime(2023, 5, 15, 10, 30);
        final dates = [sameDate1, sameDate2];
        final minDate = dates.min();

        expect(minDate, equals(sameDate2)); // Earlier time on same day
      });
    });

    group('edge cases', () {
      test('max and min with same dates should return same result', () {
        final sameDate = DateTime(2023, 6, 15);
        final dates = [sameDate, sameDate, sameDate];

        expect(dates.max(), equals(sameDate));
        expect(dates.min(), equals(sameDate));
      });

      test('should work with dates spanning multiple years', () {
        final oldDate = DateTime(1990);
        final futureDate = DateTime(2050, 12, 31);
        final dates = [date1, oldDate, futureDate, date2];

        expect(dates.max(), equals(futureDate));
        expect(dates.min(), equals(oldDate));
      });

      test('should work with microsecond precision', () {
        final base = DateTimeHelper.named(
          year: 2023,
          month: 6,
          day: 15,
          hour: 10,
          minute: 30,
          second: 45,
          millisecond: 123,
          microsecond: 456,
        );
        final earlier = base.copyWith(microsecond: 100);
        final later = base.copyWith(microsecond: 999);
        final dates = [base, earlier, later];

        expect(dates.max(), equals(later));
        expect(dates.min(), equals(earlier));
      });
    });

    group('DateTime operations with iterable results', () {
      test('should work with filtered dates', () {
        final allDates = [date1, date2, date3, date4, date5];

        // Filter dates from 2023 only
        final dates2023 = allDates.where((date) => date.year == 2023);

        expect(dates2023.max(), equals(date3)); // 2023-12-20
        expect(dates2023.min(), equals(date1)); // 2023-01-15
      });

      test('should work with mapped dates', () {
        final baseDates = [date1, date2, date3];

        // Add one year to all dates
        final futureYearDates = baseDates.map((date) => date.addYears(1));

        final expectedMax = date3.addYears(1); // 2024-12-20
        final expectedMin = date1.addYears(1); // 2024-01-15

        expect(futureYearDates.max(), equals(expectedMax));
        expect(futureYearDates.min(), equals(expectedMin));
      });
    });

    group('spanInDays', () {
      test('should calculate span correctly', () {
        final dates = [date1, date2, date3]; // 2023-01-15 to 2023-12-20
        final span = dates.spanInDays;

        expect(span, equals(339)); // Days between Jan 15 and Dec 20
      });

      test('should throw StateError for empty iterable', () {
        final emptyDates = <DateTime>[];
        expect(() => emptyDates.spanInDays, throwsA(isA<StateError>()));
      });

      test('should return 0 for single date', () {
        final dates = [date1];
        expect(dates.spanInDays, equals(0));
      });
    });

    group('closestTo', () {
      test('should find closest date', () {
        final dates = [date1, date2, date3]; // Jan 15, Jun 10, Dec 20
        final target = DateTime(2023, 6, 15); // Close to Jun 10

        expect(dates.closestTo(target), equals(date2));
      });

      test('should throw StateError for empty iterable', () {
        final emptyDates = <DateTime>[];
        final target = DateTime(2023, 6, 15);

        expect(() => emptyDates.closestTo(target), throwsA(isA<StateError>()));
      });

      test('should handle exact match', () {
        final dates = [date1, date2, date3];

        expect(dates.closestTo(date2), equals(date2));
      });
    });

    group('weekday filtering', () {
      late List<DateTime> weekDates;

      setUp(() {
        // June 12-18, 2023: Mon, Tue, Wed, Thu, Fri, Sat, Sun
        weekDates = [
          DateTime(2023, 6, 12), // Monday
          DateTime(2023, 6, 13), // Tuesday
          DateTime(2023, 6, 14), // Wednesday
          DateTime(2023, 6, 15), // Thursday
          DateTime(2023, 6, 16), // Friday
          DateTime(2023, 6, 17), // Saturday
          DateTime(2023, 6, 18), // Sunday
        ];
      });

      test('weekdaysOnly should filter correctly', () {
        final weekdays = weekDates.weekdaysOnly;

        expect(weekdays.length, equals(5));
        expect(weekdays.every((date) => date.isWeekday), isTrue);
      });

      test('weekendsOnly should filter correctly', () {
        final weekends = weekDates.weekendsOnly;

        expect(weekends.length, equals(2));
        expect(weekends.every((date) => date.isWeekend), isTrue);
      });
    });

    group('sorting', () {
      test('sortedAscending should sort correctly', () {
        final unsorted = [date3, date1, date2]; // Dec, Jan, Jun
        final sorted = unsorted.sortedAscending();

        expect(sorted, equals([date1, date2, date3]));
      });

      test('sortedDescending should sort correctly', () {
        final unsorted = [date1, date3, date2]; // Jan, Dec, Jun
        final sorted = unsorted.sortedDescending();

        expect(sorted, equals([date3, date2, date1]));
      });
    });

    group('median', () {
      test('should return median for odd number of dates', () {
        final dates = [date1, date2, date3]; // Jan 15, Jun 10, Dec 20
        final median = dates.median();

        expect(median, equals(date2)); // Jun 10 is the middle
      });

      test('should return earlier of two middle dates for even number', () {
        final dates = [
          date1,
          date2,
          date3,
          date4,
        ]; // Jan 15, Jun 10, Dec 20, Aug 5
        final median = dates.median();

        // Sorted: Aug 5 (2022), Jan 15, Jun 10, Dec 20
        // Middle two: Jan 15 and Jun 10 -> return Jan 15 (earlier)
        expect(median, equals(date1));
      });

      test('should work with single element', () {
        final dates = [date1];
        final median = dates.median();

        expect(median, equals(date1));
      });

      test('should work with two elements', () {
        final dates = [date2, date1]; // Jun 10, Jan 15
        final median = dates.median();

        // Should return earlier date (Jan 15)
        expect(median, equals(date1));
      });

      test('should handle duplicate dates correctly', () {
        final duplicate = DateTime(2023, 6, 10);
        final dates = [date1, date2, duplicate, date3]; // 4 elements
        final median = dates.median();

        // Sorted: Jan 15, Jun 10, Jun 10, Dec 20
        // Middle two: Jun 10 and Jun 10 -> return first Jun 10
        expect(median, equals(date2));
      });

      test('should throw StateError for empty iterable', () {
        final emptyDates = <DateTime>[];
        expect(emptyDates.median, throwsA(isA<StateError>()));
      });

      test('should handle unsorted dates correctly', () {
        final unsorted = [
          date3,
          date1,
          date5,
          date2,
        ]; // Dec, Jan, Mar 2024, Jun
        final median = unsorted.median();

        // Sorted: Jan 15, Jun 10, Dec 20, Mar 25 2024
        // Middle two: Jun 10 and Dec 20 -> return Jun 10 (earlier)
        expect(median, equals(date2));
      });

      test('should work with microsecond precision', () {
        final base = DateTime(2023, 6, 15, 10, 30, 45, 123, 456);
        final earlier = base.copyWith(microsecond: 100);
        final later = base.copyWith(microsecond: 800);
        final dates = [base, earlier, later];
        final median = dates.median();

        expect(median, equals(base)); // Middle element
      });
    });

    group('mode', () {
      test('should return most frequent date', () {
        final dates = [
          date1, // Jan 15
          date2, // Jun 10
          date1, // Jan 15 (appears twice)
          date3, // Dec 20
        ];
        final mode = dates.mode();

        expect(mode, equals(date1)); // Jan 15 appears most frequently
      });

      test('should return earliest date when all have same frequency', () {
        final dates = [date3, date1, date2]; // Dec, Jan, Jun (all appear once)
        final mode = dates.mode();

        expect(mode, equals(date1)); // Jan 15 is earliest
      });

      test('should return earliest among multiple modes', () {
        final dates = [
          date1, date1, // Jan 15 (twice)
          date2, date2, // Jun 10 (twice)
          date3, // Dec 20 (once)
        ];
        final mode = dates.mode();

        expect(mode, equals(date1)); // Jan 15 is earlier than Jun 10
      });

      test('should work with single element', () {
        final dates = [date1];
        final mode = dates.mode();

        expect(mode, equals(date1));
      });

      test('should handle all same dates', () {
        final dates = [date1, date1, date1];
        final mode = dates.mode();

        expect(mode, equals(date1));
      });

      test('should throw StateError for empty iterable', () {
        final emptyDates = <DateTime>[];
        expect(emptyDates.mode, throwsA(isA<StateError>()));
      });

      test('should work with complex frequency pattern', () {
        final extraDate = DateTime(2023, 3, 10);
        final dates = [
          date1, date1, date1, // Jan 15 (3 times)
          date2, date2, // Jun 10 (2 times)
          extraDate, extraDate, extraDate, extraDate, // Mar 10 (4 times)
          date3, // Dec 20 (1 time)
        ];
        final mode = dates.mode();

        expect(mode, equals(extraDate)); // Mar 10 appears most (4 times)
      });

      test('should handle dates with different years', () {
        final date2022 = DateTime(2022, 6, 10);
        final date2023 = DateTime(2023, 6, 10);
        final dates = [
          date2023, date2023, // 2023-06-10 (twice)
          date2022, date2022, // 2022-06-10 (twice)
          date1, // 2023-01-15 (once)
        ];
        final mode = dates.mode();

        expect(mode, equals(date2022)); // 2022-06-10 is earlier
      });
    });

    group('averageGap', () {
      test('should calculate average gap correctly', () {
        final dates = [
          DateTime(2023), // Start
          DateTime(2023, 1, 3), // +2 days
          DateTime(2023, 1, 7), // +4 days
          DateTime(2023, 1, 9), // +2 days
        ];
        final averageGap = dates.averageGap;

        // Gaps: 2 days, 4 days, 2 days
        // Average: (2 + 4 + 2) / 3 = 2.67 days = 2 days 16 hours
        expect(averageGap.inDays, equals(2));
        expect(averageGap.inHours, equals(64)); // 2 days + 16 hours = 64 hours
      });

      test('should work with two dates', () {
        final dates = [
          DateTime(2023),
          DateTime(2023, 1, 6), // +5 days
        ];
        final averageGap = dates.averageGap;

        expect(averageGap.inDays, equals(5));
      });

      test('should handle unsorted dates', () {
        final dates = [
          DateTime(2023, 1, 9), // Will be sorted
          DateTime(2023),
          DateTime(2023, 1, 5),
        ];
        final averageGap = dates.averageGap;

        // Sorted: Jan 1, Jan 5, Jan 9
        // Gaps: 4 days, 4 days
        // Average: 4 days
        expect(averageGap.inDays, equals(4));
      });

      test('should handle same dates', () {
        final sameDate = DateTime(2023);
        final dates = [sameDate, sameDate, sameDate];
        final averageGap = dates.averageGap;

        expect(averageGap, equals(Duration.zero));
      });

      test('should work with hour precision', () {
        final dates = [
          DateTime(2023, 1, 1, 10), // 10:00
          DateTime(2023, 1, 1, 12), // 12:00 (+2 hours)
          DateTime(2023, 1, 1, 16), // 16:00 (+4 hours)
        ];
        final averageGap = dates.averageGap;

        // Gaps: 2 hours, 4 hours
        // Average: 3 hours
        expect(averageGap.inHours, equals(3));
      });

      test('should work with microsecond precision', () {
        final base = DateTime(2023, 1, 1, 10);
        final dates = [
          base,
          base.add(const Duration(microseconds: 1000)), // +1000 μs
          base.add(const Duration(microseconds: 3000)), // +2000 μs more
        ];
        final averageGap = dates.averageGap;

        // Gaps: 1000 μs, 2000 μs
        // Average: 1500 μs
        expect(averageGap.inMicroseconds, equals(1500));
      });

      test('should throw StateError for empty iterable', () {
        final emptyDates = <DateTime>[];
        expect(() => emptyDates.averageGap, throwsA(isA<StateError>()));
      });

      test('should throw StateError for single date', () {
        final dates = [DateTime(2023)];
        expect(() => dates.averageGap, throwsA(isA<StateError>()));
      });

      test('should handle large gaps correctly', () {
        final dates = [
          DateTime(2020),
          DateTime(2021), // +365/366 days
          DateTime(2023), // +730 days
        ];
        final averageGap = dates.averageGap;

        // Gaps: ~365 days, ~730 days
        // Average: ~547.5 days
        expect(averageGap.inDays, greaterThan(500));
        expect(averageGap.inDays, lessThan(600));
      });

      test('should work with negative gaps (when dates go backwards)', () {
        // Note: this shouldn't happen with proper sorting,
        // but testing robustness
        final dates = [
          DateTime(2023),
          DateTime(2023, 1, 5),
          DateTime(2023, 1, 3), // This will be sorted to middle
        ];
        final averageGap = dates.averageGap;

        // After sorting: Jan 1, Jan 3, Jan 5
        // Gaps: 2 days, 2 days
        // Average: 2 days
        expect(averageGap.inDays, equals(2));
      });
    });
  });
}

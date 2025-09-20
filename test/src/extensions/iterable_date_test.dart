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
        final oldDate = DateTime(1990, 1, 1);
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
  });
}

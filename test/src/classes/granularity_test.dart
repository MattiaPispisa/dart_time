import 'package:dart_time/dart_time.dart';
import 'package:test/test.dart';

void main() {
  group('TimeGranularity', () {
    group('enum values', () {
      test('should have all expected values', () {
        const values = TimeGranularity.values;

        expect(values, contains(TimeGranularity.year));
        expect(values, contains(TimeGranularity.month));
        expect(values, contains(TimeGranularity.day));
        expect(values, contains(TimeGranularity.hour));
        expect(values, contains(TimeGranularity.minute));
        expect(values, contains(TimeGranularity.second));
        expect(values, contains(TimeGranularity.milliseconds));
        expect(values, contains(TimeGranularity.microseconds));
        expect(values.length, equals(8));
      });
    });

    group('isYear', () {
      test('should return true for year granularity', () {
        expect(TimeGranularity.year.isYear, isTrue);
      });

      test('should return false for non-year granularities', () {
        expect(TimeGranularity.month.isYear, isFalse);
        expect(TimeGranularity.day.isYear, isFalse);
        expect(TimeGranularity.hour.isYear, isFalse);
        expect(TimeGranularity.minute.isYear, isFalse);
        expect(TimeGranularity.second.isYear, isFalse);
        expect(TimeGranularity.milliseconds.isYear, isFalse);
        expect(TimeGranularity.microseconds.isYear, isFalse);
      });
    });

    group('isMonth', () {
      test('should return true for month granularity', () {
        expect(TimeGranularity.month.isMonth, isTrue);
      });

      test('should return false for non-month granularities', () {
        expect(TimeGranularity.year.isMonth, isFalse);
        expect(TimeGranularity.day.isMonth, isFalse);
        expect(TimeGranularity.hour.isMonth, isFalse);
        expect(TimeGranularity.minute.isMonth, isFalse);
        expect(TimeGranularity.second.isMonth, isFalse);
        expect(TimeGranularity.milliseconds.isMonth, isFalse);
        expect(TimeGranularity.microseconds.isMonth, isFalse);
      });
    });

    group('isDay', () {
      test('should return true for day granularity', () {
        expect(TimeGranularity.day.isDay, isTrue);
      });

      test('should return false for non-day granularities', () {
        expect(TimeGranularity.year.isDay, isFalse);
        expect(TimeGranularity.month.isDay, isFalse);
        expect(TimeGranularity.hour.isDay, isFalse);
        expect(TimeGranularity.minute.isDay, isFalse);
        expect(TimeGranularity.second.isDay, isFalse);
        expect(TimeGranularity.milliseconds.isDay, isFalse);
        expect(TimeGranularity.microseconds.isDay, isFalse);
      });
    });

    group('isHour', () {
      test('should return true for hour granularity', () {
        expect(TimeGranularity.hour.isHour, isTrue);
      });

      test('should return false for non-hour granularities', () {
        expect(TimeGranularity.year.isHour, isFalse);
        expect(TimeGranularity.month.isHour, isFalse);
        expect(TimeGranularity.day.isHour, isFalse);
        expect(TimeGranularity.minute.isHour, isFalse);
        expect(TimeGranularity.second.isHour, isFalse);
        expect(TimeGranularity.milliseconds.isHour, isFalse);
        expect(TimeGranularity.microseconds.isHour, isFalse);
      });
    });

    group('isMinute', () {
      test('should return true for minute granularity', () {
        expect(TimeGranularity.minute.isMinute, isTrue);
      });

      test('should return false for non-minute granularities', () {
        expect(TimeGranularity.year.isMinute, isFalse);
        expect(TimeGranularity.month.isMinute, isFalse);
        expect(TimeGranularity.day.isMinute, isFalse);
        expect(TimeGranularity.hour.isMinute, isFalse);
        expect(TimeGranularity.second.isMinute, isFalse);
        expect(TimeGranularity.milliseconds.isMinute, isFalse);
        expect(TimeGranularity.microseconds.isMinute, isFalse);
      });
    });

    group('isSecond', () {
      test('should return true for second granularity', () {
        expect(TimeGranularity.second.isSecond, isTrue);
      });

      test('should return false for non-second granularities', () {
        expect(TimeGranularity.year.isSecond, isFalse);
        expect(TimeGranularity.month.isSecond, isFalse);
        expect(TimeGranularity.day.isSecond, isFalse);
        expect(TimeGranularity.hour.isSecond, isFalse);
        expect(TimeGranularity.minute.isSecond, isFalse);
        expect(TimeGranularity.milliseconds.isSecond, isFalse);
        expect(TimeGranularity.microseconds.isSecond, isFalse);
      });
    });

    group('isMilliseconds', () {
      test('should return true for milliseconds granularity', () {
        expect(TimeGranularity.milliseconds.isMilliseconds, isTrue);
      });

      test('should return false for non-milliseconds granularities', () {
        expect(TimeGranularity.year.isMilliseconds, isFalse);
        expect(TimeGranularity.month.isMilliseconds, isFalse);
        expect(TimeGranularity.day.isMilliseconds, isFalse);
        expect(TimeGranularity.hour.isMilliseconds, isFalse);
        expect(TimeGranularity.minute.isMilliseconds, isFalse);
        expect(TimeGranularity.second.isMilliseconds, isFalse);
        expect(TimeGranularity.microseconds.isMilliseconds, isFalse);
      });
    });

    group('isMicroseconds', () {
      test('should return true for microseconds granularity', () {
        expect(TimeGranularity.microseconds.isMicroseconds, isTrue);
      });

      test('should return false for non-microseconds granularities', () {
        expect(TimeGranularity.year.isMicroseconds, isFalse);
        expect(TimeGranularity.month.isMicroseconds, isFalse);
        expect(TimeGranularity.day.isMicroseconds, isFalse);
        expect(TimeGranularity.hour.isMicroseconds, isFalse);
        expect(TimeGranularity.minute.isMicroseconds, isFalse);
        expect(TimeGranularity.second.isMicroseconds, isFalse);
        expect(TimeGranularity.milliseconds.isMicroseconds, isFalse);
      });
    });

    group('map', () {
      test('should map year granularity correctly', () {
        final result = TimeGranularity.year.map<String>(
          year: () => 'year_result',
          month: () => 'month_result',
          day: () => 'day_result',
          hour: () => 'hour_result',
          minute: () => 'minute_result',
          second: () => 'second_result',
          milliseconds: () => 'milliseconds_result',
          microseconds: () => 'microseconds_result',
        );

        expect(result, equals('year_result'));
      });

      test('should map month granularity correctly', () {
        final result = TimeGranularity.month.map<String>(
          year: () => 'year_result',
          month: () => 'month_result',
          day: () => 'day_result',
          hour: () => 'hour_result',
          minute: () => 'minute_result',
          second: () => 'second_result',
          milliseconds: () => 'milliseconds_result',
          microseconds: () => 'microseconds_result',
        );

        expect(result, equals('month_result'));
      });

      test('should map day granularity correctly', () {
        final result = TimeGranularity.day.map<String>(
          year: () => 'year_result',
          month: () => 'month_result',
          day: () => 'day_result',
          hour: () => 'hour_result',
          minute: () => 'minute_result',
          second: () => 'second_result',
          milliseconds: () => 'milliseconds_result',
          microseconds: () => 'microseconds_result',
        );

        expect(result, equals('day_result'));
      });

      test('should map hour granularity correctly', () {
        final result = TimeGranularity.hour.map<String>(
          year: () => 'year_result',
          month: () => 'month_result',
          day: () => 'day_result',
          hour: () => 'hour_result',
          minute: () => 'minute_result',
          second: () => 'second_result',
          milliseconds: () => 'milliseconds_result',
          microseconds: () => 'microseconds_result',
        );

        expect(result, equals('hour_result'));
      });

      test('should map minute granularity correctly', () {
        final result = TimeGranularity.minute.map<String>(
          year: () => 'year_result',
          month: () => 'month_result',
          day: () => 'day_result',
          hour: () => 'hour_result',
          minute: () => 'minute_result',
          second: () => 'second_result',
          milliseconds: () => 'milliseconds_result',
          microseconds: () => 'microseconds_result',
        );

        expect(result, equals('minute_result'));
      });

      test('should map second granularity correctly', () {
        final result = TimeGranularity.second.map<String>(
          year: () => 'year_result',
          month: () => 'month_result',
          day: () => 'day_result',
          hour: () => 'hour_result',
          minute: () => 'minute_result',
          second: () => 'second_result',
          milliseconds: () => 'milliseconds_result',
          microseconds: () => 'microseconds_result',
        );

        expect(result, equals('second_result'));
      });

      test('should map milliseconds granularity correctly', () {
        final result = TimeGranularity.milliseconds.map<String>(
          year: () => 'year_result',
          month: () => 'month_result',
          day: () => 'day_result',
          hour: () => 'hour_result',
          minute: () => 'minute_result',
          second: () => 'second_result',
          milliseconds: () => 'milliseconds_result',
          microseconds: () => 'microseconds_result',
        );

        expect(result, equals('milliseconds_result'));
      });

      test('should map microseconds granularity correctly', () {
        final result = TimeGranularity.microseconds.map<String>(
          year: () => 'year_result',
          month: () => 'month_result',
          day: () => 'day_result',
          hour: () => 'hour_result',
          minute: () => 'minute_result',
          second: () => 'second_result',
          milliseconds: () => 'milliseconds_result',
          microseconds: () => 'microseconds_result',
        );

        expect(result, equals('microseconds_result'));
      });

      test('should map with different return types', () {
        final intResult = TimeGranularity.day.map<int>(
          year: () => 1,
          month: () => 2,
          day: () => 3,
          hour: () => 4,
          minute: () => 5,
          second: () => 6,
          milliseconds: () => 7,
          microseconds: () => 8,
        );

        expect(intResult, equals(3));
        expect(intResult, isA<int>());
      });

      test('should map with complex return types', () {
        final listResult = TimeGranularity.hour.map<List<String>>(
          year: () => ['year'],
          month: () => ['month'],
          day: () => ['day'],
          hour: () => ['hour', 'time'],
          minute: () => ['minute'],
          second: () => ['second'],
          milliseconds: () => ['milliseconds'],
          microseconds: () => ['microseconds'],
        );

        expect(listResult, equals(['hour', 'time']));
        expect(listResult, isA<List<String>>());
      });
    });

    group('comprehensive behavior', () {
      test('should handle all granularities in a loop', () {
        const granularities = TimeGranularity.values;
        final results = <String>[];

        for (final granularity in granularities) {
          final result = granularity.map<String>(
            year: () => 'year',
            month: () => 'month',
            day: () => 'day',
            hour: () => 'hour',
            minute: () => 'minute',
            second: () => 'second',
            milliseconds: () => 'milliseconds',
            microseconds: () => 'microseconds',
          );
          results.add(result);
        }

        expect(
            results,
            equals([
              'year',
              'month',
              'day',
              'hour',
              'minute',
              'second',
              'milliseconds',
              'microseconds',
            ]));
      });

      test('should maintain correct enum ordering', () {
        const values = TimeGranularity.values;

        expect(values[0], equals(TimeGranularity.year));
        expect(values[1], equals(TimeGranularity.month));
        expect(values[2], equals(TimeGranularity.day));
        expect(values[3], equals(TimeGranularity.hour));
        expect(values[4], equals(TimeGranularity.minute));
        expect(values[5], equals(TimeGranularity.second));
        expect(values[6], equals(TimeGranularity.milliseconds));
        expect(values[7], equals(TimeGranularity.microseconds));
      });
    });
  });
}

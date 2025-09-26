import 'package:dart_time/dart_time.dart';
import 'package:test/test.dart';

void main() {
  group('ClockTime', () {
    group('constructor', () {
      test('should create valid ClockTime with all parameters', () {
        final time = ClockTime(
          14,
          minute: 30,
          second: 45,
          millisecond: 123,
          microsecond: 456,
        );

        expect(time.hour, equals(14));
        expect(time.minute, equals(30));
        expect(time.second, equals(45));
        expect(time.millisecond, equals(123));
        expect(time.microsecond, equals(456));
      });

      test('should create ClockTime with only hour', () {
        final time = ClockTime(9);

        expect(time.hour, equals(9));
        expect(time.minute, equals(0));
        expect(time.second, equals(0));
        expect(time.millisecond, equals(0));
        expect(time.microsecond, equals(0));
      });

      test('should throw ArgumentError for invalid hour', () {
        expect(() => ClockTime(-1), throwsArgumentError);
        expect(() => ClockTime(24), throwsArgumentError);
        expect(() => ClockTime(25), throwsArgumentError);
      });

      test('should throw ArgumentError for invalid minute', () {
        expect(() => ClockTime(12, minute: -1), throwsArgumentError);
        expect(() => ClockTime(12, minute: 60), throwsArgumentError);
      });

      test('should throw ArgumentError for invalid second', () {
        expect(() => ClockTime(12, second: -1), throwsArgumentError);
        expect(() => ClockTime(12, second: 60), throwsArgumentError);
      });

      test('should throw ArgumentError for invalid millisecond', () {
        expect(() => ClockTime(12, millisecond: -1), throwsArgumentError);
        expect(() => ClockTime(12, millisecond: 1000), throwsArgumentError);
      });

      test('should throw ArgumentError for invalid microsecond', () {
        expect(() => ClockTime(12, microsecond: -1), throwsArgumentError);
        expect(() => ClockTime(12, microsecond: 1000), throwsArgumentError);
      });
    });

    group('ClockTime.parse', () {
      test('should parse time with hours and minutes', () {
        final time = ClockTime.parse('14:30');

        expect(time.hour, equals(14));
        expect(time.minute, equals(30));
        expect(time.second, equals(0));
        expect(time.millisecond, equals(0));
        expect(time.microsecond, equals(0));
      });

      test('should parse time with hours, minutes and seconds', () {
        final time = ClockTime.parse('14:30:45');

        expect(time.hour, equals(14));
        expect(time.minute, equals(30));
        expect(time.second, equals(45));
        expect(time.millisecond, equals(0));
        expect(time.microsecond, equals(0));
      });

      test('should parse time with full precision', () {
        final time = ClockTime.parse('14:30:45.123456');

        expect(time.hour, equals(14));
        expect(time.minute, equals(30));
        expect(time.second, equals(45));
        expect(time.millisecond, equals(123));
        expect(time.microsecond, equals(456));
      });

      test('should throw ArgumentError for invalid format', () {
        expect(() => ClockTime.parse('14'), throwsArgumentError);
        expect(() => ClockTime.parse('14:30:45:67'), throwsArgumentError);
        expect(() => ClockTime.parse('invalid'), throwsArgumentError);
      });
    });

    group('ClockTime.fromJson', () {
      test('should create ClockTime from JSON', () {
        final json = {
          'hour': 14,
          'minute': 30,
          'second': 45,
          'millisecond': 123,
          'microsecond': 456,
        };
        final time = ClockTime.fromJson(json);

        expect(time.hour, equals(14));
        expect(time.minute, equals(30));
        expect(time.second, equals(45));
        expect(time.millisecond, equals(123));
        expect(time.microsecond, equals(456));
      });
    });

    group('ClockTime.now', () {
      test('should create ClockTime for current time', () {
        final now = DateTime.now();
        final clockTimeNow = ClockTime.now();

        // Allow 1 second difference for test execution time
        expect(clockTimeNow.hour, equals(now.hour));
        expect(clockTimeNow.minute, equals(now.minute));
      });
    });

    group('ClockTime.midnight', () {
      test('should create ClockTime for midnight', () {
        final midnight = ClockTime.midnight();

        expect(midnight.hour, equals(0));
        expect(midnight.minute, equals(0));
        expect(midnight.second, equals(0));
        expect(midnight.millisecond, equals(0));
        expect(midnight.microsecond, equals(0));
      });
    });

    group('ClockTime.noon', () {
      test('should create ClockTime for noon', () {
        final noon = ClockTime.noon();

        expect(noon.hour, equals(12));
        expect(noon.minute, equals(0));
        expect(noon.second, equals(0));
        expect(noon.millisecond, equals(0));
        expect(noon.microsecond, equals(0));
      });
    });

    group('copyWith', () {
      test('should copy ClockTime with new values', () {
        final original = ClockTime(14, minute: 30, second: 45);
        final copied = original.copyWith(hour: 15, minute: 35);

        expect(copied.hour, equals(15));
        expect(copied.minute, equals(35));
        expect(copied.second, equals(45));
        expect(copied.millisecond, equals(0));
        expect(copied.microsecond, equals(0));
      });

      test('should copy ClockTime with no changes', () {
        final original = ClockTime(14, minute: 30, second: 45);
        final copied = original.copyWith();

        expect(copied, equals(original));
      });
    });

    group('inDate', () {
      test('should return date with start time', () {
        final range = ClockTime(9, minute: 30, second: 45);
        final date = DateTimeHelper.named(
          year: 2023,
          month: 6,
          day: 15,
        );
        final result = range.inDate(date);
        expect(result.isSameDay(date), isTrue);
        expect(result, equals(date.copyWith(hour: 9, minute: 30, second: 45)));
      });
    });

    group('toJson', () {
      test('should convert ClockTime to JSON', () {
        final time = ClockTime(
          14,
          minute: 30,
          second: 45,
          millisecond: 123,
          microsecond: 456,
        );
        final json = time.toJson();

        expect(json['hour'], equals(14));
        expect(json['minute'], equals(30));
        expect(json['second'], equals(45));
        expect(json['millisecond'], equals(123));
        expect(json['microsecond'], equals(456));
      });
    });

    group('comparison methods', () {
      test('isAtSameTimeAs should work correctly', () {
        final time1 = ClockTime(14, minute: 30);
        final time2 = ClockTime(14, minute: 30);
        final time3 = ClockTime(14, minute: 31);

        expect(time1.isAtSameTimeAs(time2), isTrue);
        expect(time1.isAtSameTimeAs(time3), isFalse);
      });

      test('isAfter should work correctly', () {
        final time1 = ClockTime(14, minute: 30);
        final time2 = ClockTime(14, minute: 29);
        final time3 = ClockTime(14, minute: 31);

        expect(time1.isAfter(time2), isTrue);
        expect(time1.isAfter(time3), isFalse);
        expect(time1.isAfter(time1), isFalse);
      });

      test('isBefore should work correctly', () {
        final time1 = ClockTime(14, minute: 30);
        final time2 = ClockTime(14, minute: 29);
        final time3 = ClockTime(14, minute: 31);

        expect(time1.isBefore(time2), isFalse);
        expect(time1.isBefore(time3), isTrue);
        expect(time1.isBefore(time1), isFalse);
      });

      test('isSameOrAfter should work correctly', () {
        final time1 = ClockTime(14, minute: 30);
        final time2 = ClockTime(14, minute: 29);
        final time3 = ClockTime(14, minute: 30);
        final time4 = ClockTime(14, minute: 31);

        expect(time1.isSameOrAfter(time2), isTrue);
        expect(time1.isSameOrAfter(time3), isTrue);
        expect(time1.isSameOrAfter(time4), isFalse);
      });

      test('isSameOrBefore should work correctly', () {
        final time1 = ClockTime(14, minute: 30);
        final time2 = ClockTime(14, minute: 29);
        final time3 = ClockTime(14, minute: 30);
        final time4 = ClockTime(14, minute: 31);

        expect(time1.isSameOrBefore(time2), isFalse);
        expect(time1.isSameOrBefore(time3), isTrue);
        expect(time1.isSameOrBefore(time4), isTrue);
      });
    });

    group('operators', () {
      test('< operator should work correctly', () {
        final time1 = ClockTime(14, minute: 30);
        final time2 = ClockTime(14, minute: 31);

        expect(time1 < time2, isTrue);
        expect(time2 < time1, isFalse);
      });

      test('<= operator should work correctly', () {
        final time1 = ClockTime(14, minute: 30);
        final time2 = ClockTime(14, minute: 30);
        final time3 = ClockTime(14, minute: 31);

        expect(time1 <= time2, isTrue);
        expect(time1 <= time3, isTrue);
        expect(time3 <= time1, isFalse);
      });

      test('> operator should work correctly', () {
        final time1 = ClockTime(14, minute: 30);
        final time2 = ClockTime(14, minute: 29);

        expect(time1 > time2, isTrue);
        expect(time2 > time1, isFalse);
      });

      test('>= operator should work correctly', () {
        final time1 = ClockTime(14, minute: 30);
        final time2 = ClockTime(14, minute: 30);
        final time3 = ClockTime(14, minute: 29);

        expect(time1 >= time2, isTrue);
        expect(time1 >= time3, isTrue);
        expect(time3 >= time1, isFalse);
      });

      test('- operator should work correctly', () {
        final time1 = ClockTime(14, minute: 30);
        final time2 = ClockTime(12, minute: 15);
        final result = time1 - time2;

        expect(result, equals(const Duration(hours: 2, minutes: 15)));
      });

      test('+ operator should work correctly', () {
        final time1 = ClockTime(14, minute: 30);
        final time2 = ClockTime(2, minute: 15);
        final result = time1 + time2;

        expect(result, equals(const Duration(hours: 16, minutes: 45)));
      });
    });

    group('toDuration', () {
      test('should convert ClockTime to Duration', () {
        final time = ClockTime(
          14,
          minute: 30,
          second: 45,
          millisecond: 123,
          microsecond: 456,
        );
        final duration = time.toDuration();

        expect(duration.inHours, equals(14));
        expect(duration.inMinutes % 60, equals(30));
        expect(duration.inSeconds % 60, equals(45));
        expect(duration.inMilliseconds % 1000, equals(123));
        expect(duration.inMicroseconds % 1000, equals(456));
      });
    });

    group('add', () {
      test('should add duration without wrapping', () {
        final time = ClockTime(10, minute: 30);
        final result = time.add(const Duration(hours: 2, minutes: 15));

        expect(result.hour, equals(12));
        expect(result.minute, equals(45));
      });

      test('should add duration with wrapping', () {
        final time = ClockTime(23, minute: 30);
        final result = time.add(const Duration(hours: 1, minutes: 45));

        expect(result.hour, equals(1));
        expect(result.minute, equals(15));
      });

      test('should handle adding full day', () {
        final time = ClockTime(14, minute: 30);
        final result = time.add(const Duration(days: 1));

        expect(result.hour, equals(14));
        expect(result.minute, equals(30));
      });
    });

    group('subtract', () {
      test('should subtract duration without wrapping', () {
        final time = ClockTime(14, minute: 30);
        final result = time.subtract(const Duration(hours: 2, minutes: 15));

        expect(result.hour, equals(12));
        expect(result.minute, equals(15));
      });

      test('should subtract duration with wrapping', () {
        final time = ClockTime(1, minute: 30);
        final result = time.subtract(const Duration(hours: 2));

        expect(result.hour, equals(23));
        expect(result.minute, equals(30));
      });
    });

    group('addHours', () {
      test('should add hours without wrapping', () {
        final time = ClockTime(10);
        final result = time.addHours(5);

        expect(result.hour, equals(15));
      });

      test('should add hours with wrapping', () {
        final time = ClockTime(22);
        final result = time.addHours(3);

        expect(result.hour, equals(1));
      });
    });

    group('addMinutes', () {
      test('should add minutes without wrapping hour', () {
        final time = ClockTime(10, minute: 30);
        final result = time.addMinutes(15);

        expect(result.hour, equals(10));
        expect(result.minute, equals(45));
      });

      test('should add minutes with wrapping hour', () {
        final time = ClockTime(23, minute: 45);
        final result = time.addMinutes(30);

        expect(result.hour, equals(0));
        expect(result.minute, equals(15));
      });
    });

    group('addSeconds', () {
      test('should add seconds without wrapping', () {
        final time = ClockTime(10, minute: 30, second: 15);
        final result = time.addSeconds(30);

        expect(result.hour, equals(10));
        expect(result.minute, equals(30));
        expect(result.second, equals(45));
      });

      test('should add seconds with wrapping', () {
        final time = ClockTime(23, minute: 59, second: 45);
        final result = time.addSeconds(30);

        expect(result.hour, equals(0));
        expect(result.minute, equals(0));
        expect(result.second, equals(15));
      });
    });

    group('format12Hour', () {
      test('should format midnight correctly', () {
        final time = ClockTime(0);
        expect(time.format12Hour, equals('12:00 AM'));
      });

      test('should format morning time correctly', () {
        final time = ClockTime(9, minute: 30);
        expect(time.format12Hour, equals('9:30 AM'));
      });

      test('should format noon correctly', () {
        final time = ClockTime(12, minute: 15);
        expect(time.format12Hour, equals('12:15 PM'));
      });

      test('should format afternoon time correctly', () {
        final time = ClockTime(13, minute: 45);
        expect(time.format12Hour, equals('1:45 PM'));
      });

      test('should format evening time correctly', () {
        final time = ClockTime(23, minute: 59);
        expect(time.format12Hour, equals('11:59 PM'));
      });
    });

    group('format24Hour', () {
      test('should format 24-hour time correctly', () {
        final time1 = ClockTime(9, minute: 5);
        final time2 = ClockTime(15, minute: 30);
        final time3 = ClockTime(0, minute: 0);

        expect(time1.format24Hour, equals('09:05'));
        expect(time2.format24Hour, equals('15:30'));
        expect(time3.format24Hour, equals('00:00'));
      });
    });

    group('formatWithSeconds', () {
      test('should format time with seconds correctly', () {
        final time = ClockTime(9, minute: 5, second: 30);
        expect(time.formatWithSeconds, equals('09:05:30'));
      });
    });

    group('period classification', () {
      test('isMorning should work correctly', () {
        expect(ClockTime(6).isMorning, isTrue);
        expect(ClockTime(8).isMorning, isTrue);
        expect(ClockTime(11, minute: 59).isMorning, isTrue);
        expect(ClockTime(5, minute: 59).isMorning, isFalse);
        expect(ClockTime(12).isMorning, isFalse);
      });

      test('isAfternoon should work correctly', () {
        expect(ClockTime(12).isAfternoon, isTrue);
        expect(ClockTime(15).isAfternoon, isTrue);
        expect(ClockTime(17, minute: 59).isAfternoon, isTrue);
        expect(ClockTime(11, minute: 59).isAfternoon, isFalse);
        expect(ClockTime(18).isAfternoon, isFalse);
      });

      test('isEvening should work correctly', () {
        expect(ClockTime(18).isEvening, isTrue);
        expect(ClockTime(20).isEvening, isTrue);
        expect(ClockTime(21, minute: 59).isEvening, isTrue);
        expect(ClockTime(17, minute: 59).isEvening, isFalse);
        expect(ClockTime(22).isEvening, isFalse);
      });

      test('isNight should work correctly', () {
        expect(ClockTime(22).isNight, isTrue);
        expect(ClockTime(0).isNight, isTrue);
        expect(ClockTime(3).isNight, isTrue);
        expect(ClockTime(5, minute: 59).isNight, isTrue);
        expect(ClockTime(6).isNight, isFalse);
        expect(ClockTime(21, minute: 59).isNight, isFalse);
      });

      test('isAM should work correctly', () {
        expect(ClockTime(0).isAM, isTrue);
        expect(ClockTime(6).isAM, isTrue);
        expect(ClockTime(11, minute: 59).isAM, isTrue);
        expect(ClockTime(12).isAM, isFalse);
        expect(ClockTime(23).isAM, isFalse);
      });

      test('isPM should work correctly', () {
        expect(ClockTime(12).isPM, isTrue);
        expect(ClockTime(18).isPM, isTrue);
        expect(ClockTime(23, minute: 59).isPM, isTrue);
        expect(ClockTime(11, minute: 59).isPM, isFalse);
        expect(ClockTime(0).isPM, isFalse);
      });

      test('period should return correct string', () {
        expect(ClockTime(8).period, equals('morning'));
        expect(ClockTime(14).period, equals('afternoon'));
        expect(ClockTime(19).period, equals('evening'));
        expect(ClockTime(23).period, equals('night'));
        expect(ClockTime(2).period, equals('night'));
      });
    });

    group('time calculations', () {
      test('minutesSinceMidnight should work correctly', () {
        expect(ClockTime(0).minutesSinceMidnight, equals(0));
        expect(ClockTime(1, minute: 30).minutesSinceMidnight, equals(90));
        expect(ClockTime(12).minutesSinceMidnight, equals(720));
        expect(ClockTime(23, minute: 59).minutesSinceMidnight, equals(1439));
      });

      test('secondsSinceMidnight should work correctly', () {
        expect(ClockTime(0).secondsSinceMidnight, equals(0));
        expect(
          ClockTime(0, minute: 1, second: 30).secondsSinceMidnight,
          equals(90),
        );
        expect(ClockTime(1).secondsSinceMidnight, equals(3600));
      });

      test('minutesUntilMidnight should work correctly', () {
        expect(ClockTime(0).minutesUntilMidnight, equals(1440));
        expect(ClockTime(23, minute: 30).minutesUntilMidnight, equals(30));
        expect(ClockTime(12).minutesUntilMidnight, equals(720));
      });
    });

    group('equality and hashCode', () {
      test('should be equal when all fields match', () {
        final time1 = ClockTime(14, minute: 30, second: 45);
        final time2 = ClockTime(14, minute: 30, second: 45);

        expect(time1, equals(time2));
        expect(time1.hashCode, equals(time2.hashCode));
      });

      test('should not be equal when fields differ', () {
        final time1 = ClockTime(14, minute: 30);
        final time2 = ClockTime(14, minute: 31);

        expect(time1, isNot(equals(time2)));
      });
    });

    group('toString', () {
      test('should format toString correctly', () {
        final time = ClockTime(
          14,
          minute: 30,
          second: 45,
          millisecond: 123,
          microsecond: 456,
        );
        final result = time.toString();

        expect(result, contains('14'));
        expect(result, contains('30'));
        expect(result, contains('45'));
      });
    });
  });
}

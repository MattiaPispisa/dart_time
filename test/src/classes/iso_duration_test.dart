import 'package:dart_time/dart_time.dart';
import 'package:test/test.dart';

void main() {
  group('ISODuration', () {
    group('constructor', () {
      test('should create ISODuration with all parameters', () {
        final duration = ISODuration(
          years: 1,
          months: 2,
          weeks: 3,
          days: 4,
          hours: 5,
          minutes: 6,
          seconds: 7,
        );

        expect(duration.years, equals(1));
        expect(duration.months, equals(2));
        expect(duration.weeks, equals(3));
        expect(duration.days, equals(4));
        expect(duration.hours, equals(5));
        expect(duration.minutes, equals(6));
        expect(duration.seconds, equals(7));
      });

      test('should create ISODuration with default values', () {
        final duration = ISODuration();

        expect(duration.years, equals(0));
        expect(duration.months, equals(0));
        expect(duration.weeks, equals(0));
        expect(duration.days, equals(0));
        expect(duration.hours, equals(0));
        expect(duration.minutes, equals(0));
        expect(duration.seconds, equals(0));
      });

      test('should create ISODuration with partial parameters', () {
        final duration = ISODuration(days: 5, hours: 3);

        expect(duration.years, equals(0));
        expect(duration.months, equals(0));
        expect(duration.weeks, equals(0));
        expect(duration.days, equals(5));
        expect(duration.hours, equals(3));
        expect(duration.minutes, equals(0));
        expect(duration.seconds, equals(0));
      });
    });

    group('ISODuration.parse', () {
      test('should parse basic period duration', () {
        final duration = ISODuration.parse('P1Y2M3D');

        expect(duration.years, equals(1));
        expect(duration.months, equals(2));
        expect(duration.weeks, equals(0));
        expect(duration.days, equals(3));
        expect(duration.hours, equals(0));
        expect(duration.minutes, equals(0));
        expect(duration.seconds, equals(0));
      });

      test('should parse basic time duration', () {
        final duration = ISODuration.parse('PT4H5M6S');

        expect(duration.years, equals(0));
        expect(duration.months, equals(0));
        expect(duration.weeks, equals(0));
        expect(duration.days, equals(0));
        expect(duration.hours, equals(4));
        expect(duration.minutes, equals(5));
        expect(duration.seconds, equals(6));
      });

      test('should parse combined period and time duration', () {
        final duration = ISODuration.parse('P1Y2M3DT4H5M6S');

        expect(duration.years, equals(1));
        expect(duration.months, equals(2));
        expect(duration.weeks, equals(0));
        expect(duration.days, equals(3));
        expect(duration.hours, equals(4));
        expect(duration.minutes, equals(5));
        expect(duration.seconds, equals(6));
      });

      test('should parse weeks duration', () {
        final duration = ISODuration.parse('P2W');

        expect(duration.years, equals(0));
        expect(duration.months, equals(0));
        expect(duration.weeks, equals(2));
        expect(duration.days, equals(0));
        expect(duration.hours, equals(0));
        expect(duration.minutes, equals(0));
        expect(duration.seconds, equals(0));
      });

      test('should parse zero duration', () {
        final duration = ISODuration.parse('P0D');

        expect(duration.years, equals(0));
        expect(duration.months, equals(0));
        expect(duration.weeks, equals(0));
        expect(duration.days, equals(0));
        expect(duration.hours, equals(0));
        expect(duration.minutes, equals(0));
        expect(duration.seconds, equals(0));
      });

      test('should parse minimal valid duration', () {
        final duration = ISODuration.parse('P');

        expect(duration.years, equals(0));
        expect(duration.months, equals(0));
        expect(duration.weeks, equals(0));
        expect(duration.days, equals(0));
        expect(duration.hours, equals(0));
        expect(duration.minutes, equals(0));
        expect(duration.seconds, equals(0));
      });

      test('should throw ArgumentError for invalid format', () {
        expect(() => ISODuration.parse('invalid'), throwsArgumentError);
        expect(() => ISODuration.parse('1Y2M3D'),
            throwsArgumentError); // Missing P
        expect(() => ISODuration.parse('P1Y2M3D4H5M6S'),
            throwsArgumentError); // Missing T
        expect(() => ISODuration.parse(''), throwsArgumentError);
      });
    });

    group('ISODuration.tryParse', () {
      test('should parse valid ISO string', () {
        final duration = ISODuration.tryParse('P1Y2M3D');

        expect(duration, isNotNull);
        expect(duration!.years, equals(1));
        expect(duration.months, equals(2));
        expect(duration.days, equals(3));
      });

      test('should return null for invalid ISO string', () {
        final duration = ISODuration.tryParse('invalid');

        expect(duration, isNull);
      });

      test('should return null for empty string', () {
        final duration = ISODuration.tryParse('');

        expect(duration, isNull);
      });
    });

    group('ISODuration.fromJson', () {
      test('should create ISODuration from JSON', () {
        final json = {
          'years': 1,
          'months': 2,
          'weeks': 3,
          'days': 4,
          'hours': 5,
          'minutes': 6,
          'seconds': 7,
        };
        final duration = ISODuration.fromJson(json);

        expect(duration.years, equals(1));
        expect(duration.months, equals(2));
        expect(duration.weeks, equals(3));
        expect(duration.days, equals(4));
        expect(duration.hours, equals(5));
        expect(duration.minutes, equals(6));
        expect(duration.seconds, equals(7));
      });
    });

    group('copyWith', () {
      test('should copy with new values', () {
        final original = ISODuration(years: 1, months: 2, days: 3);
        final copied = original.copyWith(years: 5, hours: 4);

        expect(copied.years, equals(5));
        expect(copied.months, equals(2));
        expect(copied.weeks, equals(0));
        expect(copied.days, equals(3));
        expect(copied.hours, equals(4));
        expect(copied.minutes, equals(0));
        expect(copied.seconds, equals(0));
      });

      test('should copy with no changes', () {
        final original = ISODuration(years: 1, months: 2, days: 3);
        final copied = original.copyWith();

        expect(copied, equals(original));
      });
    });

    group('toIso', () {
      test('should convert to ISO string with period only', () {
        final duration = ISODuration(years: 1, months: 2, days: 3);
        final isoString = duration.toIso();

        expect(isoString, equals('P1Y2M3D'));
      });

      test('should convert to ISO string with time only', () {
        final duration = ISODuration(hours: 4, minutes: 5, seconds: 6);
        final isoString = duration.toIso();

        expect(isoString, equals('PT4H5M6S'));
      });

      test('should convert to ISO string with period and time', () {
        final duration = ISODuration(
          years: 1,
          months: 2,
          days: 3,
          hours: 4,
          minutes: 5,
          seconds: 6,
        );
        final isoString = duration.toIso();

        expect(isoString, equals('P1Y2M3DT4H5M6S'));
      });

      test('should convert to ISO string with weeks', () {
        final duration = ISODuration(weeks: 2);
        final isoString = duration.toIso();

        expect(isoString, equals('P2W'));
      });

      test('should convert zero duration to P0D', () {
        final duration = ISODuration();
        final isoString = duration.toIso();

        expect(isoString, equals('P0D'));
      });

      test('should handle partial durations correctly', () {
        final duration1 = ISODuration(years: 1);
        final duration2 = ISODuration(hours: 2);
        final duration3 = ISODuration(days: 5, minutes: 30);

        expect(duration1.toIso(), equals('P1Y'));
        expect(duration2.toIso(), equals('PT2H'));
        expect(duration3.toIso(), equals('P5DT30M'));
      });
    });

    group('toDuration', () {
      test('should convert to Duration correctly', () {
        final isoDuration = ISODuration(
          weeks: 1,
          days: 2,
          hours: 3,
          minutes: 4,
          seconds: 5,
        );
        final duration = isoDuration.toDuration();

        expect(duration.inDays, equals(9)); // 1 week + 2 days = 9 days
        expect(duration.inHours % 24, equals(3));
        expect(duration.inMinutes % 60, equals(4));
        expect(duration.inSeconds % 60, equals(5));
      });

      test('should ignore years and months in conversion', () {
        final isoDuration = ISODuration(
          years: 1,
          months: 6,
          days: 10,
          hours: 5,
        );
        final duration = isoDuration.toDuration();

        // Years and months should be ignored, only days and hours counted
        expect(duration.inDays, equals(10));
        expect(duration.inHours % 24, equals(5));
      });

      test('should handle weeks correctly', () {
        final isoDuration = ISODuration(weeks: 3);
        final duration = isoDuration.toDuration();

        expect(duration.inDays, equals(21)); // 3 weeks = 21 days
      });
    });

    group('toJson', () {
      test('should convert ISODuration to JSON', () {
        final duration = ISODuration(
          years: 1,
          months: 2,
          weeks: 3,
          days: 4,
          hours: 5,
          minutes: 6,
          seconds: 7,
        );
        final json = duration.toJson();

        expect(json['years'], equals(1));
        expect(json['months'], equals(2));
        expect(json['weeks'], equals(3));
        expect(json['days'], equals(4));
        expect(json['hours'], equals(5));
        expect(json['minutes'], equals(6));
        expect(json['seconds'], equals(7));
      });
    });

    group('equality and hashCode', () {
      test('should be equal when all fields match', () {
        final duration1 = ISODuration(years: 1, months: 2, days: 3);
        final duration2 = ISODuration(years: 1, months: 2, days: 3);

        expect(duration1, equals(duration2));
        expect(duration1.hashCode, equals(duration2.hashCode));
      });

      test('should not be equal when fields differ', () {
        final duration1 = ISODuration(years: 1, months: 2, days: 3);
        final duration2 = ISODuration(years: 1, months: 2, days: 4);

        expect(duration1, isNot(equals(duration2)));
      });

      test('should handle default values in equality', () {
        final duration1 = ISODuration(years: 1);
        final duration2 = ISODuration(
          years: 1,
          months: 0,
          weeks: 0,
          days: 0,
          hours: 0,
          minutes: 0,
          seconds: 0,
        );

        expect(duration1, equals(duration2));
      });
    });

    group('toString', () {
      test('should format toString correctly', () {
        final duration = ISODuration(
          years: 1,
          months: 2,
          weeks: 3,
          days: 4,
          hours: 5,
          minutes: 6,
          seconds: 7,
        );
        final result = duration.toString();

        expect(result, contains('years: 1'));
        expect(result, contains('months: 2'));
        expect(result, contains('weeks: 3'));
        expect(result, contains('days: 4'));
        expect(result, contains('hours: 5'));
        expect(result, contains('minutes: 6'));
        expect(result, contains('seconds:7')); // Note: no space in original
      });
    });

    group('edge cases and complex parsing', () {
      test('should parse duration with only some components', () {
        expect(ISODuration.parse('P1Y').years, equals(1));
        expect(ISODuration.parse('P2M').months, equals(2));
        expect(ISODuration.parse('P3W').weeks, equals(3));
        expect(ISODuration.parse('P4D').days, equals(4));
        expect(ISODuration.parse('PT5H').hours, equals(5));
        expect(ISODuration.parse('PT6M').minutes, equals(6));
        expect(ISODuration.parse('PT7S').seconds, equals(7));
      });

      test('should handle mixed partial components', () {
        final duration = ISODuration.parse('P1Y3DT2H');

        expect(duration.years, equals(1));
        expect(duration.months, equals(0));
        expect(duration.weeks, equals(0));
        expect(duration.days, equals(3));
        expect(duration.hours, equals(2));
        expect(duration.minutes, equals(0));
        expect(duration.seconds, equals(0));
      });

      test('should roundtrip parse and toIso correctly', () {
        const originalIso = 'P1Y2M3DT4H5M6S';
        final duration = ISODuration.parse(originalIso);
        final regeneratedIso = duration.toIso();

        expect(regeneratedIso, equals(originalIso));
      });

      test('should roundtrip with weeks', () {
        const originalIso = 'P2W';
        final duration = ISODuration.parse(originalIso);
        final regeneratedIso = duration.toIso();

        expect(regeneratedIso, equals(originalIso));
      });
    });
  });
}

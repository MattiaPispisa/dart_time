import 'package:dart_time/dart_time.dart';
import 'package:test/test.dart';

void main() {
  group('DurationHelper', () {
    group('parseISO', () {
      test('should parse basic ISO duration', () {
        final duration = DurationHelper.parseISO('P1DT2H3M4S');

        expect(duration.inDays, equals(1));
        expect(duration.inHours % 24, equals(2));
        expect(duration.inMinutes % 60, equals(3));
        expect(duration.inSeconds % 60, equals(4));
      });

      test('should parse duration with weeks', () {
        final duration = DurationHelper.parseISO('P2W');

        expect(duration.inDays, equals(14)); // 2 weeks = 14 days
      });

      test('should parse duration with weeks and days', () {
        final duration = DurationHelper.parseISO('P1W3D');

        expect(duration.inDays, equals(10)); // 1 week + 3 days = 10 days
      });

      test('should ignore years and months', () {
        final duration = DurationHelper.parseISO('P1Y2M3DT4H');

        expect(duration.inDays, equals(3)); // Years and months ignored
        expect(duration.inHours % 24, equals(4));
      });

      test('should throw ArgumentError for invalid format', () {
        expect(() => DurationHelper.parseISO('invalid'), throwsArgumentError);
      });
    });

    group('toIsoDuration', () {
      test('should convert Duration to ISODuration', () {
        const duration = Duration(days: 5, hours: 3, minutes: 30, seconds: 45);
        final isoDuration = duration.toIsoDuration();

        expect(isoDuration.days, equals(5));
        expect(isoDuration.hours, equals(3));
        expect(isoDuration.minutes, equals(30));
        expect(isoDuration.seconds, equals(45));
        expect(isoDuration.weeks, equals(0));
        expect(isoDuration.years, equals(0));
        expect(isoDuration.months, equals(0));
      });

      test('should handle large durations', () {
        const duration = Duration(days: 100, hours: 25, minutes: 70);
        final isoDuration = duration.toIsoDuration();

        expect(isoDuration.days, equals(101));
        expect(isoDuration.hours, equals(2));
        expect(isoDuration.minutes, equals(10));
      });
    });

    group('toIsoString', () {
      test('should convert Duration to ISO string', () {
        const duration = Duration(days: 5, hours: 3, minutes: 30);
        final isoString = duration.toIsoString();

        expect(isoString, equals('P5DT3H30M'));
      });

      test('should handle zero duration', () {
        const duration = Duration.zero;
        final isoString = duration.toIsoString();

        expect(isoString, equals('P0D'));
      });
    });

    group('validation methods', () {
      test('isZero should work correctly', () {
        expect(Duration.zero.isZero, isTrue);
        expect(const Duration(seconds: 1).isZero, isFalse);
      });

      test('isPositive should work correctly', () {
        expect(const Duration(seconds: 1).isPositive, isTrue);
        expect(Duration.zero.isPositive, isFalse);
        expect(const Duration(seconds: -1).isPositive, isFalse);
      });

      test('isNegative should work correctly', () {
        expect(const Duration(seconds: -1).isNegative, isTrue);
        expect(Duration.zero.isNegative, isFalse);
        expect(const Duration(seconds: 1).isNegative, isFalse);
      });

      test('absDuration should work correctly', () {
        const positiveDuration = Duration(hours: 5);
        const negativeDuration = Duration(hours: -5);

        expect(positiveDuration.absDuration, equals(const Duration(hours: 5)));
        expect(negativeDuration.absDuration, equals(const Duration(hours: 5)));
        expect(Duration.zero.absDuration, equals(Duration.zero));
      });
    });

    group('additional units', () {
      test('inWeeks should work correctly', () {
        const duration1 = Duration(days: 7);
        const duration2 = Duration(days: 10);
        const duration3 = Duration(days: 14);

        expect(duration1.inWeeks, equals(1.0));
        expect(duration2.inWeeks, closeTo(1.4285714285714286, 0.0001));
        expect(duration3.inWeeks, equals(2.0));
      });

      test('inFractionalHours should work correctly', () {
        const duration1 = Duration(hours: 1, minutes: 30);
        const duration2 = Duration(hours: 2, minutes: 15);
        const duration3 = Duration(minutes: 90);

        expect(duration1.inFractionalHours, equals(1.5));
        expect(duration2.inFractionalHours, equals(2.25));
        expect(duration3.inFractionalHours, equals(1.5));
      });

      test('inFractionalMinutes should work correctly', () {
        const duration1 = Duration(minutes: 1, seconds: 30);
        const duration2 = Duration(minutes: 2, seconds: 45);
        const duration3 = Duration(seconds: 90);

        expect(duration1.inFractionalMinutes, equals(1.5));
        expect(duration2.inFractionalMinutes, equals(2.75));
        expect(duration3.inFractionalMinutes, equals(1.5));
      });
    });

    group('formatting methods', () {
      test('hhmmss should format correctly', () {
        const duration1 = Duration(hours: 2, minutes: 30, seconds: 45);
        const duration2 = Duration(hours: 25, minutes: 5);
        const duration3 = Duration(hours: -2, minutes: -30);

        expect(duration1.hhmmss, equals('02:30:45'));
        expect(duration2.hhmmss, equals('25:05:00'));
        expect(duration3.hhmmss, equals('-02:30:00'));
      });

      test('hhmmssmmm should format correctly', () {
        const duration =
            Duration(hours: 1, minutes: 30, seconds: 45, milliseconds: 123);

        expect(duration.hhmmssmmm, equals('01:30:45.123'));
      });

      test('hhmmss should handle zero duration', () {
        const duration = Duration.zero;

        expect(duration.hhmmss, equals('00:00:00'));
      });

      test('hhmmss should handle large durations', () {
        const duration = Duration(hours: 100, minutes: 30);

        expect(duration.hhmmss, equals('100:30:00'));
      });
    });

    group('rounding methods', () {
      test('roundToMinute should work correctly', () {
        const duration1 = Duration(minutes: 2, seconds: 35);
        const duration2 = Duration(minutes: 2, seconds: 25);
        const duration3 = Duration(minutes: 2, seconds: 30);

        expect(duration1.roundToMinute(), equals(const Duration(minutes: 3)));
        expect(duration2.roundToMinute(), equals(const Duration(minutes: 2)));
        expect(duration3.roundToMinute(), equals(const Duration(minutes: 3)));
      });

      test('roundToHour should work correctly', () {
        const duration1 = Duration(hours: 2, minutes: 35);
        const duration2 = Duration(hours: 2, minutes: 25);
        const duration3 = Duration(hours: 2, minutes: 30);

        expect(duration1.roundToHour(), equals(const Duration(hours: 3)));
        expect(duration2.roundToHour(), equals(const Duration(hours: 2)));
        expect(duration3.roundToHour(), equals(const Duration(hours: 3)));
      });

      test('roundToDay should work correctly', () {
        const duration1 = Duration(days: 2, hours: 15);
        const duration2 = Duration(days: 2, hours: 10);
        const duration3 = Duration(days: 2, hours: 12);

        expect(duration1.roundToDay(), equals(const Duration(days: 3)));
        expect(duration2.roundToDay(), equals(const Duration(days: 2)));
        expect(duration3.roundToDay(), equals(const Duration(days: 3)));
      });
    });

    group('comparison methods', () {
      test('isLongerThan should work correctly', () {
        const duration1 = Duration(hours: 2);
        const duration2 = Duration(hours: 1);

        expect(duration1.isLongerThan(duration2), isTrue);
        expect(duration2.isLongerThan(duration1), isFalse);
        expect(duration1.isLongerThan(duration1), isFalse);
      });

      test('isShorterThan should work correctly', () {
        const duration1 = Duration(hours: 1);
        const duration2 = Duration(hours: 2);

        expect(duration1.isShorterThan(duration2), isTrue);
        expect(duration2.isShorterThan(duration1), isFalse);
        expect(duration1.isShorterThan(duration1), isFalse);
      });

      test('max should work correctly', () {
        const duration1 = Duration(hours: 1);
        const duration2 = Duration(hours: 2);

        expect(duration1.max(duration2), equals(duration2));
        expect(duration2.max(duration1), equals(duration2));
        expect(duration1.max(duration1), equals(duration1));
      });

      test('min should work correctly', () {
        const duration1 = Duration(hours: 1);
        const duration2 = Duration(hours: 2);

        expect(duration1.min(duration2), equals(duration1));
        expect(duration2.min(duration1), equals(duration1));
        expect(duration1.min(duration1), equals(duration1));
      });
    });
  });

  group('IntDurationHelper', () {
    test('days should work correctly', () {
      expect(5.days, equals(const Duration(days: 5)));
      expect(0.days, equals(Duration.zero));
      expect((-1).days, equals(const Duration(days: -1)));
    });

    test('hours should work correctly', () {
      expect(3.hours, equals(const Duration(hours: 3)));
      expect(24.hours, equals(const Duration(days: 1)));
    });

    test('minutes should work correctly', () {
      expect(30.minutes, equals(const Duration(minutes: 30)));
      expect(60.minutes, equals(const Duration(hours: 1)));
    });

    test('seconds should work correctly', () {
      expect(45.seconds, equals(const Duration(seconds: 45)));
      expect(60.seconds, equals(const Duration(minutes: 1)));
    });

    test('milliseconds should work correctly', () {
      expect(500.milliseconds, equals(const Duration(milliseconds: 500)));
      expect(1000.milliseconds, equals(const Duration(seconds: 1)));
    });

    test('microseconds should work correctly', () {
      expect(500.microseconds, equals(const Duration(microseconds: 500)));
      expect(1000.microseconds, equals(const Duration(milliseconds: 1)));
    });

    test('weeks should work correctly', () {
      expect(1.weeks, equals(const Duration(days: 7)));
      expect(2.weeks, equals(const Duration(days: 14)));
      expect(0.weeks, equals(Duration.zero));
    });
  });

  group('DoubleDurationHelper', () {
    test('fractionalHours should work correctly', () {
      expect(
          1.5.fractionalHours, equals(const Duration(hours: 1, minutes: 30)));
      expect(
          2.25.fractionalHours, equals(const Duration(hours: 2, minutes: 15)));
      expect(0.5.fractionalHours, equals(const Duration(minutes: 30)));
    });

    test('fractionalMinutes should work correctly', () {
      expect(1.5.fractionalMinutes,
          equals(const Duration(minutes: 1, seconds: 30)));
      expect(2.25.fractionalMinutes,
          equals(const Duration(minutes: 2, seconds: 15)));
      expect(0.5.fractionalMinutes, equals(const Duration(seconds: 30)));
    });

    test('fractionalSeconds should work correctly', () {
      final duration1 = 1.5.fractionalSeconds;
      final duration2 = 2.25.fractionalSeconds;

      expect(duration1.inSeconds, equals(1));
      expect(duration1.inMilliseconds % 1000, equals(500));
      expect(duration2.inSeconds, equals(2));
      expect(duration2.inMilliseconds % 1000, equals(250));
    });

    test('fractionalDays should work correctly', () {
      expect(1.5.fractionalDays, equals(const Duration(days: 1, hours: 12)));
      expect(0.5.fractionalDays, equals(const Duration(hours: 12)));
      expect(2.25.fractionalDays, equals(const Duration(days: 2, hours: 6)));
    });

    test('should handle edge cases', () {
      expect(0.0.fractionalHours, equals(Duration.zero));
      expect((-1.0).fractionalHours, equals(const Duration(hours: -1)));
    });

    test('should handle precision correctly', () {
      // 1.333333 is not exactly 1 + 1/3, so it gives 19 minutes instead of 20
      final duration = 1.333333.fractionalHours;
      expect(duration.inHours, equals(1));
      expect(duration.inMinutes % 60, equals(19));

      // For exact results, use precise fractions
      final preciseDuration = (1 + 1 / 3).fractionalHours;
      expect(preciseDuration.inHours, equals(1));
      expect(preciseDuration.inMinutes % 60, equals(20));
    });
  });

  group('integration tests', () {
    test('should work together with different extensions', () {
      final duration = 2.days + 3.hours + 30.minutes;

      expect(duration.inDays, equals(2));
      expect(duration.inHours % 24, equals(3));
      expect(duration.inMinutes % 60, equals(30));
      expect(duration.hhmmss, equals('51:30:00')); // 2*24 + 3 = 51 hours
    });

    test('should handle complex fractional calculations', () {
      final duration = 1.5.fractionalDays + 2.25.fractionalHours + 30.minutes;

      expect(duration.inDays, equals(1));
      expect(duration.inHours % 24,
          equals(14)); // 12 + 2.25 = 14.25, truncated to 14
      expect(duration.inMinutes % 60,
          equals(45)); // .25 hours + 30 minutes = 45 minutes
    });

    test('should roundtrip ISO conversions correctly', () {
      const originalDuration =
          Duration(days: 5, hours: 3, minutes: 30, seconds: 45);
      final isoString = originalDuration.toIsoString();
      final parsedDuration = DurationHelper.parseISO(isoString);

      expect(parsedDuration, equals(originalDuration));
    });
  });
}

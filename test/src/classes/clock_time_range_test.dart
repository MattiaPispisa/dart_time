import 'package:dart_time/dart_time.dart';
import 'package:test/test.dart';

void main() {
  group('ClockTimeRange', () {
    final startTime = ClockTime(9, minute: 0);
    final endTime = ClockTime(17, minute: 30);

    group('constructor', () {
      test('should create valid ClockTimeRange', () {
        final range = ClockTimeRange(start: startTime, end: endTime);

        expect(range.start, equals(startTime));
        expect(range.end, equals(endTime));
      });

      test('should allow start time after end time (overnight range)', () {
        final range = ClockTimeRange(
          start: ClockTime(22),
          end: ClockTime(6),
        );

        expect(range.start.hour, equals(22));
        expect(range.end.hour, equals(6));
      });
    });

    group('effectiveRange', () {
      test('should return same day range for regular working hours', () {
        final range = ClockTimeRange(
          start: ClockTime(9),
          end: ClockTime(17),
        );
        final date = DateTime(2023, 6, 15);

        final effectiveRange = range.effectiveRange(date);

        expect(effectiveRange.start, equals(DateTime(2023, 6, 15, 9)));
        expect(effectiveRange.end, equals(DateTime(2023, 6, 15, 17)));
      });

      test('should return overnight range for night shifts', () {
        final range = ClockTimeRange(
          start: ClockTime(22),
          end: ClockTime(6),
        );
        final date = DateTime(2023, 6, 15);

        final effectiveRange = range.effectiveRange(date);

        expect(effectiveRange.start, equals(DateTime(2023, 6, 15, 22)));
        expect(effectiveRange.end, equals(DateTime(2023, 6, 16, 6)));
      });

      test('should handle edge case: midnight start and end', () {
        final range = ClockTimeRange(
          start: ClockTime(0),
          end: ClockTime(23, minute: 59),
        );
        final date = DateTime(2023, 6, 15);

        final effectiveRange = range.effectiveRange(date);

        expect(effectiveRange.start, equals(DateTime(2023, 6, 15)));
        expect(effectiveRange.end, equals(DateTime(2023, 6, 15, 23, 59)));
      });

      test('should handle equal start and end times', () {
        final range = ClockTimeRange(
          start: ClockTime(12),
          end: ClockTime(12),
        );
        final date = DateTime(2023, 6, 15);

        final effectiveRange = range.effectiveRange(date);

        expect(effectiveRange.start, equals(DateTime(2023, 6, 15, 12)));
        expect(effectiveRange.end, equals(DateTime(2023, 6, 15, 12)));
      });
    });

    group('includes', () {
      test('should include DateTime within same-day range', () {
        final range = ClockTimeRange(
          start: ClockTime(9),
          end: ClockTime(17),
        );
        final date = DateTime(2023, 6, 15, 12, 30);

        expect(range.includes(date), isTrue);
      });

      test('should not include DateTime outside same-day range', () {
        final range = ClockTimeRange(
          start: ClockTime(9),
          end: ClockTime(17),
        );
        final earlyDate = DateTime(2023, 6, 15, 7, 30);
        final lateDate = DateTime(2023, 6, 15, 19, 30);

        expect(range.includes(earlyDate), isFalse);
        expect(range.includes(lateDate), isFalse);
      });

      test('should include start time', () {
        final range = ClockTimeRange(
          start: ClockTime(9),
          end: ClockTime(17),
        );
        final date = DateTime(2023, 6, 15, 9);

        expect(range.includes(date), isTrue);
      });

      test('should include end time', () {
        final range = ClockTimeRange(
          start: ClockTime(9),
          end: ClockTime(17),
        );
        final date = DateTime(2023, 6, 15, 17);

        expect(range.includes(date), isTrue);
      });

      test('should handle overnight range correctly', () {
        final range = ClockTimeRange(
          start: ClockTime(22),
          end: ClockTime(6),
        );
        final nightDate = DateTime(2023, 6, 15, 23, 30);
        final earlyMorningDate = DateTime(2023, 6, 15, 4, 30);
        final dayDate = DateTime(2023, 6, 15, 12, 30);

        expect(range.includes(nightDate), isTrue);
        expect(range.includes(earlyMorningDate), isTrue);
        expect(range.includes(dayDate), isFalse);
      });

      test('should handle edge cases for overnight range', () {
        final range = ClockTimeRange(
          start: ClockTime(22),
          end: ClockTime(6),
        );
        final startTimeDate = DateTime(2023, 6, 15, 22);
        final endTimeDate = DateTime(2023, 6, 15, 6);
        final beforeStartDate = DateTime(2023, 6, 15, 21, 59);
        final afterEndDate = DateTime(2023, 6, 15, 6, 1);

        expect(range.includes(startTimeDate), isTrue);
        expect(range.includes(endTimeDate), isTrue);
        expect(range.includes(beforeStartDate), isFalse);
        expect(range.includes(afterEndDate), isFalse);
      });

      test('should handle midnight correctly in overnight range', () {
        final range = ClockTimeRange(
          start: ClockTime(22),
          end: ClockTime(6),
        );
        final midnightDate = DateTime(2023, 6, 15);

        expect(range.includes(midnightDate), isTrue);
      });
    });

    group('toString', () {
      test('should format toString correctly', () {
        final range = ClockTimeRange(start: startTime, end: endTime);
        final result = range.toString();

        expect(result, contains('start:'));
        expect(result, contains('end:'));
        expect(result, contains(startTime.toString()));
        expect(result, contains(endTime.toString()));
      });
    });
    group('equality and hashCode', () {
      test('should be equal when start and end match', () {
        final range1 = ClockTimeRange(start: startTime, end: endTime);
        final range2 = ClockTimeRange(start: startTime, end: endTime);

        expect(range1, equals(range2));
        expect(range1.hashCode, equals(range2.hashCode));
      });

      test('should not be equal when start differs', () {
        final range1 = ClockTimeRange(start: startTime, end: endTime);
        final range2 = ClockTimeRange(start: ClockTime(10), end: endTime);

        expect(range1, isNot(equals(range2)));
      });

      test('should not be equal when end differs', () {
        final range1 = ClockTimeRange(start: startTime, end: endTime);
        final range2 = ClockTimeRange(start: startTime, end: ClockTime(18));

        expect(range1, isNot(equals(range2)));
      });
    });

    group('edge cases', () {
      test('should handle same start and end time', () {
        final range = ClockTimeRange(
          start: ClockTime(12),
          end: ClockTime(12),
        );
        final date = DateTime(2023, 6, 15, 12);

        expect(range.includes(date), isTrue);
      });

      test('should handle minute precision', () {
        final range = ClockTimeRange(
          start: ClockTime(9, minute: 30),
          end: ClockTime(17, minute: 45),
        );
        final beforeStart = DateTime(2023, 6, 15, 9, 29);
        final atStart = DateTime(2023, 6, 15, 9, 30);
        final afterEnd = DateTime(2023, 6, 15, 17, 46);
        final atEnd = DateTime(2023, 6, 15, 17, 45);

        expect(range.includes(beforeStart), isFalse);
        expect(range.includes(atStart), isTrue);
        expect(range.includes(afterEnd), isFalse);
        expect(range.includes(atEnd), isTrue);
      });

      test('should handle overnight range crossing multiple days logic', () {
        final range = ClockTimeRange(
          start: ClockTime(23),
          end: ClockTime(1),
        );

        // Test date where the time is after start (23:00)
        final lateNightDate = DateTime(2023, 6, 15, 23, 30);
        expect(range.includes(lateNightDate), isTrue);

        // Test date where the time is before end (01:00)
        final earlyMorningDate = DateTime(2023, 6, 15, 0, 30);
        expect(range.includes(earlyMorningDate), isTrue);

        // Test date where the time is between end and start
        final dayDate = DateTime(2023, 6, 15, 12);
        expect(range.includes(dayDate), isFalse);
      });
    });
  });
}

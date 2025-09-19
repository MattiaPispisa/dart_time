import 'package:dart_time/dart_time.dart';
import 'package:test/test.dart';

void main() {
  group('DartDateRange', () {
    final start = DateTime(2023, 6, 1, 10);
    final end = DateTime(2023, 6, 5, 15, 30);

    group('constructor', () {
      test('should create valid DartDateRange', () {
        final range = DartDateRange(start: start, end: end);

        expect(range.start, equals(start));
        expect(range.end, equals(end));
      });

      test('should throw ArgumentError when start is after end', () {
        expect(
          () => DartDateRange(start: end, end: start),
          throwsArgumentError,
        );
      });

      test('should allow start equal to end', () {
        final range = DartDateRange(start: start, end: start);

        expect(range.start, equals(start));
        expect(range.end, equals(start));
      });
    });

    group('DartDateRange.day', () {
      test('should create range for whole day', () {
        final date = DateTime(2023, 6, 15, 14, 30);
        final range = DartDateRange.day(date);

        expect(range.start, equals(date.startOfDay));
        expect(range.end, equals(date.endOfDay));
      });
    });

    group('DartDateRange.fromJson', () {
      test('should create DartDateRange from JSON', () {
        final json = {
          'start': '2023-06-01T10:00:00.000',
          'end': '2023-06-05T15:30:00.000',
        };
        final range = DartDateRange.fromJson(json);

        expect(range.start, equals(DateTime.parse(json['start']!)));
        expect(range.end, equals(DateTime.parse(json['end']!)));
      });
    });

    group('copyWith', () {
      test('should copy with new start', () {
        final range = DartDateRange(start: start, end: end);
        final newStart = DateTime(2023, 5, 28);
        final copied = range.copyWith(start: newStart);

        expect(copied.start, equals(newStart));
        expect(copied.end, equals(end));
      });

      test('should copy with new end', () {
        final range = DartDateRange(start: start, end: end);
        final newEnd = DateTime(2023, 6, 10);
        final copied = range.copyWith(end: newEnd);

        expect(copied.start, equals(start));
        expect(copied.end, equals(newEnd));
      });

      test('should copy with no changes', () {
        final range = DartDateRange(start: start, end: end);
        final copied = range.copyWith();

        expect(copied, equals(range));
      });
    });

    group('includes', () {
      test('should include date within range', () {
        final range = DartDateRange(start: start, end: end);
        final dateInRange = DateTime(2023, 6, 3, 12);

        expect(range.includes(dateInRange), isTrue);
      });

      test('should include start date', () {
        final range = DartDateRange(start: start, end: end);

        expect(range.includes(start), isTrue);
      });

      test('should include end date', () {
        final range = DartDateRange(start: start, end: end);

        expect(range.includes(end), isTrue);
      });

      test('should not include date before range', () {
        final range = DartDateRange(start: start, end: end);
        final dateBefore = DateTime(2023, 5, 30);

        expect(range.includes(dateBefore), isFalse);
      });

      test('should not include date after range', () {
        final range = DartDateRange(start: start, end: end);
        final dateAfter = DateTime(2023, 6, 10);

        expect(range.includes(dateAfter), isFalse);
      });
    });

    group('cross', () {
      test('should detect cross when ranges overlap at start', () {
        final range1 = DartDateRange(
          start: DateTime(2023, 6),
          end: DateTime(2023, 6, 5),
        );
        final range2 = DartDateRange(
          start: DateTime(2023, 6, 3),
          end: DateTime(2023, 6, 8),
        );

        expect(range1.cross(range2), isTrue);
        expect(range2.cross(range1), isTrue);
      });

      test('should detect cross when ranges overlap at end', () {
        final range1 = DartDateRange(
          start: DateTime(2023, 6, 5),
          end: DateTime(2023, 6, 10),
        );
        final range2 = DartDateRange(
          start: DateTime(2023, 6),
          end: DateTime(2023, 6, 7),
        );

        expect(range1.cross(range2), isTrue);
        expect(range2.cross(range1), isTrue);
      });

      test('should not detect cross when ranges do not overlap', () {
        final range1 = DartDateRange(
          start: DateTime(2023, 6),
          end: DateTime(2023, 6, 5),
        );
        final range2 = DartDateRange(
          start: DateTime(2023, 6, 10),
          end: DateTime(2023, 6, 15),
        );

        expect(range1.cross(range2), isFalse);
        expect(range2.cross(range1), isFalse);
      });

      test('should detect cross when ranges are identical', () {
        final range1 = DartDateRange(start: start, end: end);
        final range2 = DartDateRange(start: start, end: end);

        expect(range1.cross(range2), isTrue);
      });
    });

    group('contains', () {
      test('should contain smaller range within', () {
        final range1 = DartDateRange(
          start: DateTime(2023, 6),
          end: DateTime(2023, 6, 10),
        );
        final range2 = DartDateRange(
          start: DateTime(2023, 6, 3),
          end: DateTime(2023, 6, 7),
        );

        expect(range1.contains(range2), isTrue);
        expect(range2.contains(range1), isFalse);
      });

      test('should not contain overlapping range', () {
        final range1 = DartDateRange(
          start: DateTime(2023, 6),
          end: DateTime(2023, 6, 5),
        );
        final range2 = DartDateRange(
          start: DateTime(2023, 6, 3),
          end: DateTime(2023, 6, 8),
        );

        expect(range1.contains(range2), isFalse);
        expect(range2.contains(range1), isFalse);
      });

      test('should contain identical range', () {
        final range1 = DartDateRange(start: start, end: end);
        final range2 = DartDateRange(start: start, end: end);

        expect(range1.contains(range2), isTrue);
      });

      test('should not contain non-overlapping range', () {
        final range1 = DartDateRange(
          start: DateTime(2023, 6),
          end: DateTime(2023, 6, 5),
        );
        final range2 = DartDateRange(
          start: DateTime(2023, 6, 10),
          end: DateTime(2023, 6, 15),
        );

        expect(range1.contains(range2), isFalse);
      });
    });

    group('duration', () {
      test('should calculate correct duration', () {
        final range = DartDateRange(start: start, end: end);
        final expectedDuration = end.difference(start);

        expect(range.duration, equals(expectedDuration));
      });

      test('should handle zero duration', () {
        final range = DartDateRange(start: start, end: start);

        expect(range.duration, equals(Duration.zero));
      });
    });

    group('step', () {
      test('should generate correct steps', () {
        final range = DartDateRange(
          start: DateTime(2023, 6),
          end: DateTime(2023, 6, 5),
        );
        final steps = range.step(const Duration(days: 2)).toList();

        expect(steps.length, equals(3));
        expect(steps[0], equals(DateTime(2023, 6)));
        expect(steps[1], equals(DateTime(2023, 6, 3)));
        expect(steps[2], equals(DateTime(2023, 6, 5)));
      });

      test('should handle step larger than range', () {
        final range = DartDateRange(
          start: DateTime(2023, 6),
          end: DateTime(2023, 6, 2),
        );
        final steps = range.step(const Duration(days: 5)).toList();

        expect(steps.length, equals(1));
        expect(steps[0], equals(DateTime(2023, 6)));
      });

      test('should throw ArgumentError for zero step', () {
        final range = DartDateRange(start: start, end: end);

        expect(() => range.step(Duration.zero), throwsArgumentError);
      });

      test('should throw ArgumentError for negative step', () {
        final range = DartDateRange(start: start, end: end);

        expect(() => range.step(const Duration(days: -1)), throwsArgumentError);
      });

      test('should not exceed end date', () {
        final range = DartDateRange(
          start: DateTime(2023, 6),
          end: DateTime(2023, 6, 3, 12),
        );
        final steps = range.step(const Duration(days: 1)).toList();

        expect(steps.length, equals(3));
        expect(
            steps.last.isBefore(range.end) ||
                steps.last.isAtSameMomentAs(range.end),
            isTrue);
      });
    });

    group('dates', () {
      test('should generate all dates in range', () {
        final range = DartDateRange(
          start: DateTime(2023, 6),
          end: DateTime(2023, 6, 3),
        );
        final dates = range.dates.toList();

        expect(dates.length, equals(3));
        expect(dates[0], equals(DateTime(2023, 6)));
        expect(dates[1], equals(DateTime(2023, 6, 2)));
        expect(dates[2], equals(DateTime(2023, 6, 3)));
      });

      test('should handle single day range', () {
        final range = DartDateRange(
          start: DateTime(2023, 6),
          end: DateTime(2023, 6),
        );
        final dates = range.dates.toList();

        expect(dates.length, equals(1));
        expect(dates[0], equals(DateTime(2023, 6)));
      });
    });

    group('isMultiDay', () {
      test('should return true for multi-day range', () {
        final range = DartDateRange(
          start: DateTime(2023, 6),
          end: DateTime(2023, 6, 5),
        );

        expect(range.isMultiDay, isTrue);
      });

      test('should return false for same day range', () {
        final range = DartDateRange(
          start: DateTime(2023, 6, 1, 10),
          end: DateTime(2023, 6, 1, 15),
        );

        expect(range.isMultiDay, isFalse);
      });
    });

    group('isSingleDay', () {
      test('should return false for multi-day range', () {
        final range = DartDateRange(
          start: DateTime(2023, 6),
          end: DateTime(2023, 6, 5),
        );

        expect(range.isSingleDay, isFalse);
      });

      test('should return true for same day range', () {
        final range = DartDateRange(
          start: DateTime(2023, 6, 1, 10),
          end: DateTime(2023, 6, 1, 15),
        );

        expect(range.isSingleDay, isTrue);
      });
    });

    group('extend', () {
      test('should extend range with before duration', () {
        final range = DartDateRange(start: start, end: end);
        final extended = range.extend(before: const Duration(days: 2));

        expect(extended.start, equals(start.subtract(const Duration(days: 2))));
        expect(extended.end, equals(end));
      });

      test('should extend range with after duration', () {
        final range = DartDateRange(start: start, end: end);
        final extended = range.extend(after: const Duration(days: 3));

        expect(extended.start, equals(start));
        expect(extended.end, equals(end.add(const Duration(days: 3))));
      });

      test('should extend range with both durations', () {
        final range = DartDateRange(start: start, end: end);
        final extended = range.extend(
          before: const Duration(days: 1),
          after: const Duration(days: 2),
        );

        expect(extended.start, equals(start.subtract(const Duration(days: 1))));
        expect(extended.end, equals(end.add(const Duration(days: 2))));
      });

      test('should handle no extension', () {
        final range = DartDateRange(start: start, end: end);
        final extended = range.extend();

        expect(extended, equals(range));
      });
    });

    group('toJson', () {
      test('should convert DartDateRange to JSON', () {
        final range = DartDateRange(start: start, end: end);
        final json = range.toJson();

        expect(json['start'], equals(start.toIso8601String()));
        expect(json['end'], equals(end.toIso8601String()));
      });
    });

    group('equality and hashCode', () {
      test('should be equal when start and end match', () {
        final range1 = DartDateRange(start: start, end: end);
        final range2 = DartDateRange(start: start, end: end);

        expect(range1, equals(range2));
        expect(range1.hashCode, equals(range2.hashCode));
      });

      test('should not be equal when start differs', () {
        final range1 = DartDateRange(start: start, end: end);
        final range2 =
            DartDateRange(start: start.add(const Duration(days: 1)), end: end);

        expect(range1, isNot(equals(range2)));
      });

      test('should not be equal when end differs', () {
        final range1 = DartDateRange(start: start, end: end);
        final range2 =
            DartDateRange(start: start, end: end.add(const Duration(days: 1)));

        expect(range1, isNot(equals(range2)));
      });
    });

    group('toString', () {
      test('should format toString correctly', () {
        final range = DartDateRange(start: start, end: end);
        final result = range.toString();

        expect(result, contains('start:'));
        expect(result, contains('end:'));
        expect(result, contains(start.toIso8601String()));
        expect(result, contains(end.toIso8601String()));
      });
    });
  });
}

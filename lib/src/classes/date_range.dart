import 'package:dart_time/dart_time.dart';
import 'package:meta/meta.dart';

/// [DartDateRange] represents a range of [DateTime]s.
@immutable
class DartDateRange {
  /// Creates a new [DartDateRange] instance.
  ///
  /// If [start] is after [end], an [ArgumentError] is thrown.
  ///
  /// Example:
  /// ```dart
  /// // A week range
  /// final week = DartDateRange(
  ///   start: DateTime(2023, 6, 1),
  ///   end: DateTime(2023, 6, 7),
  /// );
  ///
  /// // A quarter range
  /// final q2 = DartDateRange(
  ///   start: DateTime(2023, 4, 1),
  ///   end: DateTime(2023, 6, 30),
  /// );
  /// ```
  factory DartDateRange({
    required DateTime start,
    required DateTime end,
  }) {
    if (start.isAfter(end)) {
      throw _DartDateRangeError.startAfterEndError(start, end);
    }

    return DartDateRange._(start: start, end: end);
  }

  /// create a new [DartDateRange] instance for [date]
  /// (`startOfDay` to `endOfDay`)
  ///
  /// Example:
  /// ```dart
  /// final today = DartDateRange.day(DateTime(2023, 6, 15));
  /// // From 2023-06-15 00:00:00.000 to 2023-06-15 23:59:59.999
  ///
  /// final someDay = DartDateRange.day(DateTime.now());
  /// // Today from midnight to end of day
  /// ```
  factory DartDateRange.day(DateTime date) {
    return DartDateRange(
      start: date.startOfDay,
      end: date.endOfDay,
    );
  }

  /// create a new [DartDateRange] instance for today
  /// (`startOfDay` to `endOfDay`)
  ///
  /// This function internally use [DateTime.now] hence impure.
  ///
  /// Example:
  /// ```dart
  /// final today = DartDateRange.today();
  /// // Today from midnight to end of day
  /// ```
  factory DartDateRange.today() {
    return DartDateRange.day(DateTime.now());
  }

  /// parse [json] to [DartDateRange]
  factory DartDateRange.fromJson(Map<String, dynamic> json) {
    return DartDateRange(
      end: DateTime.parse(json['end'] as String),
      start: DateTime.parse(json['start'] as String),
    );
  }

  const DartDateRange._({
    required this.start,
    required this.end,
  });

  /// the start of the range
  final DateTime start;

  /// the end of the range
  final DateTime end;

  /// copy with new values
  DartDateRange copyWith({
    DateTime? start,
    DateTime? end,
  }) {
    return DartDateRange(
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }

  /// check if [date] is within the range
  ///
  /// Example:
  /// ```dart
  /// final week = DartDateRange(
  ///   start: DateTime(2023, 6, 1),
  ///   end: DateTime(2023, 6, 7),
  /// );
  ///
  /// week.includes(DateTime(2023, 6, 3));   // true
  /// week.includes(DateTime(2023, 6, 10));  // false
  /// week.includes(DateTime(2023, 6, 1));   // true (start date)
  /// week.includes(DateTime(2023, 6, 7));   // true (end date)
  /// ```
  bool includes(DateTime date) =>
      (date.isSameOrAfter(start)) && (date.isSameOrBefore(end));

  /// check if [other] is cross the range
  ///
  /// ### Example 1: No overlap
  /// ```md
  /// |---- DateRange A ------|
  ///                                  |---- DateRange B -----|
  /// ```
  /// Result: `A.cross(B) => false`
  ///
  /// ### Example 2: Partial overlap (B starts within A)
  /// ```md
  /// |---- DateRange A ------|
  ///                    |---- DateRange B -----|
  /// ```
  /// Result: `A.cross(B) => true`
  ///
  /// ### Example 3: Partial overlap (A starts within B)
  /// ```md
  ///              |---- DateRange A ------|
  /// |---- DateRange B -----|
  /// ```
  /// Result: `A.cross(B) => true`
  bool cross(DartDateRange other) =>
      includes(other.start) || includes(other.end);

  /// check if [range] is contained in the range
  ///
  /// ### Example 1: No overlap
  /// ```md
  /// |---- DateRange A ------|
  ///                                  |---- DateRange B -----|
  /// ```
  /// Result: `A.contains(B) => false`
  ///
  /// ### Example 2: Partial overlap (B starts within A)
  /// ```md
  /// |---- DateRange A ------|
  ///                    |---- DateRange B -----|
  /// ```
  /// Result: `A.contains(B) => false`
  ///
  /// ### Example 3: Partial overlap (A starts within B)
  /// ```md
  ///              |---- DateRange A ------|
  /// |---- DateRange B -----|
  /// ```
  /// Result: `A.contains(B) => false`
  ///
  /// ### Example 4: Complete overlap
  /// ```md
  /// |---- DateRange A ------|
  ///   |- DateRange B -|
  /// ```
  /// Result: `A.contains(B) => true`
  ///
  bool contains(DartDateRange range) =>
      includes(range.start) && includes(range.end);

  /// get the duration of the range
  ///
  /// Example:
  /// ```dart
  /// final week = DartDateRange(
  ///   start: DateTime(2023, 6, 1),
  ///   end: DateTime(2023, 6, 7),
  /// );
  ///
  /// print(week.duration.inDays);  // 6
  /// print(week.duration.inHours); // 144
  /// ```
  Duration get duration => end.difference(start);

  /// Generate DateTime instances within the range
  /// using the specified [step] interval.
  ///
  /// Returns an iterable of DateTime objects starting from [start]
  /// and incrementing by [step] until reaching or exceeding [end].
  /// The last generated DateTime will not exceed [end].
  ///
  /// Throws [ArgumentError] if [step] is zero or negative.
  Iterable<DateTime> step(Duration step) {
    if (step.inMicroseconds <= 0) {
      throw _DartDateRangeError.stepNegativeError(step);
    }

    return Iterable.generate(
      (duration.inMicroseconds / step.inMicroseconds).floor() + 1,
      (index) => start.add(step * index),
    ).takeWhile((date) => date.isBefore(end) || date.isAtSameMomentAs(end));
  }

  /// get the dates in the range
  /// ([step] with `Duration(days: 1)`)
  ///
  /// Example:
  /// ```dart
  /// final weekend = DartDateRange(
  ///   start: DateTime(2023, 6, 3),  // Saturday
  ///   end: DateTime(2023, 6, 4),    // Sunday
  /// );
  ///
  /// final allDates = weekend.dates.toList();
  /// // [2023-06-03 00:00:00.000, 2023-06-04 00:00:00.000]
  ///
  /// print(allDates.length); // 2
  /// ```
  Iterable<DateTime> get dates => step(const Duration(days: 1));

  /// merge the range with [other]
  ///
  /// Example:
  /// ```dart
  /// final range = DartDateRange(
  ///   start: DateTime(2023, 6, 1),
  ///   end: DateTime(2023, 6, 7),
  /// );
  ///
  /// final other = DartDateRange(
  ///   start: DateTime(2023, 6, 8),
  ///   end: DateTime(2023, 6, 14),
  /// );
  ///
  /// final merged = range.merge(other);
  /// // From 2023-06-01 00:00:00.000 to 2023-06-14 23:59:59.999
  /// ```
  DartDateRange merge(DartDateRange other) {
    return DartDateRange(
      start: start.isBefore(other.start) ? start : other.start,
      end: end.isAfter(other.end) ? end : other.end,
    );
  }

  /// check if the range is multiple days
  bool get isMultiDay => !start.isSameDay(end);

  /// check if the range is single day
  bool get isSingleDay => start.isSameDay(end);

  /// extend the range by [before] and [after]
  DartDateRange extend({
    Duration? before,
    Duration? after,
  }) {
    return DartDateRange(
      start: start - (before ?? Duration.zero),
      end: end + (after ?? Duration.zero),
    );
  }

  /// convert [DartDateRange] to JSON
  Map<String, dynamic> toJson() => {
        'start': start.toIso8601String(),
        'end': end.toIso8601String(),
      };

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is DartDateRange && start == other.start && end == other.end);
  }

  @override
  int get hashCode => Object.hashAll([start, end]);

  @override
  String toString() {
    return 'start: ${start.toIso8601String()} '
        '--'
        ' end: ${end.toIso8601String()}';
  }
}

abstract class _DartDateRangeError {
  static ArgumentError startAfterEndError(DateTime start, DateTime end) =>
      ArgumentError.value(
        start,
        'start',
        'Start date must be before end date',
      );

  static ArgumentError stepNegativeError(Duration step) => ArgumentError.value(
        step,
        'step',
        'Step duration must be positive',
      );
}

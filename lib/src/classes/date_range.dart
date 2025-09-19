import 'package:dart_time/dart_time.dart';
import 'package:meta/meta.dart';

/// [DartDateRange] represents a range of [DateTime]s.
@immutable
class DartDateRange {
  /// Creates a new [DartDateRange] instance.
  ///
  /// If [start] is after [end], an [ArgumentError] is thrown.
  factory DartDateRange({
    required DateTime start,
    required DateTime end,
  }) {
    if (start.isAfter(end)) {
      throw ArgumentError.value(
        start,
        'start',
        'Start date must be before end date',
      );
    }

    return DartDateRange._(start: start, end: end);
  }

  const DartDateRange._({
    required this.start,
    required this.end,
  });

  /// parse [json] to [DartDateRange]
  factory DartDateRange.fromJson(Map<String, dynamic> json) {
    return DartDateRange(
      end: DateTime.parse(json['end'] as String),
      start: DateTime.parse(json['start'] as String),
    );
  }

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

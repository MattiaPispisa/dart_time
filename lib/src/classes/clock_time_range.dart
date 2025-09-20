import 'package:dart_time/dart_time.dart';
import 'package:meta/meta.dart';

/// [ClockTimeRange] represents a range of [ClockTime]s.
@immutable
class ClockTimeRange {
  /// Creates a new [ClockTimeRange] instance.
  ///
  /// Example:
  /// ```dart
  /// // Working hours: 9 AM to 5 PM
  /// final workHours = ClockTimeRange(
  ///   start: ClockTime(9),
  ///   end: ClockTime(17),
  /// );
  ///
  /// // Night shift: 10 PM to 6 AM (crosses midnight)
  /// final nightShift = ClockTimeRange(
  ///   start: ClockTime(22),
  ///   end: ClockTime(6),
  /// );
  /// ```
  const ClockTimeRange({
    required this.start,
    required this.end,
  });

  /// the start of the range
  final ClockTime start;

  /// the end of the range
  final ClockTime end;

  /// check if [date] is within the range
  ///
  /// Example:
  /// ```dart
  /// final workHours = ClockTimeRange(
  ///   start: ClockTime(9),
  ///   end: ClockTime(17),
  /// );
  ///
  /// final morning = DateTime(2023, 6, 15, 10, 30);  // 10:30 AM
  /// final evening = DateTime(2023, 6, 15, 20, 30);  // 8:30 PM
  ///
  /// workHours.includes(morning);  // true
  /// workHours.includes(evening);  // false
  ///
  /// // Works with midnight-crossing ranges
  /// final nightShift = ClockTimeRange(
  ///   start: ClockTime(22),
  ///   end: ClockTime(6),
  /// );
  /// final midnight = DateTime(2023, 6, 15, 2, 0);  // 2:00 AM
  /// nightShift.includes(midnight);  // true
  /// ```
  bool includes(DateTime date) {
    var startDate = date.copyTime(start);
    var endDate = date.copyTime(end);

    if (end.isBefore(start)) {
      if (start.isAfter(date.clockTime)) {
        startDate = startDate - const Duration(days: 1);
      } else {
        endDate = endDate + const Duration(days: 1);
      }
    }

    return startDate <= date && date <= endDate;
  }

  @override
  String toString() {
    return 'start: $start --- end: $end';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ClockTimeRange && start == other.start && end == other.end);
  }

  @override
  int get hashCode => Object.hashAll([
        start,
        end,
      ]);
}

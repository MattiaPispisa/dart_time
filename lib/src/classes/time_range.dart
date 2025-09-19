import 'package:dart_time/dart_time.dart';
import 'package:meta/meta.dart';

/// [ClockTimeRange] represents a range of [ClockTime]s.
@immutable
class ClockTimeRange {
  /// Creates a new [ClockTimeRange] instance.
  const ClockTimeRange({
    required this.start,
    required this.end,
  });

  /// the start of the range
  final ClockTime start;

  /// the end of the range
  final ClockTime end;

  /// check if [date] is within the range
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

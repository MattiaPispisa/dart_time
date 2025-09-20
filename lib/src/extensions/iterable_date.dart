import 'package:dart_time/dart_time.dart';

/// [IterableDateTimeHelper] contains the helper methods
/// for [Iterable<DateTime>].
extension IterableDateTimeHelper on Iterable<DateTime> {
  /// Get the maximum date in the iterable.
  ///
  /// The iterable must have at least one element
  DateTime max() => reduce((a, b) => a.isAfter(b) ? a : b);

  /// Get the minimum date in the iterable.
  ///
  /// The iterable must have at least one element
  DateTime min() => reduce((a, b) => a.isBefore(b) ? a : b);

  /// Get the span between the earliest and latest dates.
  ///
  /// The iterable must have at least one element
  ///
  /// Example:
  /// ```dart
  /// final dates = [
  ///   DateTime(2023, 1, 1),
  ///   DateTime(2023, 1, 10),
  ///   DateTime(2023, 1, 5),
  /// ];
  /// print(dates.span); // Duration(days: 9)
  /// ```
  Duration get span => max().difference(min());

  /// Calculate the total span in days between the earliest and latest dates.
  ///
  /// Returns 0 if the iterable is empty.
  ///
  /// Example:
  /// ```dart
  /// final dates = [
  ///   DateTime(2023, 1, 1),
  ///   DateTime(2023, 1, 10),
  ///   DateTime(2023, 1, 5),
  /// ];
  /// print(dates.spanInDays); // 9 (10 - 1 = 9 days difference)
  /// ```
  int get spanInDays => span.inDays;

  /// Find the date in the iterable that is closest to the given [target] date.
  ///
  /// The iterable must have at least one element
  ///
  /// Example:
  /// ```dart
  /// final dates = [
  ///   DateTime(2023, 1, 1),
  ///   DateTime(2023, 1, 10),
  ///   DateTime(2023, 1, 20),
  /// ];
  /// final target = DateTime(2023, 1, 12);
  /// print(dates.closestTo(target)); // 2023-01-10 (closest to target)
  /// ```
  DateTime closestTo(DateTime target) {
    return reduce((a, b) {
      final diffA = a.difference(target).abs();
      final diffB = b.difference(target).abs();
      return diffA < diffB ? a : b;
    });
  }

  /// Filter dates to only include weekdays (Monday to Friday).
  /// More info about weekdays in [DateTimeHelper.isWeekday].
  ///
  /// Example:
  /// ```dart
  /// final week = [
  ///   DateTime(2023, 6, 12), // Monday
  ///   DateTime(2023, 6, 13), // Tuesday
  ///   DateTime(2023, 6, 17), // Saturday
  ///   DateTime(2023, 6, 18), // Sunday
  /// ];
  /// final weekdays = week.weekdaysOnly.toList();
  /// print(weekdays.length); // 2 (Monday and Tuesday)
  /// ```
  Iterable<DateTime> get weekdaysOnly => where((date) => date.isWeekday);

  /// Filter dates to only include weekends (Saturday and Sunday).
  ///
  /// More info about weekends in [DateTimeHelper.isWeekend].
  ///
  /// Example:
  /// ```dart
  /// final week = [
  ///   DateTime(2023, 6, 12), // Monday
  ///   DateTime(2023, 6, 13), // Tuesday
  ///   DateTime(2023, 6, 17), // Saturday
  ///   DateTime(2023, 6, 18), // Sunday
  /// ];
  /// final weekends = week.weekendsOnly.toList();
  /// print(weekends.length); // 2 (Saturday and Sunday)
  /// ```
  Iterable<DateTime> get weekendsOnly => where((date) => date.isWeekend);

  /// Sort dates in ascending order (earliest first).
  ///
  /// Example:
  /// ```dart
  /// final unsorted = [
  ///   DateTime(2023, 6, 15),
  ///   DateTime(2023, 6, 10),
  ///   DateTime(2023, 6, 20),
  /// ];
  /// final sorted = unsorted.sortedAscending();
  /// // [2023-06-10, 2023-06-15, 2023-06-20]
  /// ```
  List<DateTime> sortedAscending() {
    return List<DateTime>.from(this)..sort((a, b) => a.compareTo(b));
  }

  /// Sort dates in descending order (latest first).
  ///
  /// Example:
  /// ```dart
  /// final unsorted = [
  ///   DateTime(2023, 6, 15),
  ///   DateTime(2023, 6, 10),
  ///   DateTime(2023, 6, 20),
  /// ];
  /// final sorted = unsorted.sortedDescending();
  /// // [2023-06-20, 2023-06-15, 2023-06-10]
  /// ```
  List<DateTime> sortedDescending() {
    return List<DateTime>.from(this)..sort((a, b) => b.compareTo(a));
  }
}

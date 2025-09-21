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

  /// Get the median date in the iterable.
  ///
  /// For an odd number of dates, returns the middle date.
  /// For an even number of dates, returns the earlier of the two middle dates.
  ///
  /// The iterable must have at least one element.
  ///
  /// Example:
  /// ```dart
  /// final dates = [
  ///   DateTime(2023, 1, 1),
  ///   DateTime(2023, 1, 5),
  ///   DateTime(2023, 1, 10),
  /// ];
  /// print(dates.median()); // 2023-01-05 (middle date)
  ///
  /// final evenDates = [
  ///   DateTime(2023, 1, 1),
  ///   DateTime(2023, 1, 5),
  ///   DateTime(2023, 1, 10),
  ///   DateTime(2023, 1, 15),
  /// ];
  /// print(evenDates.median()); // 2023-01-05 (earlier of two middle dates)
  /// ```
  DateTime median() {
    if (isEmpty) {
      throw StateError('Cannot find median of empty iterable');
    }

    final sorted = sortedAscending();
    final middle = sorted.length ~/ 2;

    // For even number of elements,
    // return the earlier of the two middle elements
    if (sorted.length.isEven) {
      return sorted[middle - 1];
    }

    // For odd number of elements,
    // return the middle element
    return sorted[middle];
  }

  /// Get the mode (most frequently occurring date) in the iterable.
  ///
  /// If multiple dates have the same highest frequency,
  /// returns the earliest one.
  ///
  /// If all dates occur with the same frequency,
  /// returns the earliest date.
  ///
  /// The iterable must have at least one element.
  ///
  /// Example:
  /// ```dart
  /// final dates = [
  ///   DateTime(2023, 1, 1),
  ///   DateTime(2023, 1, 5),
  ///   DateTime(2023, 1, 1), // appears twice
  ///   DateTime(2023, 1, 10),
  /// ];
  /// print(dates.mode()); // 2023-01-01 (appears most frequently)
  /// ```
  DateTime mode() {
    if (isEmpty) {
      throw StateError('Cannot find mode of empty iterable');
    }

    // Count occurrences of each date
    final counts = <DateTime, int>{};
    for (final date in this) {
      counts[date] = (counts[date] ?? 0) + 1;
    }

    // Find the maximum count
    final sortedCountsAscending = counts.entries.toList()
      ..sort((a, b) {
        if (a.value > b.value) {
          return -1;
        } else if (a.value < b.value) {
          return 1;
        }
        return a.key.compareTo(b.key);
      });

    return sortedCountsAscending.first.key;
  }

  /// Calculate the average gap (duration) between consecutive dates.
  ///
  /// The iterable must have at least two elements.
  /// Dates are sorted before calculating gaps.
  ///
  /// Example:
  /// ```dart
  /// final dates = [
  ///   DateTime(2023, 1, 1),
  ///   DateTime(2023, 1, 3),  // 2 days gap
  ///   DateTime(2023, 1, 7),  // 4 days gap
  ///   DateTime(2023, 1, 9),  // 2 days gap
  /// ];
  /// print(dates.averageGap); // Duration(days: 2, hours: 16) // Average of 2, 4, 2 days
  /// ```
  Duration get averageGap {
    if (length < 2) {
      throw StateError('Cannot calculate average gap with less than 2 dates');
    }

    final sorted = sortedAscending();
    final gapsInMicroseconds = <int>[];

    // Calculate gaps between consecutive dates
    for (var i = 1; i < sorted.length; i++) {
      gapsInMicroseconds
          .add(sorted[i].difference(sorted[i - 1]).inMicroseconds);
    }

    // Calculate average gap in microseconds
    final totalMicroseconds = gapsInMicroseconds.reduce((a, b) => a + b);

    final averageMicroseconds = totalMicroseconds ~/ gapsInMicroseconds.length;

    return Duration(microseconds: averageMicroseconds);
  }
}

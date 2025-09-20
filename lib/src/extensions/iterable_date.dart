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
}

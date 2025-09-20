/// [TimeGranularity] is the unit of time.
///
/// Used for comparing dates and times at different levels of precision.
///
/// Example:
/// ```dart
/// final date1 = DateTime(2023, 6, 15, 14, 30, 45, 123);
/// final date2 = DateTime(2023, 6, 15, 10, 15, 20, 456);
///
/// // Compare at day level - they're the same day
/// date1.isGranularSame(date2, TimeGranularity.day);     // true
///
/// // Compare at hour level - different hours
/// date1.isGranularSame(date2, TimeGranularity.hour);    // false
///
/// // Compare at month level - same month
/// date1.isGranularSame(date2, TimeGranularity.month);   // true
/// ```
enum TimeGranularity {
  /// year - compare by year only
  year,

  /// month - compare by year and month
  month,

  /// day - compare by year, month, and day
  day,

  /// hour - compare by year, month, day, and hour
  hour,

  /// minute - compare by year, month, day, hour, and minute
  minute,

  /// second - compare by year, month, day, hour, minute, and second
  second,

  /// milliseconds - compare by year, month, day, hour, minute,
  /// second, and millisecond
  milliseconds,

  /// microseconds - finest granularity, compare all components
  microseconds,
}

/// Helper methods for [TimeGranularity]
extension TimeGranularityHelper on TimeGranularity {
  /// check if the granularity is year
  bool get isYear => this == TimeGranularity.year;

  /// check if the granularity is month
  bool get isMonth => this == TimeGranularity.month;

  /// check if the granularity is day
  bool get isDay => this == TimeGranularity.day;

  /// check if the granularity is hour
  bool get isHour => this == TimeGranularity.hour;

  /// check if the granularity is minute
  bool get isMinute => this == TimeGranularity.minute;

  /// check if the granularity is second
  bool get isSecond => this == TimeGranularity.second;

  /// check if the granularity is milliseconds
  bool get isMilliseconds => this == TimeGranularity.milliseconds;

  /// check if the granularity is microseconds
  bool get isMicroseconds => this == TimeGranularity.microseconds;

  /// map the granularity
  ///
  /// Example:
  /// ```dart
  /// final granularity = TimeGranularity.day;
  ///
  /// final description = granularity.map<String>(
  ///   year: () => 'Yearly precision',
  ///   month: () => 'Monthly precision',
  ///   day: () => 'Daily precision',
  ///   hour: () => 'Hourly precision',
  ///   minute: () => 'Minute precision',
  ///   second: () => 'Second precision',
  ///   milliseconds: () => 'Millisecond precision',
  ///   microseconds: () => 'Microsecond precision',
  /// );
  /// // Returns: "Daily precision"
  /// ```
  T map<T>({
    required T Function() year,
    required T Function() month,
    required T Function() day,
    required T Function() hour,
    required T Function() minute,
    required T Function() second,
    required T Function() milliseconds,
    required T Function() microseconds,
  }) {
    switch (this) {
      case TimeGranularity.year:
        return year();
      case TimeGranularity.month:
        return month();
      case TimeGranularity.day:
        return day();
      case TimeGranularity.hour:
        return hour();
      case TimeGranularity.minute:
        return minute();
      case TimeGranularity.second:
        return second();
      case TimeGranularity.milliseconds:
        return milliseconds();
      case TimeGranularity.microseconds:
        return microseconds();
    }
  }
}

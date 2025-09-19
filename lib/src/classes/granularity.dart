/// [TimeGranularity] is the unit of time.
enum TimeGranularity {
  /// year
  year,

  /// month
  month,

  /// day
  day,

  /// hour
  hour,

  /// minute
  minute,

  /// second
  second,

  /// milliseconds
  milliseconds,

  /// microseconds
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

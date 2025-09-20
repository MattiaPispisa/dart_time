import 'dart:core';
import 'package:dart_time/dart_time.dart';

/// [DurationHelper] contains the helper methods for [Duration].
extension DurationHelper on Duration {
  /// parse [isoString] following [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601)
  ///
  /// [parseISO] ignores:
  /// - [ISODuration.months]
  /// - [ISODuration.years]
  ///
  /// And [ISODuration.weeks] is converted to `days` by multiplying by `7`.
  ///
  /// For a better precision use instead [ISODuration].
  ///
  /// if [isoString] does not follow correct format,
  /// an [ArgumentError] is thrown.
  ///
  /// Example:
  /// ```dart
  /// final duration1 = DurationHelper.parseISO('P3DT4H30M');
  /// // Duration(days: 3, hours: 4, minutes: 30)
  ///
  /// final duration2 = DurationHelper.parseISO('P2W');
  /// // Duration(days: 14)  // 2 weeks = 14 days
  ///
  /// final duration3 = DurationHelper.parseISO('PT1H30M45S');
  /// // Duration(hours: 1, minutes: 30, seconds: 45)
  /// ```
  static Duration parseISO(String isoString) {
    final isoDuration = ISODuration.parse(isoString);

    return Duration(
      days: isoDuration.days + (isoDuration.weeks * 7),
      hours: isoDuration.hours,
      minutes: isoDuration.minutes,
      seconds: isoDuration.seconds,
    );
  }

  /// convert [Duration] to [ISODuration]
  ///
  /// Example:
  /// ```dart
  /// final duration = Duration(days: 3, hours: 4, minutes: 30);
  /// final isoDuration = duration.toIsoDuration();
  /// // ISODuration(days: 3, hours: 4, minutes: 30, seconds: 0)
  /// ```
  ISODuration toIsoDuration() {
    return ISODuration(
      days: inDays,
      hours: inHours % 24,
      minutes: inMinutes % 60,
      seconds: inSeconds % 60,
    );
  }

  /// convert [Duration] to ISO 8601 string format
  ///
  /// returns a string following [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601)
  ///
  /// Example:
  /// ```dart
  /// final duration = Duration(days: 3, hours: 4, minutes: 30);
  /// final isoString = duration.toIsoString();
  /// // "P3DT4H30M"
  ///
  /// final simple = Duration(hours: 2);
  /// print(simple.toIsoString()); // "PT2H"
  /// ```
  String toIsoString() {
    return toIsoDuration().toIso();
  }

  /// Check if duration is zero
  ///
  /// Example:
  /// ```dart
  /// Duration.zero.isZero;              // true
  /// Duration(seconds: 0).isZero;       // true
  /// Duration(minutes: 1).isZero;       // false
  /// ```
  bool get isZero => inMicroseconds == 0;

  /// Check if duration is positive
  ///
  /// Example:
  /// ```dart
  /// Duration(minutes: 5).isPositive;   // true
  /// Duration.zero.isPositive;          // false
  /// Duration(minutes: -5).isPositive;  // false
  /// ```
  bool get isPositive => inMicroseconds > 0;

  /// Check if duration is negative
  ///
  /// Example:
  /// ```dart
  /// Duration(minutes: -5).isNegative;  // true
  /// Duration(minutes: 5).isNegative;   // false
  /// Duration.zero.isNegative;          // false
  /// ```
  bool get isNegative => inMicroseconds < 0;

  /// Get absolute value of duration
  ///
  /// Example:
  /// ```dart
  /// Duration(-5, 0, 0, 0, 0).abs; // Duration(0, 5, 0, 0, 0)
  /// ```
  Duration get absDuration => Duration(microseconds: inMicroseconds.abs());

  /// Get duration in weeks (as double)
  ///
  /// Example:
  /// ```dart
  /// Duration(days: 10).inWeeks; // 1.4285714285714286
  /// Duration(days: 7).inWeeks;  // 1.0
  /// ```
  double get inWeeks => inDays / 7.0;

  /// Get fractional hours (with minutes as decimal)
  ///
  /// Example:
  /// ```dart
  /// Duration(hours: 1, minutes: 30).inFractionalHours; // 1.5
  /// Duration(hours: 2, minutes: 15).inFractionalHours; // 2.25
  /// ```
  double get inFractionalHours => inMinutes / 60.0;

  /// Get fractional minutes (with seconds as decimal)
  ///
  /// Example:
  /// ```dart
  /// Duration(minutes: 1, seconds: 30).inFractionalMinutes; // 1.5
  /// Duration(minutes: 2, seconds: 45).inFractionalMinutes; // 2.75
  /// ```
  double get inFractionalMinutes => inSeconds / 60.0;

  /// Format duration as HH:MM:SS
  ///
  /// Example:
  /// ```dart
  /// Duration(hours: 2, minutes: 30, seconds: 45).hhmmss; // "02:30:45"
  /// Duration(hours: 25, minutes: 5).hhmmss; // "25:05:00"
  /// ```
  String get hhmmss {
    final hours = inHours.abs();
    final minutes = inMinutes.abs() % 60;
    final seconds = inSeconds.abs() % 60;
    final sign = isNegative ? '-' : '';
    return '$sign${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  /// Format duration as HH:MM:SS.mmm (with milliseconds)
  ///
  /// Example:
  /// ```dart
  /// Duration(hours: 1, minutes: 30, seconds: 45, milliseconds: 123).hhmmssmmm;
  /// // "01:30:45.123"
  /// ```
  String get hhmmssmmm {
    final milliseconds = inMilliseconds.abs() % 1000;
    return '$hhmmss.${milliseconds.toString().padLeft(3, '0')}';
  }

  /// Round to nearest minute
  ///
  /// Example:
  /// ```dart
  /// Duration(minutes: 2, seconds: 35).roundToMinute(); // 3 minutes
  /// Duration(minutes: 2, seconds: 25).roundToMinute(); // 2 minutes
  /// ```
  Duration roundToMinute() => Duration(minutes: (inSeconds / 60).round());

  /// Round to nearest hour
  ///
  /// Example:
  /// ```dart
  /// Duration(hours: 2, minutes: 35).roundToHour(); // 3 hours
  /// Duration(hours: 2, minutes: 25).roundToHour(); // 2 hours
  /// ```
  Duration roundToHour() => Duration(hours: (inMinutes / 60).round());

  /// Round to nearest day
  ///
  /// Example:
  /// ```dart
  /// Duration(days: 2, hours: 15).roundToDay(); // 3 days
  /// Duration(days: 2, hours: 10).roundToDay(); // 2 days
  /// ```
  Duration roundToDay() => Duration(days: (inHours / 24).round());

  /// Check if this duration is longer than other
  ///
  /// Example:
  /// ```dart
  /// Duration(minutes: 10).isLongerThan(Duration(minutes: 5));  // true
  /// Duration(minutes: 3).isLongerThan(Duration(minutes: 5));   // false
  /// ```
  bool isLongerThan(Duration other) => this > other;

  /// Check if this duration is shorter than other
  ///
  /// Example:
  /// ```dart
  /// Duration(minutes: 3).isShorterThan(Duration(minutes: 5));  // true
  /// Duration(minutes: 10).isShorterThan(Duration(minutes: 5)); // false
  /// ```
  bool isShorterThan(Duration other) => this < other;

  /// Get the maximum between this and other duration
  ///
  /// Example:
  /// ```dart
  /// Duration(minutes: 10).max(Duration(minutes: 5));   // Duration(minutes: 10)
  /// Duration(minutes: 3).max(Duration(minutes: 5));    // Duration(minutes: 5)
  /// ```
  Duration max(Duration other) => this > other ? this : other;

  /// Get the minimum between this and other duration
  ///
  /// Example:
  /// ```dart
  /// Duration(minutes: 10).min(Duration(minutes: 5));   // Duration(minutes: 5)
  /// Duration(minutes: 3).min(Duration(minutes: 5));    // Duration(minutes: 3)
  /// ```
  Duration min(Duration other) => this < other ? this : other;
}

/// [IntDurationHelper] contains the helper methods for
/// convert [int] to [Duration].
extension IntDurationHelper on int {
  /// get the [Duration] of [days]
  ///
  /// Example:
  /// ```dart
  /// 5.days;   // Duration(days: 5)
  /// 1.days;   // Duration(days: 1)
  /// ```
  Duration get days => Duration(days: this);

  /// get the [Duration] of [hours]
  ///
  /// Example:
  /// ```dart
  /// 3.hours;  // Duration(hours: 3)
  /// 24.hours; // Duration(hours: 24)
  /// ```
  Duration get hours => Duration(hours: this);

  /// get the [Duration] of [minutes]
  ///
  /// Example:
  /// ```dart
  /// 30.minutes;  // Duration(minutes: 30)
  /// 90.minutes;  // Duration(minutes: 90)
  /// ```
  Duration get minutes => Duration(minutes: this);

  /// get the [Duration] of [seconds]
  ///
  /// Example:
  /// ```dart
  /// 45.seconds;  // Duration(seconds: 45)
  /// 120.seconds; // Duration(seconds: 120)
  /// ```
  Duration get seconds => Duration(seconds: this);

  /// get the [Duration] of [milliseconds]
  ///
  /// Example:
  /// ```dart
  /// 500.milliseconds;   // Duration(milliseconds: 500)
  /// 1500.milliseconds;  // Duration(milliseconds: 1500)
  /// ```
  Duration get milliseconds => Duration(milliseconds: this);

  /// get the [Duration] of [microseconds]
  ///
  /// Example:
  /// ```dart
  /// 1000.microseconds;  // Duration(microseconds: 1000)
  /// 500.microseconds;   // Duration(microseconds: 500)
  /// ```
  Duration get microseconds => Duration(microseconds: this);

  /// get the [Duration] of [weeks]
  ///
  /// Example:
  /// ```dart
  /// 2.weeks; // Duration(days: 14)
  /// 1.weeks; // Duration(days: 7)
  /// ```
  Duration get weeks => Duration(days: this * 7);
}

/// [NumDurationHelper] contains helper methods for
/// convert [double] to [Duration] for fractional values.
extension NumDurationHelper on num {
  /// get the [Duration] of fractional `hours`
  ///
  /// Example:
  /// ```dart
  /// 1.5.fractionalHours; // Duration(hours: 1, minutes: 30)
  /// 2.25.fractionalHours; // Duration(hours: 2, minutes: 15)
  /// ```
  Duration get fractionalHours =>
      Duration(microseconds: (this * 3600 * 1000000).round());

  /// get the [Duration] of fractional `minutes`
  ///
  /// Example:
  /// ```dart
  /// 1.5.fractionalMinutes; // Duration(minutes: 1, seconds: 30)
  /// 2.25.fractionalMinutes; // Duration(minutes: 2, seconds: 15)
  /// ```
  Duration get fractionalMinutes =>
      Duration(microseconds: (this * 60 * 1000000).round());

  /// get the [Duration] of fractional `seconds`
  ///
  /// Example:
  /// ```dart
  /// 1.5.fractionalSeconds; // Duration(seconds: 1, milliseconds: 500)
  /// 2.25.fractionalSeconds; // Duration(seconds: 2, milliseconds: 250)
  /// ```
  Duration get fractionalSeconds =>
      Duration(microseconds: (this * 1000000).round());

  /// get the [Duration] of fractional `days`
  ///
  /// Example:
  /// ```dart
  /// 1.5.fractionalDays; // Duration(days: 1, hours: 12)
  /// 0.5.fractionalDays; // Duration(hours: 12)
  /// ```
  Duration get fractionalDays =>
      Duration(microseconds: (this * 24 * 3600 * 1000000).round());
}

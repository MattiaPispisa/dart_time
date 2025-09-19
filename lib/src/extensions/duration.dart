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
  String toIsoString() {
    return toIsoDuration().toIso();
  }
}

/// [IntDurationHelper] contains the helper methods for
/// convert [int] to [Duration].
extension IntDurationHelper on int {
  /// get the [Duration] of [days]
  Duration get days => Duration(days: this);

  /// get the [Duration] of [hours]
  Duration get hours => Duration(hours: this);

  /// get the [Duration] of [minutes]
  Duration get minutes => Duration(minutes: this);

  /// get the [Duration] of [seconds]
  Duration get seconds => Duration(seconds: this);

  /// get the [Duration] of [milliseconds]
  Duration get milliseconds => Duration(milliseconds: this);

  /// get the [Duration] of [microseconds]
  Duration get microseconds => Duration(microseconds: this);
}

import 'package:dart_time/dart_time.dart';
import 'package:meta/meta.dart';

const _zero = 0;
const int _hoursInDay = Duration.hoursPerDay;
const int _noonHour = 24 ~/ 2;
const _morningHour = 6;
const _afternoonHour = 18;
const _eveningHour = 22;
const int _minutesInHour = Duration.minutesPerHour;
const int _secondsInMinute = Duration.secondsPerMinute;
const int _millisecondsInSecond = Duration.millisecondsPerSecond;
const int _microsecondsInMillisecond = Duration.microsecondsPerMillisecond;

/// [ClockTime] represents the time of day
/// from 00:00:00.000000 to 23:59:59.999999.
@immutable
class ClockTime {
  /// Creates a new [ClockTime] instance.
  ///
  /// If the time is invalid, an [ArgumentError] is thrown.
  ///
  /// Example:
  /// ```dart
  /// final time1 = ClockTime(14, minute: 30);         // 14:30:00
  /// final time2 = ClockTime(9, minute: 15, second: 30); // 09:15:30
  /// final precise = ClockTime(12, minute: 0, second: 0,
  ///                          millisecond: 500);      // 12:00:00.500
  /// ```
  factory ClockTime(
    int hour, {
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    minute ??= _zero;
    second ??= _zero;
    millisecond ??= _zero;
    microsecond ??= _zero;

    if (hour < _zero || hour > _hoursInDay - 1) {
      throw _ClockTimeError.hourOutOfRangeError(hour);
    }
    if (minute < _zero || minute > _minutesInHour - 1) {
      throw _ClockTimeError.minuteOutOfRangeError(minute);
    }
    if (second < _zero || second > _secondsInMinute - 1) {
      throw _ClockTimeError.secondOutOfRangeError(second);
    }
    if (millisecond < _zero || millisecond > _millisecondsInSecond - 1) {
      throw _ClockTimeError.millisecondOutOfRangeError(millisecond);
    }
    if (microsecond < _zero || microsecond > _microsecondsInMillisecond - 1) {
      throw _ClockTimeError.microsecondOutOfRangeError(microsecond);
    }

    return ClockTime._(
      hour,
      minute: minute,
      second: second,
      millisecond: millisecond,
      microsecond: microsecond,
    );
  }

  /// Parses time string formatted like Duration.toString().
  /// The string should be of form hours:minutes:seconds.microseconds
  ///
  /// Hours, minutes are REQUIRED
  /// Seconds and microseconds are OPTIONAL
  ///
  /// If the time is invalid, an [ArgumentError] is thrown.
  ///
  /// Hours must be <= 23
  /// Minutes, seconds must be <= 59
  /// Milliseconds, Microseconds must be <= 999
  ///
  /// Example:
  ///     parseTime('22:09:08.007006');
  ///     parseTime('22:09');
  factory ClockTime.parse(String time) {
    final parts = time.split(':');

    if (parts.length != 2 && parts.length != 3) {
      throw _ClockTimeError.invalidTimeFormatError(time);
    }

    final hoursMinutes = _parseHourMinutes(parts);
    final secondsMillsMicro = _parseSecondsMillisecondsMicroseconds(parts);

    return ClockTime(
      hoursMinutes.hours,
      minute: hoursMinutes.minutes,
      second: secondsMillsMicro.seconds,
      millisecond: secondsMillsMicro.milliseconds,
      microsecond: secondsMillsMicro.microseconds,
    );
  }

  /// Create ClockTime for now (current time)
  ///
  /// This function internally use [DateTime.now] hence impure.
  factory ClockTime.now() {
    final now = DateTime.now();
    return ClockTime(
      now.hour,
      minute: now.minute,
      second: now.second,
      millisecond: now.millisecond,
      microsecond: now.microsecond,
    );
  }

  /// parse [json] to [ClockTime]
  factory ClockTime.fromJson(Map<String, dynamic> json) {
    return ClockTime(
      json['hour'] as int,
      minute: json['minute'] as int,
      second: json['second'] as int,
      microsecond: json['microsecond'] as int,
      millisecond: json['millisecond'] as int,
    );
  }

  /// Create ClockTime for midnight (00:00:00.000000)
  factory ClockTime.midnight() => ClockTime(_zero);

  /// Create ClockTime for noon (12:00:00.000000)
  factory ClockTime.noon() => ClockTime(_noonHour);

  const ClockTime._(
    this.hour, {
    required this.minute,
    required this.second,
    required this.millisecond,
    required this.microsecond,
  });

  /// The hour of the day.
  final int hour;

  /// The minute of the hour.
  final int minute;

  /// The second of the minute.
  final int second;

  /// The millisecond of the second.
  final int millisecond;

  /// The microsecond of the millisecond.
  final int microsecond;

  /// copy with new values
  ///
  /// Example:
  /// ```dart
  /// final original = ClockTime(14, minute: 30, second: 45);
  /// final modified = original.copyWith(hour: 15, minute: 35);
  /// // ClockTime(15, minute: 35, second: 45)
  ///
  /// final sameTime = original.copyWith();  // No changes
  /// ```
  ClockTime copyWith({
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return ClockTime(
      hour ?? this.hour,
      minute: minute ?? this.minute,
      second: second ?? this.second,
      millisecond: millisecond ?? this.millisecond,
      microsecond: microsecond ?? this.microsecond,
    );
  }

  /// convert [ClockTime] to JSON
  Map<String, dynamic> toJson() => {
        'hour': hour,
        'minute': minute,
        'second': second,
        'millisecond': millisecond,
        'microsecond': microsecond,
      };

  /// check if `this` is the same as [other] clock time
  bool isAtSameTimeAs(ClockTime other) {
    final duration = toDuration();
    final otherDuration = other.toDuration();
    return duration.compareTo(otherDuration) == _zero;
  }

  /// check if `this` is after [other] clock time
  bool isAfter(ClockTime other) {
    final duration = toDuration();
    final otherDuration = other.toDuration();
    return duration.compareTo(otherDuration) > _zero;
  }

  /// check if `this` is before [other] clock time
  bool isBefore(ClockTime other) {
    final duration = toDuration();
    final otherDuration = other.toDuration();
    return duration.compareTo(otherDuration) < _zero;
  }

  /// check if `this` is the same or after [other] clock time
  bool isSameOrAfter(ClockTime other) {
    return isAtSameTimeAs(other) || isAfter(other);
  }

  /// check if `this` is the same or before [other] clock time
  bool isSameOrBefore(ClockTime other) {
    return isAtSameTimeAs(other) || isBefore(other);
  }

  /// check if `this` is before [other] clock time
  ///
  /// (operator for [isBefore])
  bool operator <(ClockTime other) => isBefore(other);

  /// check if `this` is the same or before [other] clock time
  ///
  /// (operator for [isSameOrBefore])
  bool operator <=(ClockTime other) => isSameOrBefore(other);

  /// check if `this` is after [other] clock time
  ///
  /// (operator for [isAfter])
  bool operator >(ClockTime other) => isAfter(other);

  /// check if `this` is the same or after [other] clock time
  ///
  /// (operator for [isSameOrAfter])
  bool operator >=(ClockTime other) => isSameOrAfter(other);

  /// subtract [other] clock time from `this`
  Duration operator -(ClockTime other) =>
      Duration(hours: hour - other.hour, minutes: minute - other.minute);

  /// add [other] clock time to `this`
  Duration operator +(ClockTime other) =>
      Duration(hours: hour + other.hour, minutes: minute + other.minute);

  /// convert [ClockTime] to [Duration]
  Duration toDuration() {
    return Duration(
      hours: hour,
      minutes: minute,
      seconds: second,
      microseconds: microsecond,
      milliseconds: millisecond,
    );
  }

  /// Apply `this` to [date]
  /// (same as [DateTimeHelper.copyTime])
  DateTime inDate(DateTime date) {
    return date.copyTime(this);
  }

  /// Add duration to this time, wrapping around 24 hours if necessary
  ///
  /// Example:
  /// ```dart
  /// ClockTime(23, minute: 30).add(Duration(hours: 1)); // 00:30:00
  /// ClockTime(10, minute: 45).add(Duration(minutes: 30)); // 11:15:00
  /// ```
  ClockTime add(Duration duration) {
    final totalMicroseconds =
        toDuration().inMicroseconds + duration.inMicroseconds;
    final dayMicroseconds = const Duration(days: 1).inMicroseconds;
    final wrappedMicroseconds = totalMicroseconds % dayMicroseconds;

    final wrappedDuration = Duration(microseconds: wrappedMicroseconds);
    return ClockTime(
      wrappedDuration.inHours,
      minute: wrappedDuration.inMinutes % _minutesInHour,
      second: wrappedDuration.inSeconds % _secondsInMinute,
      millisecond: wrappedDuration.inMilliseconds % _millisecondsInSecond,
      microsecond: wrappedDuration.inMicroseconds % _microsecondsInMillisecond,
    );
  }

  /// Subtract duration from this time, wrapping around 24 hours if necessary
  /// (Same as [add] with negative duration)
  ///
  /// Example:
  /// ```dart
  /// ClockTime(1, minute: 30).subtract(Duration(hours: 2)); // 23:30:00
  /// ClockTime(10, minute: 15).subtract(Duration(minutes: 30)); // 09:45:00
  /// ```
  ClockTime subtract(Duration duration) => add(-duration);

  /// Add hours to this time, wrapping around 24 hours if necessary
  ///
  /// Example:
  /// ```dart
  /// ClockTime(22).addHours(3); // 01:00:00
  /// ClockTime(10).addHours(5); // 15:00:00
  /// ```
  ClockTime addHours(int hours) => add(Duration(hours: hours));

  /// Add minutes to this time, wrapping around 24 hours if necessary
  ///
  /// Example:
  /// ```dart
  /// ClockTime(23, minute: 45).addMinutes(30); // 00:15:00
  /// ClockTime(10, minute: 30).addMinutes(45); // 11:15:00
  /// ```
  ClockTime addMinutes(int minutes) => add(Duration(minutes: minutes));

  /// Add seconds to this time, wrapping around 24 hours if necessary
  ///
  /// Example:
  /// ```dart
  /// ClockTime(10, minute: 30, second: 30).addSeconds(45);  // 10:31:15
  /// ClockTime(23, minute: 59, second: 30).addSeconds(45);  // 00:00:15 (next day)
  /// ```
  ClockTime addSeconds(int seconds) => add(Duration(seconds: seconds));

  /// Format as 12-hour time with AM/PM
  ///
  /// Example:
  /// ```dart
  /// ClockTime(0).format12Hour; // "12:00 AM"
  /// ClockTime(13, minute: 30).format12Hour; // "1:30 PM"
  /// ClockTime(23, minute: 45).format12Hour; // "11:45 PM"
  /// ```
  String get format12Hour {
    final period = hour < _noonHour ? 'AM' : 'PM';
    final displayHour = hour == _zero
        ? _noonHour
        : (hour > _noonHour ? hour - _noonHour : hour);
    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }

  /// Format as HH:MM (24-hour format)
  ///
  /// Example:
  /// ```dart
  /// ClockTime(9, minute: 5).format24Hour; // "09:05"
  /// ClockTime(15, minute: 30).format24Hour; // "15:30"
  /// ```
  String get format24Hour {
    return '${hour.toString().padLeft(2, '0')}'
        ':${minute.toString().padLeft(2, '0')}';
  }

  /// Format as HH:MM:SS
  ///
  /// Example:
  /// ```dart
  /// ClockTime(9, minute: 5, second: 30).formatWithSeconds; // "09:05:30"
  /// ```
  String get formatWithSeconds {
    return '$format24Hour:${second.toString().padLeft(2, '0')}';
  }

  /// Check if this is morning time (06:00-11:59)
  ///
  /// Example:
  /// ```dart
  /// ClockTime(8).isMorning;   // true
  /// ClockTime(14).isMorning;  // false
  /// ClockTime(5).isMorning;   // false (night)
  /// ```
  bool get isMorning => hour >= _morningHour && hour < _noonHour;

  /// Check if this is afternoon time (12:00-17:59)
  ///
  /// Example:
  /// ```dart
  /// ClockTime(14).isAfternoon;  // true
  /// ClockTime(10).isAfternoon;  // false
  /// ClockTime(19).isAfternoon;  // false (evening)
  /// ```
  bool get isAfternoon => hour >= _noonHour && hour < _afternoonHour;

  /// Check if this is evening time (18:00-21:59)
  ///
  /// Example:
  /// ```dart
  /// ClockTime(19).isEvening;  // true
  /// ClockTime(14).isEvening;  // false
  /// ClockTime(23).isEvening;  // false (night)
  /// ```
  bool get isEvening => hour >= _afternoonHour && hour < _eveningHour;

  /// Check if this is night time (22:00-05:59)
  ///
  /// Example:
  /// ```dart
  /// ClockTime(23).isNight;  // true
  /// ClockTime(2).isNight;   // true
  /// ClockTime(14).isNight;  // false
  /// ```
  bool get isNight => hour >= _eveningHour || hour < _morningHour;

  /// Check if this is AM (00:00-11:59)
  ///
  /// Example:
  /// ```dart
  /// ClockTime(9).isAM;   // true
  /// ClockTime(14).isAM;  // false
  /// ClockTime(0).isAM;   // true (midnight)
  /// ```
  bool get isAM => hour < _noonHour;

  /// Check if this is PM (12:00-23:59)
  ///
  /// Example:
  /// ```dart
  /// ClockTime(14).isPM;  // true
  /// ClockTime(9).isPM;   // false
  /// ClockTime(12).isPM;  // true (noon)
  /// ```
  bool get isPM => hour >= _noonHour;

  /// Get the time period as a string
  ///
  /// Returns "morning", "afternoon", "evening", or "night"
  ///
  /// Example:
  /// ```dart
  /// ClockTime(8).period; // "morning"
  /// ClockTime(14).period; // "afternoon"
  /// ClockTime(19).period; // "evening"
  /// ClockTime(23).period; // "night"
  /// ```
  String get period {
    if (isMorning) return 'morning';
    if (isAfternoon) return 'afternoon';
    if (isEvening) return 'evening';
    return 'night';
  }

  /// Get total minutes since midnight
  ///
  /// Example:
  /// ```dart
  /// ClockTime(1, minute: 30).minutesSinceMidnight; // 90
  /// ClockTime(12).minutesSinceMidnight; // 720
  /// ```
  int get minutesSinceMidnight => hour * _minutesInHour + minute;

  /// Get total seconds since midnight
  ///
  /// Example:
  /// ```dart
  /// ClockTime(0, minute: 1, second: 30).secondsSinceMidnight; // 90
  /// ```
  int get secondsSinceMidnight =>
      minutesSinceMidnight * _secondsInMinute + second;

  /// Get minutes until midnight (next day)
  ///
  /// Example:
  /// ```dart
  /// ClockTime(23, minute: 30).minutesUntilMidnight; // 30
  /// ClockTime(0).minutesUntilMidnight; // 1440 (24 hours)
  /// ```
  int get minutesUntilMidnight =>
      (_hoursInDay * _minutesInHour) - minutesSinceMidnight;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ClockTime &&
            hour == other.hour &&
            minute == other.minute &&
            second == other.second &&
            millisecond == other.millisecond &&
            microsecond == other.microsecond);
  }

  @override
  int get hashCode => Object.hashAll(
        [
          hour,
          minute,
          second,
          millisecond,
          microsecond,
        ],
      );

  @override
  String toString() {
    final micro = millisecond * _microsecondsInMillisecond + microsecond;
    return '${hour.toString().padRight(2, '0')}'
        ':${minute.toString().padRight(2, '0')}'
        ':${second.toString().padRight(2, '0')}'
        '.${micro.toString().padRight(6, '0')}';
  }
}

// example parts:
// - '245:09:08.007006';
// - '245:09';
// - '245:09:08';
_DHM _parseHourMinutes(List<String> parts) {
  final minutes = int.parse(parts[1]);
  final p = int.parse(parts[0]);
  final hours = p % _hoursInDay;
  final days = p ~/ _hoursInDay;
  return _DHM(
    days: days,
    hours: hours,
    minutes: minutes,
  );
}

// example parts:
// - '245:09:08.007006';
// - '245:09';
// - '245:09:08';
_SecMillsMicro _parseSecondsMillisecondsMicroseconds(List<String> parts) {
  if (parts.length == 2) {
    return _SecMillsMicro();
  }

  final p = parts[2].split('.');

  final seconds = int.parse(p[0]);

  if (p.length == 1) {
    return _SecMillsMicro(seconds: seconds);
  }

  final p2 = int.parse(p[1].padRight(6, '0'));
  final microseconds = p2 % _microsecondsInMillisecond;
  final milliseconds = p2 ~/ _millisecondsInSecond;

  return _SecMillsMicro(
    seconds: seconds,
    milliseconds: milliseconds,
    microseconds: microseconds,
  );
}

class _DHM {
  _DHM({
    required this.days,
    required this.hours,
    required this.minutes,
  });

  final int days;
  final int hours;
  final int minutes;
}

class _SecMillsMicro {
  _SecMillsMicro({
    this.seconds = _zero,
    this.milliseconds = _zero,
    this.microseconds = _zero,
  });

  final int seconds;
  final int milliseconds;
  final int microseconds;
}

abstract class _ClockTimeError {
  static ArgumentError hourOutOfRangeError(int hour) => ArgumentError.value(
        hour,
        'hour',
        'Hour must be between $_zero'
            ' and ${_hoursInDay - 1}',
      );

  static ArgumentError minuteOutOfRangeError(int minute) => ArgumentError.value(
        minute,
        'minute',
        'Minute must be between $_zero'
            ' and ${_minutesInHour - 1}',
      );

  static ArgumentError secondOutOfRangeError(int second) => ArgumentError.value(
        second,
        'second',
        'Second must be between $_zero'
            ' and ${_secondsInMinute - 1}',
      );

  static ArgumentError millisecondOutOfRangeError(int millisecond) =>
      ArgumentError.value(
        millisecond,
        'millisecond',
        'Millisecond must be between $_zero'
            ' and ${_millisecondsInSecond - 1}',
      );

  static ArgumentError microsecondOutOfRangeError(int microsecond) =>
      ArgumentError.value(
        microsecond,
        'microsecond',
        'Microsecond must be between $_zero'
            ' and ${_microsecondsInMillisecond - 1}',
      );

  static ArgumentError invalidTimeFormatError(String time) =>
      ArgumentError.value(
        time,
        'time',
        'Invalid time format',
      );
}

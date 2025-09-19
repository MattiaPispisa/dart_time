import 'package:meta/meta.dart';

/// [ClockTime] represents the time of day
/// from 00:00:00.000000 to 23:59:59.999999.
@immutable
class ClockTime {
  /// Creates a new [ClockTime] instance.
  ///
  /// If the time is invalid, an [ArgumentError] is thrown.
  factory ClockTime(
    int hour, {
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    minute ??= 0;
    second ??= 0;
    millisecond ??= 0;
    microsecond ??= 0;

    if (hour < 0 || hour > 23) {
      throw ArgumentError.value(hour, 'hour', 'Hour must be between 0 and 23');
    }
    if (minute < 0 || minute > 59) {
      throw ArgumentError.value(
          minute, 'minute', 'Minute must be between 0 and 59');
    }
    if (second < 0 || second > 59) {
      throw ArgumentError.value(
          second, 'second', 'Second must be between 0 and 59');
    }
    if (millisecond < 0 || millisecond > 999) {
      throw ArgumentError.value(
          millisecond, 'millisecond', 'Millisecond must be between 0 and 999');
    }
    if (microsecond < 0 || microsecond > 999) {
      throw ArgumentError.value(
          microsecond, 'microsecond', 'Microsecond must be between 0 and 999');
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
      throw ArgumentError.value(time, 'time', 'Invalid time format');
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
    return duration.compareTo(otherDuration) == 0;
  }

  /// check if `this` is after [other] clock time
  bool isAfter(ClockTime other) {
    final duration = toDuration();
    final otherDuration = other.toDuration();
    return duration.compareTo(otherDuration) > 0;
  }

  /// check if `this` is before [other] clock time
  bool isBefore(ClockTime other) {
    final duration = toDuration();
    final otherDuration = other.toDuration();
    return duration.compareTo(otherDuration) < 0;
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
    return '${hour.toString().padRight(2, '0')}'
        ':${minute.toString().padRight(2, '0')}'
        ':${second.toString().padRight(2, '0')}'
        '.${(millisecond * 1000 + microsecond).toString().padRight(6, '0')}';
  }
}

// example parts:
// - '245:09:08.007006';
// - '245:09';
// - '245:09:08';
_DHM _parseHourMinutes(List<String> parts) {
  final minutes = int.parse(parts[1]);
  final p = int.parse(parts[0]);
  final hours = p % 24;
  final days = p ~/ 24;
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
  final microseconds = p2 % 1000;
  final milliseconds = p2 ~/ 1000;

  return _SecMillsMicro(
      seconds: seconds, milliseconds: milliseconds, microseconds: microseconds);
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
    this.seconds = 0,
    this.milliseconds = 0,
    this.microseconds = 0,
  });

  final int seconds;
  final int milliseconds;
  final int microseconds;
}

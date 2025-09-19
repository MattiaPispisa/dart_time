import 'package:meta/meta.dart';

final _kRegExpIsoDuration = RegExp(
  r'^(-|\+)?P(?:([-+]?[0-9,.]*)Y)?(?:([-+]?[0-9,.]*)M)?(?:([-+]?[0-9,.]*)W)?(?:([-+]?[0-9,.]*)D)?(?:T(?:([-+]?[0-9,.]*)H)?(?:([-+]?[0-9,.]*)M)?(?:([-+]?[0-9,.]*)S)?)?$',
);

/// [ISODuration] is the [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) duration.
@immutable
class ISODuration {
  /// Creates a new [ISODuration] instance.
  factory ISODuration({
    int? years,
    int? months,
    int? weeks,
    int? days,
    int? minutes,
    int? hours,
    int? seconds,
  }) {
    return ISODuration._(
      years: years ?? 0,
      months: months ?? 0,
      weeks: weeks ?? 0,
      days: days ?? 0,
      minutes: minutes ?? 0,
      hours: hours ?? 0,
      seconds: seconds ?? 0,
    );
  }

  /// parse [isoString] following [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601)
  ///
  /// if [isoString] does not follow correct format, an [ArgumentError] is thrown.
  factory ISODuration.parse(String isoString) {
    _validateIsoString(isoString);

    // split between period and time
    final isoStringSplit = isoString.split('T');

    var isoPeriodString = '';
    var isoTimeString = '';

    // no "T" found, just period
    if (isoStringSplit.length == 1) {
      isoPeriodString = isoString;
    }
    // period and time
    else {
      isoPeriodString = isoStringSplit[0];
      isoTimeString = isoStringSplit[1];
    }

    var year = 0;
    var month = 0;
    var weeks = 0;
    var days = 0;
    var hours = 0;
    var minutes = 0;
    var seconds = 0;

    year = _parseTime(isoPeriodString, 'Y');
    month = _parseTime(isoPeriodString, 'M');
    weeks = _parseTime(isoPeriodString, 'W');
    days = _parseTime(isoPeriodString, 'D');
    hours = _parseTime(isoTimeString, 'H');
    minutes = _parseTime(isoTimeString, 'M');
    seconds = _parseTime(isoTimeString, 'S');

    return ISODuration(
      years: year,
      months: month,
      weeks: weeks,
      days: days,
      hours: hours,
      minutes: minutes,
      seconds: seconds,
    );
  }

  /// parse [json] to [ISODuration]
  factory ISODuration.fromJson(Map<String, dynamic> json) {
    return ISODuration(
      years: json['years'] as int,
      months: json['months'] as int,
      weeks: json['weeks'] as int,
      days: json['days'] as int,
      hours: json['hours'] as int,
      minutes: json['minutes'] as int,
      seconds: json['seconds'] as int,
    );
  }

  const ISODuration._({
    required this.years,
    required this.months,
    required this.weeks,
    required this.days,
    required this.minutes,
    required this.hours,
    required this.seconds,
  });

  /// try to parse [isoString] following [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601)
  ///
  /// returns null if [isoString] does not follow correct format
  static ISODuration? tryParse(String isoString) {
    if (!_canISOString(isoString)) {
      return null;
    }

    return ISODuration.parse(isoString);
  }

  /// years
  final int years;

  /// months
  final int months;

  /// weeks
  final int weeks;

  /// days
  final int days;

  /// minutes
  final int minutes;

  /// hours
  final int hours;

  /// seconds
  final int seconds;

  @override
  bool operator ==(Object other) =>
      other is ISODuration &&
      years == other.years &&
      months == other.months &&
      weeks == other.weeks &&
      days == other.days &&
      hours == other.hours &&
      minutes == other.minutes &&
      seconds == other.seconds;

  @override
  int get hashCode => Object.hashAll([
        years,
        months,
        weeks,
        days,
        hours,
        minutes,
        seconds,
      ]);

  @override
  String toString() {
    return 'years: $years, months: $months, weeks: $weeks,'
        ' days: $days, hours: $hours, minutes: $minutes, seconds:$seconds';
  }

  /// convert [ISODuration] to ISO 8601 string format
  ///
  /// returns a string following [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601)
  String toIso() {
    final buffer = StringBuffer('P');

    if (years > 0) {
      buffer.write('${years}Y');
    }

    if (months > 0) {
      buffer.write('${months}M');
    }

    if (weeks > 0) {
      buffer.write('${weeks}W');
    }

    if (days > 0) {
      buffer.write('${days}D');
    }

    if (hours > 0 || minutes > 0 || seconds > 0) {
      buffer.write('T');

      if (hours > 0) {
        buffer.write('${hours}H');
      }

      if (minutes > 0) {
        buffer.write('${minutes}M');
      }

      if (seconds > 0) {
        buffer.write('${seconds}S');
      }
    }

    // if no components were added, return P0D
    if (buffer.length == 1) {
      buffer.write('0D');
    }

    return buffer.toString();
  }

  /// convert [ISODuration] to [Duration]
  Duration toDuration() {
    return Duration(
      days: days + (weeks * 7),
      hours: hours,
      minutes: minutes,
      seconds: seconds,
    );
  }

  /// copy with new values
  ISODuration copyWith({
    int? years,
    int? months,
    int? weeks,
    int? days,
    int? minutes,
    int? hours,
    int? seconds,
  }) {
    return ISODuration(
      years: years ?? this.years,
      months: months ?? this.months,
      weeks: weeks ?? this.weeks,
      days: days ?? this.days,
      minutes: minutes ?? this.minutes,
      hours: hours ?? this.hours,
      seconds: seconds ?? this.seconds,
    );
  }

  /// convert [ISODuration] to JSON
  Map<String, dynamic> toJson() => {
        'years': years,
        'months': months,
        'weeks': weeks,
        'days': days,
        'minutes': minutes,
        'hours': hours,
        'seconds': seconds,
      };
}

bool _canISOString(String isoString) {
  return _kRegExpIsoDuration.hasMatch(isoString);
}

void _validateIsoString(String isoString) {
  if (!_canISOString(isoString)) {
    throw ArgumentError.value(
      isoString,
      'isoString',
      'String does not follow correct format',
    );
  }
}

///  helper method for extracting a time value from the ISO8601 string.
int _parseTime(String duration, String timeUnit) {
  final timeMatch = RegExp(r'\d+' + timeUnit).firstMatch(duration);

  if (timeMatch == null) {
    return 0;
  }
  final timeString = timeMatch.group(0)!;
  return int.parse(timeString.substring(0, timeString.length - 1));
}

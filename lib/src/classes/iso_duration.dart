import 'package:meta/meta.dart';

final _kRegExpIsoDuration = RegExp(
  r'^(-|\+)?P(?:([-+]?[0-9,.]*)Y)?(?:([-+]?[0-9,.]*)M)?(?:([-+]?[0-9,.]*)W)?(?:([-+]?[0-9,.]*)D)?(?:T(?:([-+]?[0-9,.]*)H)?(?:([-+]?[0-9,.]*)M)?(?:([-+]?[0-9,.]*)S)?)?$',
);

/// [ISODuration] is the [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) duration.
///
/// Supports both positive and negative durations according
/// to ISO 8601 standard.
///
/// Negative durations are prefixed with a minus sign (-).
@immutable
class ISODuration {
  /// Creates a new [ISODuration] instance.
  ///
  /// All components can be negative. If any component is negative,
  /// the entire duration is considered negative.
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
  /// Supports negative durations prefixed with '-' (e.g., '-P1Y2M3D').
  /// if [isoString] does not follow correct format,
  /// an [ArgumentError] is thrown.
  factory ISODuration.parse(String isoString) {
    _validateIsoString(isoString);

    // Check if duration is negative
    final isNegative = isoString.startsWith('-');

    // Remove the sign for parsing
    final cleanIsoString =
        isoString.startsWith('-') || isoString.startsWith('+')
            ? isoString.substring(1)
            : isoString;

    // split between period and time
    final isoStringSplit = cleanIsoString.split('T');

    var isoPeriodString = '';
    var isoTimeString = '';

    // no "T" found, just period
    if (isoStringSplit.length == 1) {
      isoPeriodString = cleanIsoString;
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

    // Apply negative sign to all components if duration is negative
    if (isNegative) {
      year = -year;
      month = -month;
      weeks = -weeks;
      days = -days;
      hours = -hours;
      minutes = -minutes;
      seconds = -seconds;
    }

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
  ///
  /// Example:
  /// ```dart
  /// final json = {
  ///   'years': 1,
  ///   'months': 6,
  ///   'days': 15,
  ///   'hours': 4,
  ///   'minutes': 30,
  ///   'seconds': 0,
  ///   'weeks': 0,
  /// };
  /// final duration = ISODuration.fromJson(json);
  /// // ISODuration(years: 1, months: 6, days: 15, hours: 4, minutes: 30)
  /// ```
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

  /// Returns true if this duration is negative.
  /// A duration is considered negative if any of its components is negative.
  bool get isNegative =>
      years < 0 ||
      months < 0 ||
      weeks < 0 ||
      days < 0 ||
      hours < 0 ||
      minutes < 0 ||
      seconds < 0;

  /// Returns true if this duration is positive.
  /// A duration is considered positive if any of its components is positive.
  bool get isPositive =>
      years > 0 ||
      months > 0 ||
      weeks > 0 ||
      days > 0 ||
      hours > 0 ||
      minutes > 0 ||
      seconds > 0;

  /// Returns true if this duration is zero (all components are zero).
  bool get isZero =>
      years == 0 &&
      months == 0 &&
      weeks == 0 &&
      days == 0 &&
      hours == 0 &&
      minutes == 0 &&
      seconds == 0;

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
  /// Negative durations are prefixed with '-'.
  String toIso() {
    final buffer = StringBuffer();

    // Add negative sign if needed
    if (isNegative) {
      buffer.write('-');
    }

    buffer.write('P');

    // Use absolute values for output since sign is handled at the beginning
    final absYears = years.abs();
    final absMonths = months.abs();
    final absWeeks = weeks.abs();
    final absDays = days.abs();
    final absHours = hours.abs();
    final absMinutes = minutes.abs();
    final absSeconds = seconds.abs();

    if (absYears > 0) {
      buffer.write('${absYears}Y');
    }

    if (absMonths > 0) {
      buffer.write('${absMonths}M');
    }

    if (absWeeks > 0) {
      buffer.write('${absWeeks}W');
    }

    if (absDays > 0) {
      buffer.write('${absDays}D');
    }

    if (absHours > 0 || absMinutes > 0 || absSeconds > 0) {
      buffer.write('T');

      if (absHours > 0) {
        buffer.write('${absHours}H');
      }

      if (absMinutes > 0) {
        buffer.write('${absMinutes}M');
      }

      if (absSeconds > 0) {
        buffer.write('${absSeconds}S');
      }
    }

    // if no components were added, return P0D (or -P0D for negative)
    if (buffer.toString() == 'P' || buffer.toString() == '-P') {
      buffer.write('0D');
    }

    return buffer.toString();
  }

  /// convert [ISODuration] to [Duration]
  ///
  /// Note: Years and months are ignored as they cannot be accurately
  /// converted to a fixed duration without a specific date context.
  ///
  /// Example:
  /// ```dart
  /// final isoDuration = ISODuration(days: 3, hours: 4, minutes: 30);
  /// final duration = isoDuration.toDuration();
  /// // Duration(days: 3, hours: 4, minutes: 30)
  ///
  /// final withWeeks = ISODuration(weeks: 2, days: 1);
  /// final duration2 = withWeeks.toDuration();
  /// // Duration(days: 15)  // 2 weeks + 1 day = 15 days
  /// ```
  Duration toDuration() {
    return Duration(
      days: days + (weeks * 7),
      hours: hours,
      minutes: minutes,
      seconds: seconds,
    );
  }

  /// copy with new values
  ///
  /// Example:
  /// ```dart
  /// final original = ISODuration(years: 1, months: 2, days: 3);
  ///
  /// final modified = original.copyWith(years: 2, days: 5);
  /// // ISODuration(years: 2, months: 2, days: 5)
  ///
  /// final onlyMonths = original.copyWith(years: 0, days: 0);
  /// // ISODuration(years: 0, months: 2, days: 0)
  /// ```
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

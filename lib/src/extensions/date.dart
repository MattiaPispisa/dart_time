import 'package:dart_time/dart_time.dart';

/// [DateHelper] contains the helper methods for [DateTime].
extension DateHelper on DateTime {
  /// create a new [DateTime] instance with named parameters.
  static DateTime named({
    required int year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return DateTime(
      year,
      month ?? 1,
      day ?? 1,
      hour ?? 0,
      minute ?? 0,
      millisecond ?? 0,
      microsecond ?? 0,
    );
  }

  /// copy with new values
  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) =>
      DateTime(
        year ?? this.year,
        month ?? this.month,
        day ?? this.day,
        hour ?? this.hour,
        minute ?? this.minute,
        millisecond ?? this.millisecond,
        microsecond ?? this.microsecond,
      );

  /// copy with new [time]
  DateTime copyTime(ClockTime time) {
    return copyWith(
      hour: time.hour,
      minute: time.minute,
      second: time.second,
      millisecond: time.millisecond,
      microsecond: time.microsecond,
    );
  }

  /// get the start of the year
  DateTime get startOfYear => copyWith(
        month: 1,
        day: 1,
        hour: 0,
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      );

  /// get the start of the month
  DateTime get startOfMonth => copyWith(
        day: 1,
        hour: 0,
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      );

  /// get the start of the day
  DateTime get startOfDay => copyWith(
        hour: 0,
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      );

  /// get the start of the hour
  DateTime get startOfHour => copyWith(
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      );

  /// get the start of the minute
  DateTime get startOfMinute => copyWith(
        second: 0,
        millisecond: 0,
        microsecond: 0,
      );

  /// get the start of the second
  DateTime get startOfSecond => copyWith(
        millisecond: 0,
        microsecond: 0,
      );

  /// get the next day
  DateTime get nextDay => addDays(1);

  /// get the previous day
  DateTime get previousDay => addDays(-1);

  /// check if [other] is the same or after `this`
  ///
  /// [granularity] is the granularity of the comparison,
  /// default is [TimeGranularity.microseconds]
  ///
  /// Example:
  /// ```dart
  /// // TODO(mattia): add examples
  /// ```
  bool isSameOrAfter(
    DateTime other, [
    TimeGranularity granularity = TimeGranularity.microseconds,
  ]) {
    final self = granularity._apply(this);
    return self.isAtSameMomentAs(granularity._apply(other)) ||
        self.isAfter(granularity._apply(other));
  }

  /// check if `this` is after [other]
  ///
  /// [granularity] is the granularity of the comparison,
  /// default is [TimeGranularity.microseconds]
  ///
  /// Example:
  /// ```dart
  /// // TODO(mattia): add examples
  /// ```
  bool isGranularAfter(
    DateTime other, [
    TimeGranularity granularity = TimeGranularity.microseconds,
  ]) =>
      isAfter(granularity._apply(other));

  /// check if `this` is before [other]
  ///
  /// [granularity] is the granularity of the comparison,
  /// default is [TimeGranularity.microseconds]
  ///
  /// Example:
  /// ```dart
  /// // TODO(mattia): add examples
  /// ```
  bool isGranularBefore(
    DateTime other, [
    TimeGranularity granularity = TimeGranularity.microseconds,
  ]) =>
      isBefore(granularity._apply(other));

  /// check if [other] is the same or before `this`
  ///
  /// [granularity] is the granularity of the comparison,
  /// default is [TimeGranularity.microseconds]
  ///
  /// Example:
  /// ```dart
  /// // TODO(mattia): add examples
  /// ```
  bool isSameOrBefore(
    DateTime other, [
    TimeGranularity granularity = TimeGranularity.microseconds,
  ]) {
    final self = granularity._apply(this);
    return self.isAtSameMomentAs(granularity._apply(other)) ||
        self.isBefore(granularity._apply(other));
  }

  /// check if `this` is before [other]
  bool operator <(DateTime other) => isBefore(other);

  /// check if `this` is the same or before [other]
  bool operator <=(DateTime other) => isSameOrBefore(other);

  /// check if `this` is after [other]
  bool operator >(DateTime other) => isAfter(other);

  /// check if `this` is the same or after [other]
  bool operator >=(DateTime other) => isSameOrAfter(other);

  /// subtract [other] from `this`
  DateTime operator -(Duration other) => subtract(other);

  /// add [other] to `this`
  DateTime operator +(Duration other) => add(other);

  /// add [amount] years to `this`
  DateTime addYears(int amount) => copyWith(year: year + amount);

  /// add [amount] months to `this`
  DateTime addMonths(int amount) => copyWith(month: month + amount);

  /// Add [amount] days to `this` DateTime.
  ///
  /// The [ignoreDaylightSavings] parameter controls how Daylight Saving Time
  /// (DST) transitions are handled.
  /// Default is `false`.
  ///
  /// **When `false` (default):**
  /// - Uses `add(Duration(days: amount))` which maintains real time intervals
  /// - The local time may shift during DST transitions
  /// - Example: Adding 1 day during spring DST transition (2am becomes 3am)
  ///   will result in the time being 1 hour later than expected
  ///
  /// **When `true`:**
  /// - Uses `copyWith(day: day + amount)` which maintains local time
  /// - Ignores DST transitions and keeps the same hour/minute/second
  /// - Example: Adding 1 day during DST transition will keep the
  /// exact same time
  ///
  /// **Use cases:**
  /// - `ignoreDaylightSavings: false` for precise time calculations
  /// (events, deadlines)
  /// - `ignoreDaylightSavings: true` for calendar operations
  /// (recurring appointments)
  ///
  /// ```dart
  /// // During DST transition (March 26, 2023 in Europe)
  /// final date = DateTime(2023, 3, 25, 14, 30);
  ///
  /// // With DST consideration - time may shift
  /// final withDST = date.addDays(1); // March 26, 15:30 (1 hour lost)
  ///
  /// // Ignoring DST - maintains local time
  /// final ignoreDST = date.addDays(1, ignoreDaylightSavings: true); // March 26, 14:30
  /// ```
  DateTime addDays(
    int amount, {
    bool ignoreDaylightSavings = false,
  }) =>
      ignoreDaylightSavings
          ? copyWith(day: day + amount)
          : add(Duration(days: amount));

  /// add [amount] hours to `this` DateTime.
  ///
  /// [ignoreDaylightSavings] is a flag to ignore daylight savings time
  /// default is `false`.
  ///
  /// More info about Daylight Saving Time
  /// (DST) and [ignoreDaylightSavings] in [addDays].
  DateTime addHours(
    int amount, {
    bool ignoreDaylightSavings = false,
  }) =>
      ignoreDaylightSavings
          ? copyWith(hour: hour + amount)
          : add(Duration(hours: amount));

  /// add [amount] minutes to `this` DateTime.
  ///
  /// [ignoreDaylightSavings] is a flag to ignore daylight savings time
  /// default is `false`.
  ///
  /// More info about Daylight Saving Time
  /// (DST) and [ignoreDaylightSavings] in [addDays].
  DateTime addMinutes(
    int amount, {
    bool ignoreDaylightSavings = false,
  }) =>
      ignoreDaylightSavings
          ? copyWith(minute: minute + amount)
          : add(Duration(minutes: amount));

  /// add [amount] seconds to `this` DateTime.
  ///
  /// [ignoreDaylightSavings] is a flag to ignore daylight savings time
  /// default is `false`.
  ///
  /// More info about Daylight Saving Time
  /// (DST) and [ignoreDaylightSavings] in [addDays].
  DateTime addSeconds(
    int amount, {
    bool ignoreDaylightSavings = false,
  }) =>
      ignoreDaylightSavings
          ? copyWith(second: second + amount)
          : add(Duration(seconds: amount));

  /// add [amount] milliseconds to `this` DateTime.
  ///
  /// [ignoreDaylightSavings] is a flag to ignore daylight savings time
  /// default is `false`.
  ///
  /// More info about Daylight Saving Time
  /// (DST) and [ignoreDaylightSavings] in [addDays].
  DateTime addMilliseconds(
    int amount, {
    bool ignoreDaylightSavings = false,
  }) =>
      ignoreDaylightSavings
          ? copyWith(millisecond: millisecond + amount)
          : add(Duration(milliseconds: amount));

  /// add [amount] microseconds to `this` DateTime.
  ///
  /// [ignoreDaylightSavings] is a flag to ignore daylight savings time
  /// default is `false`.
  ///
  /// More info about Daylight Saving Time
  /// (DST) and [ignoreDaylightSavings] in [addDays].
  DateTime addMicroseconds(
    int amount, {
    bool ignoreDaylightSavings = false,
  }) =>
      ignoreDaylightSavings
          ? copyWith(microsecond: microsecond + amount)
          : add(Duration(microseconds: amount));

  /// subtract [amount] years from `this` DateTime.
  /// (Same as [addYears] with negative amount)
  DateTime subYears(int amount) => addYears(-amount);

  /// subtract [amount] months from `this` DateTime.
  /// (Same as [addMonths] with negative amount)
  DateTime subMonths(int amount) => addMonths(-amount);

  /// subtract [amount] hours from `this` DateTime.
  /// (Same as [addHours] with negative amount)
  ///
  /// [ignoreDaylightSavings] is a flag to ignore daylight savings time
  /// default is `false`.
  ///
  /// More info about Daylight Saving Time
  /// (DST) and [ignoreDaylightSavings] in [addDays].
  DateTime subHours(
    int amount, {
    bool ignoreDaylightSavings = false,
  }) =>
      addHours(-amount, ignoreDaylightSavings: ignoreDaylightSavings);

  /// subtract [amount] days from `this` DateTime.
  /// (Same as [addDays] with negative amount)
  ///
  /// [ignoreDaylightSavings] is a flag to ignore daylight savings time
  /// default is `false`.
  ///
  /// More info about Daylight Saving Time
  /// (DST) and [ignoreDaylightSavings] in [addDays].
  DateTime subDays(
    int amount, {
    bool ignoreDaylightSavings = false,
  }) =>
      addDays(-amount, ignoreDaylightSavings: ignoreDaylightSavings);

  /// subtract [amount] minutes from `this` DateTime.
  /// (Same as [addMinutes] with negative amount)
  ///
  /// [ignoreDaylightSavings] is a flag to ignore daylight savings time
  /// default is `false`.
  ///
  /// More info about Daylight Saving Time
  /// (DST) and [ignoreDaylightSavings] in [addDays].
  DateTime subMinutes(
    int amount, {
    bool ignoreDaylightSavings = false,
  }) =>
      addMinutes(-amount, ignoreDaylightSavings: ignoreDaylightSavings);

  /// subtract [amount] seconds from `this` DateTime.
  /// (Same as [addSeconds] with negative amount)
  ///
  /// [ignoreDaylightSavings] is a flag to ignore daylight savings time
  /// default is `false`.
  ///
  /// More info about Daylight Saving Time
  /// (DST) and [ignoreDaylightSavings] in [addDays].
  DateTime subSeconds(
    int amount, {
    bool ignoreDaylightSavings = false,
  }) =>
      addSeconds(-amount, ignoreDaylightSavings: ignoreDaylightSavings);

  /// subtract [amount] milliseconds from `this` DateTime.
  /// (Same as [addMilliseconds] with negative amount)
  ///
  /// [ignoreDaylightSavings] is a flag to ignore daylight savings time
  /// default is `false`.
  ///
  /// More info about Daylight Saving Time
  /// (DST) and [ignoreDaylightSavings] in [addDays].
  DateTime subMilliseconds(
    int amount, {
    bool ignoreDaylightSavings = false,
  }) =>
      addMilliseconds(-amount, ignoreDaylightSavings: ignoreDaylightSavings);

  /// subtract [amount] microseconds from `this` DateTime.
  /// (Same as [addMicroseconds] with negative amount)
  ///
  /// [ignoreDaylightSavings] is a flag to ignore daylight savings time
  /// default is `false`.
  ///
  /// More info about Daylight Saving Time
  /// (DST) and [ignoreDaylightSavings] in [addDays].
  DateTime subMicroseconds(
    int amount, {
    bool ignoreDaylightSavings = false,
  }) =>
      addMicroseconds(-amount, ignoreDaylightSavings: ignoreDaylightSavings);

  /// get the [ClockTime] of `this` DateTime.
  ClockTime get clockTime => ClockTime(
        hour,
        minute: minute,
        second: second,
        millisecond: millisecond,
        microsecond: microsecond,
      );
}

extension _GranularityExt on TimeGranularity {
  /// apply the granularity to [time]
  /// setting fields lower than the granularity to 0
  DateTime _apply(DateTime time) {
    return map<DateTime>(
      year: () => time.copyWith(
        month: 0,
        day: 0,
        hour: 0,
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      ),
      month: () => time.copyWith(
        day: 0,
        hour: 0,
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      ),
      day: () => time.copyWith(
        hour: 0,
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      ),
      hour: () => time.copyWith(
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      ),
      minute: () => time.copyWith(
        second: 0,
        millisecond: 0,
        microsecond: 0,
      ),
      second: () => time.copyWith(
        millisecond: 0,
        microsecond: 0,
      ),
      milliseconds: () => time.copyWith(
        microsecond: 0,
      ),
      microseconds: () => time.copyWith(
        microsecond: 0,
      ),
    );
  }
}

import 'package:dart_time/dart_time.dart';

/// [DateTimeHelper] contains the helper methods for [DateTime].
extension DateTimeHelper on DateTime {
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
      second ?? 0,
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
        second ?? this.second,
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

  /// get the end of the year
  DateTime get endOfYear => copyWith(
        month: 12,
        day: 31,
        hour: 23,
        minute: 59,
        second: 59,
      );

  /// get the end of the month
  DateTime get endOfMonth {
    // Get the first day of the next month, then subtract 1 day to get the last day of current month
    final nextMonth = month == 12
        ? DateTimeHelper.named(year: year + 1, month: 1, day: 1)
        : DateTimeHelper.named(year: year, month: month + 1, day: 1);
    final lastDayOfMonth = nextMonth.subtract(const Duration(days: 1));
    return copyWith(
      day: lastDayOfMonth.day,
      hour: 23,
      minute: 59,
      second: 59,
      millisecond: 999,
      microsecond: 999,
    );
  }

  /// get the end of the day
  DateTime get endOfDay => copyWith(
        hour: 23,
        minute: 59,
        second: 59,
      );

  /// get the end of the hour
  DateTime get endOfHour => copyWith(
        minute: 59,
        second: 59,
      );

  /// get the end of the minute
  DateTime get endOfMinute => copyWith(
        second: 59,
      );

  /// get the end of the second
  DateTime get endOfSecond => copyWith(
        millisecond: 999,
      );

  /// get the next day
  DateTime get nextDay => addDays(1);

  /// get the previous day
  DateTime get previousDay => addDays(-1);

  /// check if [other] is the same as `this`
  ///
  /// [granularity] is the granularity of the comparison,
  /// default is [TimeGranularity.microseconds]
  bool isGranularSame(
    DateTime other, [
    TimeGranularity granularity = TimeGranularity.microseconds,
  ]) {
    return granularity._apply(this).isAtSameMomentAs(granularity._apply(other));
  }

  /// check if `this` is the same year as [other]
  ///
  /// (shortcut for [isGranularSame] with [TimeGranularity.year])
  bool isSameYear(DateTime other) =>
      isGranularSame(other, TimeGranularity.year);

  /// check if `this` is the same month as [other]
  ///
  /// (shortcut for [isGranularSame] with [TimeGranularity.month])
  bool isSameMonth(DateTime other) =>
      isGranularSame(other, TimeGranularity.month);

  /// check if `this` is the same day as [other]
  ///
  /// (shortcut for [isGranularSame] with [TimeGranularity.day])
  bool isSameDay(DateTime other) => isGranularSame(other, TimeGranularity.day);

  /// check if `this` is the same hour as [other]
  ///
  /// (shortcut for [isGranularSame] with [TimeGranularity.hour])
  bool isSameHour(DateTime other) =>
      isGranularSame(other, TimeGranularity.hour);

  /// check if `this` is the same minute as [other]
  ///
  /// (shortcut for [isGranularSame] with [TimeGranularity.minute])
  bool isSameMinute(DateTime other) =>
      isGranularSame(other, TimeGranularity.minute);

  /// check if `this` is in the same week as [other]
  ///
  /// [firstDayOfWeek] determines which day starts the week.
  /// Default is [DateTime.monday] (ISO 8601 standard).
  ///
  /// Example:
  /// ```dart
  /// final monday = DateTime(2023, 6, 5); // Monday
  /// final friday = DateTime(2023, 6, 9); // Friday same week
  /// final nextMonday = DateTime(2023, 6, 12); // Monday next week
  ///
  /// monday.isSameWeek(friday); // true
  /// monday.isSameWeek(nextMonday); // false
  /// ```
  bool isSameWeek(DateTime other, [int firstDayOfWeek = DateTime.monday]) {
    final thisWeekStart = _getWeekStart(firstDayOfWeek);
    final otherWeekStart = other._getWeekStart(firstDayOfWeek);
    return thisWeekStart.isSameDay(otherWeekStart);
  }

  /// Get the week number of the year according to ISO 8601 standard.
  ///
  /// Returns a value between 1 and 53. Week 1 is the first week that contains
  /// at least 4 days of the new year.
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime(2023, 6, 15);
  /// print(date.weekOfYear); // 24
  /// ```
  int get isoWeekOfYear {
    // ISO 8601 week calculation
    final jan4 = DateTime(year, 1, 4);
    final yearStart = jan4._getWeekStart(DateTime.monday);
    final daysDifference = difference(yearStart).inDays;
    final weekNumber = (daysDifference / 7).floor() + 1;

    // If week number is 0 or negative, it belongs to previous year
    if (weekNumber <= 0) {
      // Calculate week number for previous year's last week
      final prevYear = year - 1;
      final prevJan4 = DateTime(prevYear, 1, 4);
      final prevYearStart = prevJan4._getWeekStart(DateTime.monday);
      final dec31PrevYear = DateTime(prevYear, 12, 31);
      return ((dec31PrevYear.difference(prevYearStart).inDays) / 7).floor() + 1;
    }

    // If week number is > 52/53, check if it belongs to next year
    final dec28 = DateTime(year, 12, 28);
    final dec28WeekNumber =
        ((dec28.difference(yearStart).inDays) / 7).floor() + 1;

    if (weekNumber > dec28WeekNumber) {
      return 1; // Belongs to next year's week 1
    }

    return weekNumber;
  }

  /// check if the year of `this` DateTime is a leap year
  ///
  /// A leap year occurs every 4 years, except for years divisible by 100,
  /// unless they are also divisible by 400.
  ///
  /// Example:
  /// ```dart
  /// DateTime(2020, 1, 1).isLeapYear; // true (divisible by 4)
  /// DateTime(1900, 1, 1).isLeapYear; // false (divisible by 100, not 400)
  /// DateTime(2000, 1, 1).isLeapYear; // true (divisible by 400)
  /// ```
  bool get isLeapYear =>
      (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));

  /// Get the quarter (1-4) of this date
  ///
  /// Returns:
  /// - 1 for January-March
  /// - 2 for April-June
  /// - 3 for July-September
  /// - 4 for October-December
  ///
  /// Example:
  /// ```dart
  /// DateTime(2023, 3, 15).quarter; // 1
  /// DateTime(2023, 7, 1).quarter;  // 3
  /// ```
  int get quarter => ((month - 1) ~/ 3) + 1;

  /// Get the start of the quarter for this date
  ///
  /// Returns the first day of the quarter at 00:00:00.000
  ///
  /// Example:
  /// ```dart
  /// DateTime(2023, 7, 15).startOfQuarter; // 2023-07-01 00:00:00.000
  /// DateTime(2023, 11, 20).startOfQuarter; // 2023-10-01 00:00:00.000
  /// ```
  DateTime get startOfQuarter => copyWith(
        month: ((quarter - 1) * 3) + 1,
        day: 1,
        hour: 0,
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      );

  /// Get the end of the quarter for this date
  ///
  /// Returns the last day of the quarter at 23:59:59.999
  ///
  /// Example:
  /// ```dart
  /// DateTime(2023, 7, 15).endOfQuarter; // 2023-09-30 23:59:59.999
  /// DateTime(2023, 11, 20).endOfQuarter; // 2023-12-31 23:59:59.999
  /// ```
  DateTime get endOfQuarter {
    final nextQuarterStart = startOfQuarter.addMonths(3);
    return nextQuarterStart.subtract(const Duration(milliseconds: 1));
  }

  /// check if `this` is in the same quarter as [other]
  ///
  /// Two dates are in the same quarter if they have the same quarter
  /// number and the same year.
  ///
  /// Example:
  /// ```dart
  /// final jan = DateTime(2023, 1, 15);
  /// final mar = DateTime(2023, 3, 20);
  /// final jul = DateTime(2023, 7, 10);
  ///
  /// jan.isSameQuarter(mar); // true (both Q1 2023)
  /// jan.isSameQuarter(jul); // false (Q1 vs Q3)
  /// ```
  bool isSameQuarter(DateTime other) =>
      quarter == other.quarter && year == other.year;

  /// Get the number of days in this year
  ///
  /// Returns 366 for leap years, 365 for regular years.
  ///
  /// Example:
  /// ```dart
  /// DateTime(2020, 6, 15).daysInYear; // 366 (leap year)
  /// DateTime(2021, 6, 15).daysInYear; // 365 (regular year)
  /// ```
  int get daysInYear => isLeapYear ? 366 : 365;

  /// Get the number of days in this month
  ///
  /// Returns the correct number of days for each month, accounting for leap years.
  ///
  /// Example:
  /// ```dart
  /// DateTime(2023, 2, 15).daysInMonth; // 28 (non-leap year)
  /// DateTime(2020, 2, 15).daysInMonth; // 29 (leap year)
  /// DateTime(2023, 4, 15).daysInMonth; // 30 (April)
  /// DateTime(2023, 1, 15).daysInMonth; // 31 (January)
  /// ```
  int get daysInMonth {
    // Get the first day of the next month, then subtract to get last day of current month
    final nextMonth =
        month == 12 ? DateTime(year + 1, 1, 1) : DateTime(year, month + 1, 1);
    final lastDayOfMonth = nextMonth.subtract(const Duration(days: 1));
    return lastDayOfMonth.day;
  }

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

  /// Get the start of the week for this date
  DateTime _getWeekStart(int firstDayOfWeek) {
    final daysSinceWeekStart = (weekday - firstDayOfWeek) % 7;
    return subtract(Duration(days: daysSinceWeekStart)).startOfDay;
  }
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

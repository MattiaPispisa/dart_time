# Dart Time

[![dart_time_badge][dart_time_badge]][pub_link]
[![pub points][pub_points]][pub_link]
[![pub likes][pub_likes]][pub_link]
[![codecov][codecov_badge]][codecov_link]
[![ci_badge][ci_badge]][ci_link]
[![License: MIT][license_badge]][license_link]
[![pub publisher][pub_publisher]][pub_publisher_link]
[![style: very good analysis][badge_very_good_analysis]][badge_very_good_analysis_link]

- [Dart Time](#dart-time)
  - [Features](#features)
  - [Installation](#installation)
  - [Usage](#usage)
  - [API Reference](#api-reference)
    - [Extensions](#extensions)
      - [`DateTimeHelper` - Extended DateTime functionality](#datetimehelper---extended-datetime-functionality)
      - [`DurationHelper` - Extended Duration functionality](#durationhelper---extended-duration-functionality)
      - [`IntDurationHelper` - Integer to Duration conversion](#intdurationhelper---integer-to-duration-conversion)
      - [`DoubleDurationHelper` - Fractional Duration creation](#doubledurationhelper---fractional-duration-creation)
    - [Classes](#classes)
      - [`ClockTime` - Time-of-day representation](#clocktime---time-of-day-representation)
      - [`ClockTimeRange` - Clock Time range representation](#clocktimerange---clock-time-range-representation)
      - [`DartDateRange` - Date range representation](#dartdaterange---date-range-representation)
      - [`ISODuration` - ISO 8601 duration representation](#isoduration---iso-8601-duration-representation)
      - [`TimeGranularity` - Time comparison granularity](#timegranularity---time-comparison-granularity)


A comprehensive Dart library for advanced time and date manipulation. This library extends Dart's built-in `DateTime` and `Duration` classes with powerful utilities and introduces new classes for specialized time operations.

## Features

- **Extended DateTime**: Rich collection of methods for date manipulation, comparison, and formatting
- **Extended Duration**: Additional utilities for duration operations and conversions
- **Time-only Operations**: `ClockTime` class for working with time of day without dates
- **Date Ranges**: `DartDateRange` class for representing and working with date intervals
- **Time Ranges**: `ClockTimeRange` class for time-of-day intervals
- **ISO 8601 Support**: Full support for ISO duration parsing and formatting
- **Time Granularity**: Precise control over time comparison granularity
- **DST Handling**: Configurable Daylight Saving Time behavior
- **Comprehensive Testing**: 100% test coverage with extensive edge case handling

## Installation

**❗ In order to start using Dart Time you must have the [Dart SDK][dart_install_link] installed on your machine.**

Install via `dart pub add`:

```sh
dart pub add dart_time
```

## Usage

```dart
import 'package:dart_time/dart_time.dart';

// DateTime extensions
final date = DateTime(2023, 6, 15);
final nextMonth = date.addMonths(1);
final startOfDay = date.startOfDay;
final isLeap = date.isLeapYear;

// Duration extensions
final duration = 2.5.fractionalHours; // 2 hours 30 minutes
final formatted = duration.hhmmss; // "02:30:00"

// ClockTime for time-only operations
final time = ClockTime(14, minute: 30); // 2:30 PM
final timeRange = ClockTimeRange(start: ClockTime(9), end: ClockTime(17));

// Date ranges
final range = DartDateRange(start: DateTime(2023, 1, 1), end: DateTime(2023, 12, 31));
final days = range.dates.toList(); // All days in the year
```

## API Reference

### Extensions

#### `DateTimeHelper` - Extended DateTime functionality
*Extends Dart's `DateTime` class with comprehensive date manipulation and utility methods.*

**Static Methods:**
- `static DateTime named` - Create DateTime with named parameters

**Date/Time Boundaries:**
- `DateTime get startOfYear` - Get start of the year (Jan 1, 00:00:00)
- `DateTime get startOfMonth` - Get start of the month (1st day, 00:00:00)
- `DateTime get startOfDay` - Get start of the day (00:00:00)
- `DateTime get startOfHour` - Get start of the hour (:00:00)
- `DateTime get startOfMinute` - Get start of the minute (:00)
- `DateTime get startOfSecond` - Get start of the second (.000)
- `DateTime get endOfYear` - Get end of the year (Dec 31, 23:59:59)
- `DateTime get endOfMonth` - Get end of the month (last day, 23:59:59)
- `DateTime get endOfDay` - Get end of the day (23:59:59)
- `DateTime get endOfHour` - Get end of the hour (:59:59)
- `DateTime get endOfMinute` - Get end of the minute (:59)
- `DateTime get endOfSecond` - Get end of the second (.999)

**Navigation:**
- `DateTime get nextDay` - Get next day
- `DateTime get previousDay` - Get previous day

**Quarters:**
- `int get quarter` - Get quarter (1-4)
- `DateTime get startOfQuarter` - Get start of the quarter
- `DateTime get endOfQuarter` - Get end of the quarter
- `bool isSameQuarter(DateTime other)` - Check if same quarter

**Leap Year & Calendar:**
- `bool get isLeapYear` - Check if year is leap year
- `int get daysInYear` - Get number of days in year (365/366)
- `int get daysInMonth` - Get number of days in current month

**Week Operations:**
- `bool isSameWeek(DateTime other, [int firstDayOfWeek])` - Check if same week
- `int get isoWeekOfYear` - Get ISO 8601 week number

**Copy Methods:**
- `DateTime copyWith({int? year, int? month, int? day, int? hour, int? minute, int? second, int? millisecond, int? microsecond})` - Copy with new values
- `DateTime copyTime(ClockTime time)` - Copy with new time

**Granular Comparisons:**
- `bool isGranularSame(DateTime other, [TimeGranularity granularity])` - Compare with specific granularity
- `bool isSameYear(DateTime other)` - Check if same year
- `bool isSameMonth(DateTime other)` - Check if same month
- `bool isSameDay(DateTime other)` - Check if same day
- `bool isSameHour(DateTime other)` - Check if same hour
- `bool isSameMinute(DateTime other)` - Check if same minute

**Advanced Comparisons:**
- `bool isSameOrAfter(DateTime other, [TimeGranularity granularity])` - Check if same or after
- `bool isSameOrBefore(DateTime other, [TimeGranularity granularity])` - Check if same or before
- `bool isGranularAfter(DateTime other, [TimeGranularity granularity])` - Check if after with granularity
- `bool isGranularBefore(DateTime other, [TimeGranularity granularity])` - Check if before with granularity

**Arithmetic Operations:**
- `DateTime addYears(int amount)` - Add years
- `DateTime addMonths(int amount)` - Add months
- `DateTime addDays(int amount, {bool ignoreDaylightSavings})` - Add days with DST control
- `DateTime addHours(int amount, {bool ignoreDaylightSavings})` - Add hours with DST control
- `DateTime addMinutes(int amount, {bool ignoreDaylightSavings})` - Add minutes with DST control
- `DateTime addSeconds(int amount, {bool ignoreDaylightSavings})` - Add seconds with DST control
- `DateTime addMilliseconds(int amount, {bool ignoreDaylightSavings})` - Add milliseconds with DST control
- `DateTime addMicroseconds(int amount, {bool ignoreDaylightSavings})` - Add microseconds with DST control
- `DateTime subYears(int amount)` - Subtract years
- `DateTime subMonths(int amount)` - Subtract months
- `DateTime subDays(int amount, {bool ignoreDaylightSavings})` - Subtract days with DST control
- `DateTime subHours(int amount, {bool ignoreDaylightSavings})` - Subtract hours with DST control
- `DateTime subMinutes(int amount, {bool ignoreDaylightSavings})` - Subtract minutes with DST control
- `DateTime subSeconds(int amount, {bool ignoreDaylightSavings})` - Subtract seconds with DST control
- `DateTime subMilliseconds(int amount, {bool ignoreDaylightSavings})` - Subtract milliseconds with DST control
- `DateTime subMicroseconds(int amount, {bool ignoreDaylightSavings})` - Subtract microseconds with DST control

**Conversion:**
- `ClockTime get clockTime` - Convert to ClockTime

**Operators:**
- `bool operator <(DateTime other)` - Less than
- `bool operator <=(DateTime other)` - Less than or equal
- `bool operator >(DateTime other)` - Greater than
- `bool operator >=(DateTime other)` - Greater than or equal
- `DateTime operator -(Duration other)` - Subtract duration
- `DateTime operator +(Duration other)` - Add duration

#### `DurationHelper` - Extended Duration functionality
*Extends Dart's `Duration` class with additional utilities and formatting options.*

**Static Methods:**
- `static Duration parseISO(String iso8601String)` - Parse ISO 8601 duration string

**Validation:**
- `bool get isZero` - Check if duration is zero
- `bool get isPositive` - Check if duration is positive
- `bool get isNegative` - Check if duration is negative
- `Duration get absDuration` - Get absolute duration

**Additional Units:**
- `double get inWeeks` - Get duration in weeks (fractional)
- `double get inFractionalHours` - Get duration in fractional hours
- `double get inFractionalMinutes` - Get duration in fractional minutes

**Formatting:**
- `String get hhmmss` - Format as HH:MM:SS
- `String get hhmmssmmm` - Format as HH:MM:SS.mmm

**Rounding:**
- `Duration roundToMinute()` - Round to nearest minute
- `Duration roundToHour()` - Round to nearest hour
- `Duration roundToDay()` - Round to nearest day

**Comparison:**
- `bool isLongerThan(Duration other)` - Check if longer than other
- `bool isShorterThan(Duration other)` - Check if shorter than other
- `Duration max(Duration other)` - Get maximum duration
- `Duration min(Duration other)` - Get minimum duration

**Conversion:**
- `ISODuration toIsoDuration()` - Convert to ISO duration
- `String toIsoString()` - Convert to ISO string

#### `IntDurationHelper` - Integer to Duration conversion
*Extends `int` to provide convenient duration creation methods.*

**Duration Creation:**
- `Duration get days` - Create duration in days
- `Duration get hours` - Create duration in hours
- `Duration get minutes` - Create duration in minutes
- `Duration get seconds` - Create duration in seconds
- `Duration get milliseconds` - Create duration in milliseconds
- `Duration get microseconds` - Create duration in microseconds
- `Duration get weeks` - Create duration in weeks

#### `DoubleDurationHelper` - Fractional Duration creation
*Extends `double` to provide fractional duration creation methods.*

**Fractional Duration Creation:**
- `Duration get fractionalHours` - Create fractional hours duration
- `Duration get fractionalMinutes` - Create fractional minutes duration
- `Duration get fractionalSeconds` - Create fractional seconds duration
- `Duration get fractionalDays` - Create fractional days duration

### Classes

#### `ClockTime` - Time-of-day representation
*Represents a time of day (hours, minutes, seconds) without date information.*

**Constructors:**
- `ClockTime(int hour, {int minute, int second, int millisecond, int microsecond})` - Create with hour and optional components
- `ClockTime.now()` - Create from current time
- `ClockTime.midnight()` - Create midnight (00:00:00)
- `ClockTime.noon()` - Create noon (12:00:00)
- `ClockTime.parse(String timeString)` - Parse time string (HH:mm:ss)
- `ClockTime.parse12Hour(String timeString)` - Parse 12-hour format with AM/PM
- `ClockTime.fromJson(Map<String, dynamic> json)` - Create from JSON

**Properties:**
- `int hour` - Hour component (0-23)
- `int minute` - Minute component (0-59)
- `int second` - Second component (0-59)
- `int millisecond` - Millisecond component (0-999)
- `int microsecond` - Microsecond component (0-999)

**Time Classification:**
- `bool get isMorning` - Check if morning (6:00-11:59)
- `bool get isAfternoon` - Check if afternoon (12:00-17:59)
- `bool get isEvening` - Check if evening (18:00-21:59)
- `bool get isNight` - Check if night (22:00-5:59)
- `bool get isAM` - Check if AM period
- `bool get isPM` - Check if PM period
- `String get period` - Get period string ("AM"/"PM")

**Formatting:**
- `String get format12Hour` - Format as 12-hour time
- `String get format24Hour` - Format as 24-hour time
- `String get formatWithSeconds` - Format with seconds included

**Calculations:**
- `int get minutesSinceMidnight` - Minutes since midnight
- `int get secondsSinceMidnight` - Seconds since midnight
- `int get minutesUntilMidnight` - Minutes until next midnight

**Arithmetic:**
- `ClockTime add(Duration duration)` - Add duration with 24-hour wrap
- `ClockTime subtract(Duration duration)` - Subtract duration with 24-hour wrap
- `ClockTime addHours(int hours)` - Add hours with wrap-around
- `ClockTime addMinutes(int minutes)` - Add minutes with wrap-around
- `ClockTime addSeconds(int seconds)` - Add seconds with wrap-around

**Copy & Conversion:**
- `ClockTime copyWith({int? hour, int? minute, int? second, int? millisecond, int? microsecond})` - Copy with new values
- `Duration toDuration()` - Convert to Duration since midnight
- `Map<String, dynamic> toJson()` - Convert to JSON

**Comparison:**
- `bool isAtSameTimeAs(ClockTime other)` - Check if same time
- `bool isAfter(ClockTime other)` - Check if after other
- `bool isBefore(ClockTime other)` - Check if before other
- `bool isSameOrAfter(ClockTime other)` - Check if same or after
- `bool isSameOrBefore(ClockTime other)` - Check if same or before

**Operators:**
- `bool operator <(ClockTime other)` - Less than
- `bool operator <=(ClockTime other)` - Less than or equal
- `bool operator >(ClockTime other)` - Greater than
- `bool operator >=(ClockTime other)` - Greater than or equal
- `Duration operator -(ClockTime other)` - Difference between times
- `Duration operator +(ClockTime other)` - Sum of times

#### `ClockTimeRange` - Clock Time range representation
*Represents a range between two times of day.*

**Constructors:**
- `ClockTimeRange({required ClockTime start, required ClockTime end})` - Create time range

**Properties:**
- `ClockTime start` - Start time
- `ClockTime end` - End time

**Operations:**
- `bool includes(DateTime dateTime)` - Check if DateTime's time falls within range

**Standard Methods:**
- `String toString()` - String representation
- `bool operator ==(Object other)` - Equality comparison
- `int get hashCode` - Hash code

#### `DartDateRange` - Date range representation
*Represents a range between two dates with comprehensive operations.*

**Constructors:**
- `DartDateRange({required DateTime start, required DateTime end})` - Create date range
- `DartDateRange.day(DateTime date)` - Create single-day range
- `DartDateRange.fromJson(Map<String, dynamic> json)` - Create from JSON

**Properties:**
- `DateTime start` - Start date
- `DateTime end` - End date
- `Duration duration` - Duration of the range
- `bool isMultiDay` - Check if spans multiple days
- `bool isSingleDay` - Check if single day

**Range Operations:**
- `bool includes(DateTime date)` - Check if date is within range
- `bool cross(DartDateRange other)` - Check if ranges overlap
- `bool contains(DartDateRange other)` - Check if contains other range

**Iteration:**
- `Iterable<DateTime> get dates` - Iterate through all dates in range
- `Iterable<DateTime> step(Duration step)` - Iterate with custom step

**Manipulation:**
- `DartDateRange extend({Duration? before, Duration? after})` - Extend range
- `DartDateRange copyWith({DateTime? start, DateTime? end})` - Copy with new values

**Conversion:**
- `Map<String, dynamic> toJson()` - Convert to JSON

**Standard Methods:**
- `String toString()` - String representation
- `bool operator ==(Object other)` - Equality comparison
- `int get hashCode` - Hash code

#### `ISODuration` - ISO 8601 duration representation
*Represents durations in ISO 8601 format with full parsing and formatting support.*

**Constructors:**
- `ISODuration({int years, int months, int weeks, int days, int hours, int minutes, int seconds})` - Create with components
- `ISODuration.parse(String iso8601String)` - Parse ISO 8601 string
- `ISODuration.tryParse(String iso8601String)` - Try parse, return null if invalid
- `ISODuration.fromJson(Map<String, dynamic> json)` - Create from JSON

**Properties:**
- `int years` - Years component
- `int months` - Months component
- `int weeks` - Weeks component
- `int days` - Days component
- `int hours` - Hours component
- `int minutes` - Minutes component
- `int seconds` - Seconds component

**Conversion:**
- `String toIso()` - Convert to ISO 8601 string
- `Duration toDuration()` - Convert to Dart Duration (approximated)
- `Map<String, dynamic> toJson()` - Convert to JSON

**Copy:**
- `ISODuration copyWith({int? years, int? months, int? weeks, int? days, int? hours, int? minutes, int? seconds})` - Copy with new values

**Standard Methods:**
- `String toString()` - String representation
- `bool operator ==(Object other)` - Equality comparison
- `int get hashCode` - Hash code

#### `TimeGranularity` - Time comparison granularity
*Enum for specifying precision levels in time comparisons.*

**Values:**
- `TimeGranularity.year` - Year level precision
- `TimeGranularity.month` - Month level precision
- `TimeGranularity.day` - Day level precision
- `TimeGranularity.hour` - Hour level precision
- `TimeGranularity.minute` - Minute level precision
- `TimeGranularity.second` - Second level precision
- `TimeGranularity.milliseconds` - Millisecond level precision
- `TimeGranularity.microseconds` - Microsecond level precision

**Methods:**
- `bool get isYear` - Check if year granularity
- `bool get isMonth` - Check if month granularity
- `bool get isDay` - Check if day granularity
- `bool get isHour` - Check if hour granularity
- `bool get isMinute` - Check if minute granularity
- `bool get isSecond` - Check if second granularity
- `bool get isMilliseconds` - Check if milliseconds granularity
- `bool get isMicroseconds` - Check if microseconds granularity
- `T map<T>({required T year, required T month, required T day, required T hour, required T minute, required T second, required T milliseconds, required T microseconds})` - Map to different values based on granularity

---

[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[dart_time_badge]: https://img.shields.io/pub/v/dart_time.svg
[codecov_badge]: https://img.shields.io/codecov/c/github/MattiaPispisa/dart_time/main?logo=codecov
[codecov_link]: https://app.codecov.io/gh/MattiaPispisa/dart_time/tree/main
[ci_badge]: https://img.shields.io/github/actions/workflow/status/MattiaPispisa/dart_time/main.yaml
[ci_link]: https://github.com/MattiaPispisa/dart_time/actions/workflows/main.yaml
[pub_points]: https://img.shields.io/pub/points/dart_time
[pub_link]: https://pub.dev/packages/dart_time
[pub_publisher]: https://img.shields.io/pub/publisher/dart_time
[pub_publisher_link]: https://pub.dev/packages?q=publisher%3Amattiapispisa.it
[pub_likes]: https://img.shields.io/pub/likes/dart_time
[badge_very_good_analysis]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[badge_very_good_analysis_link]: https://pub.dev/packages/very_good_analysis

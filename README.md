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
  - [What's Included](#whats-included)
    - [🔧 **Extensions**](#-extensions)
    - [📅 **Specialized Classes**](#-specialized-classes)
    - [✨ **Key Features**](#-key-features)
  - [Installation](#installation)
  - [Usage](#usage)
  - [API Quick Reference](#api-quick-reference)
    - [🔧 Extensions](#-extensions-1)
      - [`DateTimeHelper` - Enhanced DateTime](#datetimehelper---enhanced-datetime)
      - [`DurationHelper` - Enhanced Duration](#durationhelper---enhanced-duration)
      - [`IntDurationHelper` \& `DoubleDurationHelper`](#intdurationhelper--doubledurationhelper)
    - [📅 Classes](#-classes)
      - [`ClockTime` - Time without Date](#clocktime---time-without-date)
      - [`ClockTimeRange` - Time Ranges](#clocktimerange---time-ranges)
      - [`DartDateRange` - Date Ranges](#dartdaterange---date-ranges)
      - [`ISODuration` - ISO 8601 Durations](#isoduration---iso-8601-durations)
    - [🎯 TimeGranularity Enum](#-timegranularity-enum)


A comprehensive Dart library that extends and enhances Dart's built-in time functionality. This library provides powerful extensions to `DateTime` and `Duration`, plus specialized classes for advanced time operations.

## What's Included

### 🔧 **Extensions**
Enhance existing Dart types with additional functionality:

- **`DateTimeHelper`** - Extends `DateTime` with 50+ methods for date manipulation, boundary calculations, granular comparisons, and DST-aware arithmetic
- **`DurationHelper`** - Extends `Duration` with formatting, validation, rounding, and ISO 8601 conversion
- **`IntDurationHelper`** - Extends `int` to create durations easily (e.g., `5.days`, `30.minutes`)
- **`DoubleDurationHelper`** - Extends `double` for fractional durations (e.g., `2.5.fractionalHours`)

### 📅 **Specialized Classes**
New types for specific time-related operations:

- **`ClockTime`** - Represents time-of-day (14:30:45) without date information, with 12/24-hour formatting and time-period detection
- **`ClockTimeRange`** - Represents time ranges for schedule management and time-based filtering
- **`DartDateRange`** - Powerful date range operations with iteration, overlap detection, and boundary calculations
- **`ISODuration`** - Full ISO 8601 duration support with positive/negative durations and component-based operations

### ✨ **Key Features**

- **DST-Aware Operations**: Handle Daylight Saving Time transitions correctly
- **Granular Time Comparisons**: Compare dates/times at different precision levels (year, month, day, hour, etc.)
- **ISO 8601 Compliance**: Full standard support for durations and week numbering
- **Flexible Formatting**: Multiple output formats for different use cases
- **Comprehensive Range Operations**: Overlap detection, intersection, iteration through time periods
- **Type Safety**: Immutable objects with clear APIs and extensive validation

## Installation

**❗ In order to start using Dart Time you must have the [Dart SDK][dart_install_link] installed on your machine.**

Install via `dart pub add`:

```sh
dart pub add dart_time
```

## Usage

```dart
import 'package:dart_time/dart_time.dart';

void main() {
  // 🔧 DateTime Extensions - Enhanced date manipulation
  final date = DateTime(2023, 6, 15, 14, 30);
  
  print(date.startOfDay);        // 2023-06-15 00:00:00.000
  print(date.endOfMonth);        // 2023-06-30 23:59:59.999
  print(date.addMonths(2));      // 2023-08-15 14:30:00.000
  print(date.quarter);           // 2 (second quarter)
  print(date.isLeapYear);        // false
  print(date.daysInMonth);       // 30
  
  // 🔧 Duration Extensions - Easy duration creation and formatting
  final duration = 2.5.fractionalHours;  // 2 hours 30 minutes
  print(duration.hhmmss);                 // "02:30:00"
  print(duration.inFractionalHours);      // 2.5
  print(90.minutes.roundToHour());        // 1 hour
  
  // 📅 ClockTime - Time-of-day operations without dates
  final meetingTime = ClockTime(14, minute: 30);  // 2:30 PM
  print(meetingTime.format12Hour);                 // "2:30 PM"
  print(meetingTime.isAfternoon);                  // true
  print(meetingTime.minutesSinceMidnight);         // 870
  
  final lunchBreak = ClockTimeRange(
    start: ClockTime(12),
    end: ClockTime(13),
  );
  
  // 📅 Date Ranges - Powerful range operations
  final quarter = DartDateRange(
    start: DateTime(2023, 7, 1),   // Q3 start
    end: DateTime(2023, 9, 30),    // Q3 end
  );
  
  print(quarter.duration.inDays);        // 92 days
  print(quarter.includes(DateTime(2023, 8, 15)));  // true
  
  // Iterate through all Mondays in the quarter
  final mondays = quarter.dates
    .where((date) => date.weekday == DateTime.monday)
    .toList();
  
  // 📅 ISO Duration - Standards-compliant duration handling
  final projectDuration = ISODuration.parse('P1Y2M15DT5H30M');
  print(projectDuration.years);          // 1
  print(projectDuration.months);         // 2
  print(projectDuration.days);           // 15
  print(projectDuration.toIso());        // "P1Y2M15DT5H30M"
  
  // Negative durations supported
  final timeAgo = ISODuration.parse('-P6M');  // 6 months ago
  print(timeAgo.isNegative);                  // true
}
```

## API Quick Reference

> 💡 **Tip**: For complete API documentation with all methods and parameters, see the [full documentation](#) or use your IDE's intellisense.

### 🔧 Extensions

#### `DateTimeHelper` - Enhanced DateTime
Extends `DateTime` with 50+ additional methods:

**Boundaries & Navigation**
```dart
date.startOfDay, date.endOfMonth, date.nextDay, date.previousDay
date.startOfQuarter, date.endOfYear, date.quarter
```

**Calendar Information**  
```dart
date.isLeapYear, date.daysInMonth, date.daysInYear
date.isoWeekOfYear, date.isSameWeek(other)
```

**DST-Aware Arithmetic**
```dart
date.addMonths(2), date.addDays(5, ignoreDaylightSavings: true)
date.subYears(1), date.addHours(3)
```

**Granular Comparisons**
```dart
date.isSameDay(other), date.isSameMonth(other)
date.isGranularAfter(other, TimeGranularity.hour)
```

#### `DurationHelper` - Enhanced Duration
Extends `Duration` with formatting and utilities:

```dart
duration.hhmmss              // "02:30:00"
duration.inFractionalHours   // 2.5
duration.roundToHour()       // Round to nearest hour
duration.isLongerThan(other) // Comparison
```

#### `IntDurationHelper` & `DoubleDurationHelper`
Easy duration creation from numbers:

```dart
5.days                  // Duration(days: 5)
30.minutes             // Duration(minutes: 30)  
2.5.fractionalHours    // 2 hours 30 minutes
```

### 📅 Classes

#### `ClockTime` - Time without Date
Represents time-of-day independently from dates:

```dart
ClockTime(14, minute: 30)         // 2:30 PM
ClockTime.parse("14:30:45")       // Parse time string
time.format12Hour                 // "2:30 PM"
time.isAfternoon                  // true
time.addHours(2)                  // 4:30 PM
```

#### `ClockTimeRange` - Time Ranges
```dart
final workHours = ClockTimeRange(
  start: ClockTime(9),   // 9:00 AM
  end: ClockTime(17),    // 5:00 PM
);
workHours.includes(DateTime.now());
```

#### `DartDateRange` - Date Ranges
Powerful date range operations:

```dart
final quarter = DartDateRange(
  start: DateTime(2023, 7, 1),
  end: DateTime(2023, 9, 30),
);

quarter.duration.inDays         // 92
quarter.includes(someDate)      // true/false
quarter.dates.toList()          // All dates in range
quarter.cross(otherRange)       // Check overlap
```

#### `ISODuration` - ISO 8601 Durations
Full ISO 8601 duration support with negative durations:

```dart
ISODuration.parse("P1Y2M3DT4H30M")   // 1 year, 2 months, 3 days, 4h 30m
ISODuration.parse("-P6M")            // 6 months ago
duration.toIso()                     // Convert back to string
duration.isNegative                  // Check if negative
```

### 🎯 TimeGranularity Enum
Control precision for comparisons:
```dart
TimeGranularity.year      // Compare by year only
TimeGranularity.month     // Compare by month
TimeGranularity.day       // Compare by day
TimeGranularity.hour      // Compare by hour
// ... and more: minute, second, milliseconds, microseconds
```

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
[dart_install_link]: https://dart.dev/get-dart

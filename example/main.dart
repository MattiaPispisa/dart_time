// ignore_for_file: avoid_print example

import 'package:dart_time/dart_time.dart';

void main() {
  print('🚀 Dart Time Library\n');

  // ═══════════════════════════════════════════════════════════════
  // 🔧 DateTime Extensions - Enhanced date manipulation
  // ═══════════════════════════════════════════════════════════════

  print('📅 DateTime Extensions:');

  // Create dates with named parameters
  final birthday = DateTimeHelper.named(
    year: 1997,
    month: 11,
    day: 12,
    hour: 6,
    minute: 0,
    second: 0,
    millisecond: 0,
    microsecond: 0,
  );
  print('  Birthday: $birthday');

  // Boundary operations
  final today = DateTime.now();
  print('  Today: $today');
  print('  Start of day: ${today.startOfDay}');
  print('  End of month: ${today.endOfMonth}');
  print('  Start of quarter: ${today.startOfQuarter}');

  // Calendar information
  print('  Current quarter: Q${today.quarter}');
  print('  Is leap year: ${today.isLeapYear}');
  print('  Days in month: ${today.daysInMonth}');
  print('  ISO week of year: ${today.isoWeekOfYear}');

  // Date arithmetic with DST awareness
  final futureDate = today.addMonths(3).addDays(15);
  print(
    '  3 months + 15 days from now: ${futureDate.toString().split('.')[0]}',
  );

  // Granular comparisons
  final date1 = DateTime(2023, 6, 15, 14, 30);
  final date2 = DateTime(2023, 6, 15, 10, 15);
  print('  Same day? ${date1.isSameDay(date2)}');
  print('  Same hour? ${date1.isSameHour(date2)}');
  print(
    '  Is date1 after date2 (day level)?'
    ' ${date1.isGranularAfter(date2, TimeGranularity.day)}',
  );

  print('');

  // ═══════════════════════════════════════════════════════════════
  // ⏱️ Duration Extensions - Smart duration handling
  // ═══════════════════════════════════════════════════════════════

  print('⏱️ Duration Extensions:');

  // Easy duration creation
  final workDay = 8.hours + 30.minutes;
  final break1 = 15.minutes;
  final lunch = 1.hours;

  print('  Work day: ${workDay.hhmmss}');
  print('  Total breaks: ${(break1 * 2 + lunch).hhmmss}');

  // Fractional durations
  final overtime = 1.5.fractionalHours;
  print('  Overtime: ${overtime.hhmmss} (${overtime.inFractionalHours} hours)');

  // Duration formatting and operations
  final longDuration = 25.hours + 90.minutes + 45.seconds;
  print('  Long duration: ${longDuration.hhmmss}');
  print('  Rounded to hour: ${longDuration.roundToHour().inHours} hours');
  print('  In weeks: ${7.days.inWeeks} weeks');

  // Duration validation
  const zeroDuration = Duration.zero;
  final negativeDuration = (-2).hours;
  print('  Is zero? ${zeroDuration.isZero}');
  print('  Is negative? ${negativeDuration.isNegative}');

  // ISO 8601 parsing and formatting
  final isoDuration = DurationHelper.parseISO('P3DT4H30M');
  print('  Parsed ISO duration: ${isoDuration.hhmmss}');
  print('  Back to ISO: ${isoDuration.toIsoString()}');

  print('');

  // ═══════════════════════════════════════════════════════════════
  // 🕐 ClockTime - Time-of-day operations without dates
  // ═══════════════════════════════════════════════════════════════

  print('🕐 ClockTime - Time without dates:');

  // Create time instances
  final meetingTime = ClockTime(14, minute: 30);
  final startWork = ClockTime(9);
  final endWork = ClockTime(17, minute: 30);

  print('  Meeting time: ${meetingTime.format12Hour}');
  print('  Work hours: ${startWork.format24Hour} - ${endWork.format24Hour}');

  // Time period detection
  print('  Meeting is in: ${_getTimePeriod(meetingTime)}');
  print('  Minutes since midnight: ${meetingTime.minutesSinceMidnight}');
  print('  Minutes until end of day: ${meetingTime.minutesUntilMidnight}');

  // Time arithmetic with 24-hour wrap
  final lateNight = ClockTime(23, minute: 45);
  final afterMidnight = lateNight.addMinutes(30);
  print('  23:45 + 30 min = ${afterMidnight.format24Hour} (next day)');

  // Parse different time formats
  final parsedTime = ClockTime.parse('15:45:30');
  print('  Parsed time: ${parsedTime.formatWithSeconds}');

  print('');

  // ═══════════════════════════════════════════════════════════════
  // 📊 Time Ranges - Schedule management
  // ═══════════════════════════════════════════════════════════════

  print('📊 Time Ranges:');

  // Clock time ranges for daily schedules
  final workHours = ClockTimeRange(
    start: ClockTime(9),
    end: ClockTime(17),
  );

  final nightShift = ClockTimeRange(
    start: ClockTime(22),
    end: ClockTime(6), // Crosses midnight
  );

  final now = DateTime.now();
  print('  Currently in work hours? ${workHours.includes(now)}');
  print('  Currently in night shift? ${nightShift.includes(now)}');

  // Date ranges for projects and events
  final projectQ3 = DartDateRange(
    start: DateTime(2024, 7),
    end: DateTime(2024, 9, 30),
  );

  final vacation = DartDateRange(
    start: DateTime(2024, 8, 15),
    end: DateTime(2024, 8, 30),
  );

  print('  Q3 project duration: ${projectQ3.duration.inDays} days');
  print('  Vacation overlaps with project? ${projectQ3.cross(vacation)}');
  print('  Project contains vacation? ${projectQ3.contains(vacation)}');

  // Iterate through dates
  final workingDays = DartDateRange(
    start: DateTime(2024),
    end: DateTime(2024, 1, 7),
  ).dates.where((date) => date.weekday <= 5).length;

  print('  Working days in first week 2024: $workingDays');

  print('');

  // ═══════════════════════════════════════════════════════════════
  // 🌍 ISO 8601 Durations - International standard compliance
  // ═══════════════════════════════════════════════════════════════

  print('🌍 ISO 8601 Durations:');

  // Create and parse ISO durations
  final projectDuration = ISODuration(years: 1, months: 6, days: 15);
  final maintenanceWindow = ISODuration.parse('PT4H30M');
  final retroactive = ISODuration.parse('-P6M15DT2H'); // Negative duration

  print('  Project duration: ${projectDuration.toIso()}');
  print('  Maintenance window: ${maintenanceWindow.toIso()}');
  print('  6 months ago: ${retroactive.toIso()}');

  // Duration properties and validation
  print('  Project is negative? ${projectDuration.isNegative}');
  print('  Retroactive is negative? ${retroactive.isNegative}');
  print('  Maintenance is zero? ${maintenanceWindow.isZero}');

  // Convert to Dart Duration (when possible)
  final dartDuration = maintenanceWindow.toDuration();
  print('  Maintenance as Duration: ${dartDuration.hhmmss}');

  // Copy with modifications
  final extendedProject = projectDuration.copyWith(months: 8, days: 0);
  print('  Extended project: ${extendedProject.toIso()}');

  print('');

  // ═══════════════════════════════════════════════════════════════
  // 🎯 Time Granularity - Precision control
  // ═══════════════════════════════════════════════════════════════

  print('🎯 Time Granularity Examples:');

  final timestamp1 = DateTime(2024, 3, 15, 14, 30, 45, 123);
  final timestamp2 = DateTime(2024, 3, 15, 10, 15, 20, 456);
  final timestamp3 = DateTime(2024, 3, 16, 14, 30, 45, 123);

  print(
    '  Same day? ${timestamp1.isGranularSame(timestamp2, TimeGranularity.day)}',
  );
  print(
    '  Same hour? '
    '${timestamp1.isGranularSame(timestamp2, TimeGranularity.hour)}',
  );
  print(
    '  Different day same time?'
    ' ${timestamp1.isGranularSame(timestamp3, TimeGranularity.hour)}',
  );

  // Practical granularity usage
  final appointments = [
    DateTime(2024, 3, 15, 9),
    DateTime(2024, 3, 15, 14, 30),
    DateTime(2024, 3, 16, 9),
  ];

  final targetDay = DateTime(2024, 3, 15);
  final todayAppointments = appointments
      .where((apt) => apt.isGranularSame(targetDay, TimeGranularity.day))
      .length;

  print('  Appointments on target day: $todayAppointments');

  print('');

  // ═══════════════════════════════════════════════════════════════
  // 💼 Real-world use cases
  // ═══════════════════════════════════════════════════════════════

  print('💼 Real-world Examples:');

  // Business hours validation
  final businessHours = ClockTimeRange(
    start: ClockTime(9),
    end: ClockTime(18),
  );

  final customerCall = DateTime.now();
  if (businessHours.includes(customerCall)) {
    print('  ✅ Customer service available');
  } else {
    print('  ❌ Outside business hours');
  }

  // Project timeline management
  final sprintStart = DateTime.now().startOfDay;
  final sprintEnd = sprintStart.addDays(14).endOfDay;
  final sprintRange = DartDateRange(start: sprintStart, end: sprintEnd);

  print('  📋 Sprint: ${sprintRange.duration.inDays} days');
  print(
    '  🏃‍♂️ Sprint progress: ${DateTime.now().difference(sprintStart).inDays}/14 days',
  );

  // Meeting scheduling
  final meetings = <ClockTime>[
    ClockTime(9, minute: 30),
    ClockTime(11),
    ClockTime(14, minute: 30),
    ClockTime(16),
  ];

  print("  📅 Today's meetings:");
  for (final meeting in meetings) {
    final period = _getTimePeriod(meeting);
    print('    • ${meeting.format12Hour} ($period)');
  }

  // Age calculation with precision
  final birthDate = DateTime(1990, 6, 15);
  final age = DateTime.now().difference(birthDate);
  final ageYears = age.inDays ~/ 365;
  print('  🎂 Age: approximately $ageYears years (${age.inDays} days)');

  // Deadline tracking
  final deadline = DateTime.now().add(7.days).endOfDay;
  final timeLeft = deadline.difference(DateTime.now());
  print(
    '  ⏰ Project deadline: ${timeLeft.inDays} days,'
    ' ${timeLeft.inHours % 24} hours left',
  );

  print(
    '\n✨ This showcases the power of dart_time'
    ' for any time-related operations!',
  );
}

/// Helper function to determine time period
String _getTimePeriod(ClockTime time) {
  if (time.isMorning) return 'Morning';
  if (time.isAfternoon) return 'Afternoon';
  if (time.isEvening) return 'Evening';
  return 'Night';
}

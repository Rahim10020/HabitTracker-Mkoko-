// Streak helpers.
//
// A habit is only "due" on its scheduled weekdays (frequencyDays, ISO
// 1=Mon..7=Sun) — streaks only look at those days, so a weekly habit
// scheduled for Mon/Wed/Fri isn't penalized for Tuesdays.

List<int> parseFrequencyDays(String frequencyDays) {
  return frequencyDays
      .split(',')
      .map((s) => s.trim())
      .where((s) => s.isNotEmpty)
      .map(int.parse)
      .toList();
}

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

// current streak, counted backwards from today. Today doesn't break the
// streak if it's not completed yet — it's just not counted.
int currentStreak(List<DateTime> completedDays, List<int> scheduledWeekdays) {
  if (completedDays.isEmpty || scheduledWeekdays.isEmpty) return 0;

  final completedSet = completedDays.map(_dateOnly).toSet();
  final today = _dateOnly(DateTime.now());

  int streak = 0;
  DateTime day = today;

  while (true) {
    if (scheduledWeekdays.contains(day.weekday)) {
      if (completedSet.contains(day)) {
        streak++;
      } else if (day == today) {
        // today not done yet — don't break the streak, just skip it
      } else {
        break;
      }
    }
    day = day.subtract(const Duration(days: 1));
    // safety cap so a data glitch can't loop forever
    if (today.difference(day).inDays > 3650) break;
  }
  return streak;
}

// longest streak ever recorded for this habit.
int bestStreak(List<DateTime> completedDays, List<int> scheduledWeekdays) {
  if (completedDays.isEmpty || scheduledWeekdays.isEmpty) return 0;

  final completedSet = completedDays.map(_dateOnly).toSet();
  final sortedDates = completedSet.toList()..sort();

  int best = 0;
  int current = 0;
  DateTime cursor = sortedDates.first;
  final last = sortedDates.last;

  while (!cursor.isAfter(last)) {
    if (scheduledWeekdays.contains(cursor.weekday)) {
      if (completedSet.contains(cursor)) {
        current++;
        if (current > best) best = current;
      } else {
        current = 0;
      }
    }
    cursor = cursor.add(const Duration(days: 1));
  }
  return best;
}

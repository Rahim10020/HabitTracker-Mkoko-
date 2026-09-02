// given completed days (per habit, or aggregated across habits)

bool isHabitCompletedToday(List<DateTime> completedDays) {
  final today = DateTime.now();
  return completedDays.any(
    (date) =>
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day,
  );
}

// we gonna prepare heat map datasets from every habit's completed dates
Map<DateTime, int> prepareHeatMapDataset(
  Map<int, List<DateTime>> completedDaysByHabit,
) {
  Map<DateTime, int> datasets = {};
  for (final completedDays in completedDaysByHabit.values) {
    for (var date in completedDays) {
      // normalize date to avoid type mismatch
      final normalizedDate = DateTime(date.year, date.month, date.day);
      // if the date already exists in the dataset, increment its count
      if (datasets.containsKey(normalizedDate)) {
        datasets[normalizedDate] = datasets[normalizedDate]! + 1;
      } else {
        // otherwise, initialize it with a count of 1
        datasets[normalizedDate] = 1;
      }
    }
  }
  return datasets;
}

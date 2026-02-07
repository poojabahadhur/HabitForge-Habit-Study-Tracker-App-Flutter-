import 'package:habit_modification/models/habit.dart';

bool isHabitCompletedToday(List<DateTime> completedDays) {
  final today = DateTime.now();
  return completedDays.any(
    (d) => d.year == today.year && d.month == today.month && d.day == today.day,
  );
}

Map<DateTime, int> prepHeatMapDataset(List<Habit> habits) {
  final Map<DateTime, int> dataset = {};
  for (final h in habits) {
    for (final d in h.completedDays) {
      final normalized = DateTime(d.year, d.month, d.day);
      dataset[normalized] = (dataset[normalized] ?? 0) + 1;
    }
  }
  return dataset;
}

import 'package:flutter/material.dart';
import 'package:habit_modification/models/app_settings.dart';
import 'package:habit_modification/models/habit.dart';
import 'package:habit_modification/models/reading_log.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

  // Initialize DB (open collections)
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([
      HabitSchema,
      AppSettingsSchema,
      ReadingLogSchema,
    ], directory: dir.path);
  }

  // ensure settings doc exists
  Future<AppSettings> _getOrCreateSettings() async {
    var settings = await isar.appSettings.where().findFirst();
    if (settings == null) {
      settings = AppSettings()..FirstLaunchDate = DateTime.now();
      // use async writeTxn and await put inside it
      await isar.writeTxn(() async {
        await isar.appSettings.put(settings!);
      });
    }
    return settings;
  }

  Future<void> saveFirstLaunchDate() async {
    await _getOrCreateSettings();
  }

  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.FirstLaunchDate;
  }

  Future<DateTime?> getLastPopupShownDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.LastPopupShownDate;
  }

  Future<void> setLastPopupShownDate(DateTime date) async {
    final settings = await _getOrCreateSettings();
    await isar.writeTxn(() async {
      settings.LastPopupShownDate = date;
      await isar.appSettings.put(settings);
    });
  }

  // ---------- HABIT CRUD ----------
  final List<Habit> currentHabits = [];

  Future<void> addHabit(String name) async {
    final h = Habit()..name = name;
    await isar.writeTxn(() async {
      await isar.habits.put(h);
    });
    await readHabits();
  }

  Future<void> readHabits() async {
    final all = await isar.habits.where().findAll();
    currentHabits
      ..clear()
      ..addAll(all);
    notifyListeners();
  }

  Future<void> updateHabitName(int id, String newName) async {
    final h = await isar.habits.get(id);
    if (h != null) {
      await isar.writeTxn(() async {
        h.name = newName;
        await isar.habits.put(h);
      });
      await readHabits();
    }
  }

  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    final h = await isar.habits.get(id);
    if (h != null) {
      await isar.writeTxn(() async {
        final now = DateTime.now();
        final normalized = DateTime(now.year, now.month, now.day);
        if (isCompleted &&
            !h.completedDays.any(
              (d) =>
                  d.year == normalized.year &&
                  d.month == normalized.month &&
                  d.day == normalized.day,
            )) {
          h.completedDays.add(normalized);
        } else {
          h.completedDays.removeWhere(
            (d) =>
                d.year == normalized.year &&
                d.month == normalized.month &&
                d.day == normalized.day,
          );
        }
        await isar.habits.put(h);
      });
      await readHabits();
    }
  }

  Future<void> deleteHabit(int id) async {
    await isar.writeTxn(() async {
      await isar.habits.delete(id);
    });
    await readHabits();
  }

  // ---------- READING LOG (study sessions) ----------

  Future<void> addReadingLog(DateTime timestamp, int durationMinutes) async {
    final r = ReadingLog()
      ..dateTime = timestamp
      ..durationMinutes = durationMinutes;
    await isar.writeTxn(() async {
      await isar.readingLogs.put(r);
    });
  }

  Future<List<ReadingLog>> _allReadingLogs() async {
    return await isar.readingLogs.where().findAll();
  }

  Future<List<ReadingLog>> getReadingLogsForDate(DateTime date) async {
    final all = await _allReadingLogs();
    final day = DateTime(date.year, date.month, date.day);
    return all.where((r) {
      final d = r.dateTime;
      return d.year == day.year && d.month == day.month && d.day == day.day;
    }).toList();
  }

  Future<double> getTotalHoursForDate(DateTime date) async {
    final logs = await getReadingLogsForDate(date);
    final totalMin = logs.fold<int>(0, (acc, s) => acc + s.durationMinutes);
    return totalMin / 60.0;
  }

  Future<Map<DateTime, double>> getDailyHoursBetween(
    DateTime from,
    DateTime to,
  ) async {
    final all = await _allReadingLogs();
    final Map<DateTime, int> minByDay = {};
    for (final r in all) {
      final d = DateTime(r.dateTime.year, r.dateTime.month, r.dateTime.day);
      minByDay[d] = (minByDay[d] ?? 0) + r.durationMinutes;
    }
    final Map<DateTime, double> result = {};
    final s = DateTime(from.year, from.month, from.day);
    final e = DateTime(to.year, to.month, to.day);
    minByDay.forEach((k, v) {
      if (!k.isBefore(s) && !k.isAfter(e)) result[k] = v / 60.0;
    });
    return result;
  }
}

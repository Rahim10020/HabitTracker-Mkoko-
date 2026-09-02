import 'package:R_HabitTracker/database/app_database.dart';
import 'package:R_HabitTracker/utils/habit_category.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

class HabitDatabase extends ChangeNotifier {
  static late AppDatabase db;

  // ----------------------- SETUP -----------------------

  // initialize the database
  static Future<void> initialize() async {
    db = AppDatabase();
  }

  // save first date of app startup
  Future<void> saveFirstLaunchDate() async {
    final existingSettings =
        await db.select(db.appSettings).getSingleOrNull();
    if (existingSettings == null) {
      await db.into(db.appSettings).insert(
            AppSettingsCompanion.insert(
              firstLaunchDate: Value(DateTime.now()),
            ),
          );
    }
  }

  // get first date of startup
  Future<DateTime?> getFirstLaunch() async {
    final settings = await db.select(db.appSettings).getSingleOrNull();
    return settings?.firstLaunchDate;
  }

  // -------------------- CRUD OPERATIONS -----------------

  // list of habits
  final List<Habit> currentHabits = [];

  // completed dates per habit id (replaces the old Habit.completedDays
  // field, now that completions live in their own table). A day only
  // lands here once its count reached the habit's targetCount — partial
  // progress on a quantifiable habit doesn't count as "done" for streaks,
  // the heatmap, or the summary header.
  final Map<int, List<DateTime>> completedDaysByHabit = {};

  // today's raw progress count per habit (0..targetCount), regardless of
  // whether it has reached the target yet. Drives the +/- stepper and
  // progress bar on quantifiable habit tiles.
  final Map<int, int> todayProgressByHabit = {};

  List<DateTime> completedDaysFor(int habitId) =>
      completedDaysByHabit[habitId] ?? [];

  int progressFor(int habitId) => todayProgressByHabit[habitId] ?? 0;

  // -------------------- CATEGORIES -----------------

  // user-added categories, layered on top of the fixed kHabitCategories
  // set. Loaded once at startup and kept in sync via readCategories().
  final List<HabitCategory> customCategories = [];

  // built-ins first, then custom ones in creation order.
  List<HabitCategory> get allCategories => [
        ...kHabitCategories,
        ...customCategories,
      ];

  HabitCategory categoryById(String id) => allCategories.firstWhere(
        (c) => c.id == id,
        orElse: () => kHabitCategories.last, // falls back to "Autre"
      );

  Future<void> readCategories() async {
    final rows = await db.select(db.categories).get();
    customCategories
      ..clear()
      ..addAll(rows.map((r) => HabitCategory(
            id: r.key,
            label: r.label,
            icon: IconData(r.iconCodepoint, fontFamily: 'MaterialIcons'),
            color: Color(r.colorValue),
          )));
    notifyListeners();
  }

  // CREATE - add a custom category and return its generated key. Slugs
  // the label into a unique key so it can be stored on Habits.category
  // alongside the built-in ids.
  Future<String> addCategory({
    required String label,
    required IconData icon,
    required Color color,
  }) async {
    final baseKey = label
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_+|_+$'), '');
    final existingKeys = {
      ...kHabitCategories.map((c) => c.id),
      ...customCategories.map((c) => c.id),
    };
    var key = baseKey.isEmpty ? 'custom' : baseKey;
    var suffix = 2;
    while (existingKeys.contains(key)) {
      key = '${baseKey.isEmpty ? 'custom' : baseKey}_$suffix';
      suffix++;
    }

    await db.into(db.categories).insert(
          CategoriesCompanion.insert(
            key: key,
            label: label.trim(),
            iconCodepoint: icon.codePoint,
            colorValue: color.value,
          ),
        );
    await readCategories();
    return key;
  }

  // CREATE - add a new habit to the database
  //
  // category/frequency/targetCount/unit default to a simple daily on-off
  // habit; the create-habit UI for picking them explicitly lands in the
  // next patch (component/nav redesign).
  Future<void> addHabit(
    String habitName, {
    String category = 'other',
    String frequencyType = 'daily',
    String frequencyDays = '1,2,3,4,5,6,7',
    int targetCount = 1,
    String? unit,
  }) async {
    await db.into(db.habits).insert(
          HabitsCompanion.insert(
            name: habitName,
            category: Value(category),
            frequencyType: Value(frequencyType),
            frequencyDays: Value(frequencyDays),
            targetCount: Value(targetCount),
            unit: Value(unit),
          ),
        );
    await readHabits();
  }

  // READ - read all habits (and their completions) from the database
  Future<void> readHabits() async {
    final fetchedHabits = await db.select(db.habits).get();

    currentHabits
      ..clear()
      ..addAll(fetchedHabits);

    final today = DateTime.now();
    final normalizedToday = DateTime(today.year, today.month, today.day);

    completedDaysByHabit.clear();
    todayProgressByHabit.clear();
    for (final habit in fetchedHabits) {
      final completions = await (db.select(db.habitCompletions)
            ..where((c) => c.habitId.equals(habit.id)))
          .get();

      completedDaysByHabit[habit.id] = completions
          .where((c) => c.count >= habit.targetCount)
          .map((c) => c.date)
          .toList();

      final todayRows = completions.where((c) =>
          c.date.year == normalizedToday.year &&
          c.date.month == normalizedToday.month &&
          c.date.day == normalizedToday.day);
      todayProgressByHabit[habit.id] =
          todayRows.isEmpty ? 0 : todayRows.first.count;
    }

    // update UI
    notifyListeners();
  }

  // UPDATE - check habit on and off for today (simple on/off habits, i.e.
  // targetCount == 1 — the tap-to-toggle tile).
  //
  // Marking "on" records the habit's full targetCount for today; marking
  // "off" clears it.
  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    final habit =
        await (db.select(db.habits)..where((h) => h.id.equals(id)))
            .getSingleOrNull();
    if (habit == null) return;

    await _setTodayProgress(id, isCompleted ? habit.targetCount : 0);
  }

  // UPDATE - adjust today's progress for a quantifiable habit by [delta]
  // (e.g. +1/-1 glass of water), clamped to [0, targetCount]. Powers the
  // +/- stepper on quantifiable habit tiles.
  Future<void> adjustHabitProgress(int id, int delta) async {
    final habit =
        await (db.select(db.habits)..where((h) => h.id.equals(id)))
            .getSingleOrNull();
    if (habit == null) return;

    final newValue = (progressFor(id) + delta).clamp(0, habit.targetCount);
    await _setTodayProgress(id, newValue);
  }

  // shared upsert for today's HabitCompletions row.
  Future<void> _setTodayProgress(int id, int newCount) async {
    final today = DateTime.now();
    final normalizedToday = DateTime(today.year, today.month, today.day);

    final existing = await (db.select(db.habitCompletions)
          ..where(
              (c) => c.habitId.equals(id) & c.date.equals(normalizedToday)))
        .getSingleOrNull();

    if (existing == null) {
      await db.into(db.habitCompletions).insert(
            HabitCompletionsCompanion.insert(
              habitId: id,
              date: normalizedToday,
              count: Value(newCount),
            ),
          );
    } else {
      await (db.update(db.habitCompletions)
            ..where((c) => c.id.equals(existing.id)))
          .write(HabitCompletionsCompanion(count: Value(newCount)));
    }

    // re-read from the database
    await readHabits();
  }

  // UPDATE - edit a habit's name, category, frequency and target
  Future<void> updateHabit(
    int id, {
    required String name,
    required String category,
    required String frequencyType,
    required String frequencyDays,
    required int targetCount,
    String? unit,
  }) async {
    await (db.update(db.habits)..where((h) => h.id.equals(id))).write(
      HabitsCompanion(
        name: Value(name),
        category: Value(category),
        frequencyType: Value(frequencyType),
        frequencyDays: Value(frequencyDays),
        targetCount: Value(targetCount),
        unit: Value(unit),
      ),
    );
    // re-read from the database
    await readHabits();
  }

  // DELETE - delete habit from the database
  Future<void> deleteHabit(int id) async {
    await (db.delete(db.habits)..where((h) => h.id.equals(id))).go();
    // re-read from the database
    await readHabits();
  }
}

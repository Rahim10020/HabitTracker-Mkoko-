import 'package:R_HabitTracker/database/app_database.dart';
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
  // field, now that completions live in their own table)
  final Map<int, List<DateTime>> completedDaysByHabit = {};

  List<DateTime> completedDaysFor(int habitId) =>
      completedDaysByHabit[habitId] ?? [];

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

    completedDaysByHabit.clear();
    for (final habit in fetchedHabits) {
      final completions = await (db.select(db.habitCompletions)
            ..where((c) =>
                c.habitId.equals(habit.id) & c.count.isBiggerThanValue(0)))
          .get();
      completedDaysByHabit[habit.id] =
          completions.map((c) => c.date).toList();
    }

    // update UI
    notifyListeners();
  }

  // UPDATE - check habit on and off for today
  //
  // Marking "on" records the habit's full targetCount for today; marking
  // "off" clears it. Partial/quantifiable progress (e.g. logging 3 of 8
  // glasses of water) is a UI concern for the next patch — the schema
  // already supports it via HabitCompletions.count.
  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    final today = DateTime.now();
    final normalizedToday = DateTime(today.year, today.month, today.day);

    final habit =
        await (db.select(db.habits)..where((h) => h.id.equals(id)))
            .getSingleOrNull();
    if (habit == null) return;

    final existing = await (db.select(db.habitCompletions)
          ..where(
              (c) => c.habitId.equals(id) & c.date.equals(normalizedToday)))
        .getSingleOrNull();

    final newCount = isCompleted ? habit.targetCount : 0;

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

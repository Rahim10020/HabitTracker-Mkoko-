import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Habits, HabitCompletions, Categories, AppSettings])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // v1 -> v2: add the user-defined categories table. Habits and
            // HabitCompletions are untouched.
            await m.createTable(categories);
          }
          if (from < 3) {
            // v2 -> v3: add the optional per-habit reminder time.
            await m.addColumn(habits, habits.reminderTime);
          }
        },
      );

  static QueryExecutor _openConnection() {
    // Stores the sqlite file in the app's documents directory under the
    // name `r_habit_tracker.sqlite`. See:
    // https://pub.dev/packages/drift_flutter
    return driftDatabase(name: 'r_habit_tracker');
  }
}

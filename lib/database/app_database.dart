import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Habits, HabitCompletions, AppSettings])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    // Stores the sqlite file in the app's documents directory under the
    // name `r_habit_tracker.sqlite`. See:
    // https://pub.dev/packages/drift_flutter
    return driftDatabase(name: 'r_habit_tracker');
  }
}

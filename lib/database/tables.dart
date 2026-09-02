import 'package:drift/drift.dart';

// -----------------------------------------------------------------------
// Habits
// -----------------------------------------------------------------------
// `category`        free-form key, mapped to an icon/color in the UI layer
//                    (see theme/app_colors.dart) — kept as text rather than
//                    a fixed enum so new categories don't require a schema
//                    change.
// `frequencyType`    'daily' | 'weekly'
// `frequencyDays`    comma-separated ISO weekdays (1=Mon..7=Sun) the habit
//                    is scheduled on. Defaults to every day.
// `targetCount`      how many times per day counts as "done". 1 = simple
//                    on/off habit, >1 = quantifiable habit (e.g. "8 glasses
//                    of water").
// `unit`             optional label for a quantifiable habit's count
//                    (e.g. "glasses", "pages", "min").
class Habits extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get category => text().withDefault(const Constant('other'))();
  TextColumn get frequencyType =>
      text().withDefault(const Constant('daily'))();
  TextColumn get frequencyDays =>
      text().withDefault(const Constant('1,2,3,4,5,6,7'))();
  IntColumn get targetCount => integer().withDefault(const Constant(1))();
  TextColumn get unit => text().nullable()();
}

// -----------------------------------------------------------------------
// HabitCompletions
// -----------------------------------------------------------------------
// One row per (habit, day). Replaces the old `Habit.completedDays` list so
// a day can hold a partial count for quantifiable habits, not just a
// boolean. `count` of 0 means "not done that day" and is treated the same
// as "no row" by the read side.
class HabitCompletions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get habitId =>
      integer().references(Habits, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get date => dateTime()();
  IntColumn get count => integer().withDefault(const Constant(0))();

  @override
  List<Set<Column>> get uniqueKeys => [
        {habitId, date},
      ];
}

// -----------------------------------------------------------------------
// AppSettings
// -----------------------------------------------------------------------
class AppSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get firstLaunchDate => dateTime().nullable()();
}

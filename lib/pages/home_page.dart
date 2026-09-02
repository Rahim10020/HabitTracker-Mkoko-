import 'package:R_HabitTracker/components/confirm_delete_sheet.dart';
import 'package:R_HabitTracker/components/empty_habits_view.dart';
import 'package:R_HabitTracker/components/habit_form_sheet.dart';
import 'package:R_HabitTracker/components/home_summary_header.dart';
import 'package:R_HabitTracker/components/my_habit_tile.dart';
import 'package:R_HabitTracker/components/my_heat_map.dart';
import 'package:R_HabitTracker/database/app_database.dart';
import 'package:R_HabitTracker/database/habit_database.dart';
import 'package:R_HabitTracker/utils/habit_category.dart';
import 'package:R_HabitTracker/utils/habit_util.dart';
import 'package:R_HabitTracker/utils/streak_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // we gonna read existing habits on app startup
    Provider.of<HabitDatabase>(context, listen: false).readHabits();
    super.initState();
  }

  Future<void> createNewHabit() async {
    final result = await showHabitFormSheet(context);
    if (result == null || !mounted) return;
    context.read<HabitDatabase>().addHabit(
          result.name,
          category: result.category,
          frequencyType: result.frequencyType,
          frequencyDays: result.frequencyDays,
          targetCount: result.targetCount,
          unit: result.unit,
        );
  }

  void checkHabitOnAndOff(bool? value, Habit habit) {
    if (value != null) {
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
    }
  }

  Future<void> editHabitBox(Habit habit) async {
    final result = await showHabitFormSheet(
      context,
      initialName: habit.name,
      initialCategory: habit.category,
      initialFrequencyType: habit.frequencyType,
      initialFrequencyDays: habit.frequencyDays,
      initialTargetCount: habit.targetCount,
      initialUnit: habit.unit,
    );
    if (result == null || !mounted) return;
    context.read<HabitDatabase>().updateHabit(
          habit.id,
          name: result.name,
          category: result.category,
          frequencyType: result.frequencyType,
          frequencyDays: result.frequencyDays,
          targetCount: result.targetCount,
          unit: result.unit,
        );
  }

  Future<void> deleteHabitBox(Habit habit) async {
    final confirmed =
        await showConfirmDeleteSheet(context, habitName: habit.name);
    if (!confirmed || !mounted) return;
    context.read<HabitDatabase>().deleteHabit(habit.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        onPressed: createNewHabit,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
      body: Consumer<HabitDatabase>(
        builder: (context, habitDatabase, _) {
          if (habitDatabase.currentHabits.isEmpty) {
            return EmptyHabitsView(onCreatePressed: createNewHabit);
          }
          return ListView(
            children: [
              _buildSummaryHeader(habitDatabase),
              _buildHeatMap(habitDatabase),
              _buildHabitList(habitDatabase),
              const SizedBox(height: 100),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryHeader(HabitDatabase habitDatabase) {
    final habits = habitDatabase.currentHabits;
    final completedToday = habits
        .where((h) =>
            isHabitCompletedToday(habitDatabase.completedDaysFor(h.id)))
        .length;
    return HomeSummaryHeader(
      completedCount: completedToday,
      totalCount: habits.length,
    );
  }

  Widget _buildHeatMap(HabitDatabase habitDatabase) {
    return FutureBuilder<DateTime?>(
      future: habitDatabase.getFirstLaunch(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MyHeatMap(
            startDate: snapshot.data!,
            datasets: prepareHeatMapDataset(habitDatabase.completedDaysByHabit),
          );
        }
        return Container();
      },
    );
  }

  Widget _buildHabitList(HabitDatabase habitDatabase) {
    List<Habit> currentHabits = habitDatabase.currentHabits;
    return ListView.builder(
      itemCount: currentHabits.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final habit = currentHabits[index];
        final completedDays = habitDatabase.completedDaysFor(habit.id);
        final scheduledDays = parseFrequencyDays(habit.frequencyDays);
        bool isCompletedToday = isHabitCompletedToday(completedDays);

        return MyHabitTile(
          isCompleted: isCompletedToday,
          text: habit.name,
          category: habitCategoryById(habit.category),
          targetCount: habit.targetCount,
          unit: habit.unit,
          streak: currentStreak(completedDays, scheduledDays),
          onChanged: (value) => checkHabitOnAndOff(value, habit),
          onEditPressed: (context) => editHabitBox(habit),
          onDeletePressed: (context) => deleteHabitBox(habit),
        );
      },
    );
  }
}

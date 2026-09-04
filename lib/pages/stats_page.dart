import 'package:R_HabitTracker/database/habit_database.dart';
import 'package:R_HabitTracker/pages/habit_detail_page.dart';
import 'package:R_HabitTracker/theme/app_spacing.dart';
import 'package:R_HabitTracker/utils/streak_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  @override
  void initState() {
    Provider.of<HabitDatabase>(context, listen: false).readHabits();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Consumer<HabitDatabase>(
          builder: (context, habitDatabase, _) {
            final habits = habitDatabase.currentHabits;

            if (habits.isEmpty) {
              return Center(
                child: Text(
                  'Crée une habitude pour voir tes stats ici.',
                  style: textTheme.bodyMedium,
                ),
              );
            }

            final weekRate = _weeklyCompletionRate(habitDatabase);

            return ListView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              children: [
                Text('Statistiques', style: textTheme.headlineMedium),
                const SizedBox(height: AppSpacing.lg),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: colorScheme.secondary,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Cette semaine', style: textTheme.bodyMedium),
                            const SizedBox(height: AppSpacing.xs),
                            TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0, end: weekRate * 100),
                              duration: const Duration(milliseconds: 800),
                              curve: Curves.easeOutCubic,
                              builder: (context, value, _) => Text(
                                '${value.round()}%',
                                style: textTheme.displayLarge,
                              ),
                            ),
                            Text('de complétion', style: textTheme.bodyMedium),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 64,
                        height: 64,
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: weekRate),
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, _) =>
                              CircularProgressIndicator(
                            value: value,
                            strokeWidth: 6,
                            backgroundColor: colorScheme.outline,
                            valueColor:
                                AlwaysStoppedAnimation(colorScheme.primary),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text('Séries par habitude', style: textTheme.titleLarge),
                const SizedBox(height: AppSpacing.sm),
                ...habits.map((habit) {
                  final completedDays =
                      habitDatabase.completedDaysFor(habit.id);
                  final scheduledDays = parseFrequencyDays(habit.frequencyDays);
                  final category = habitDatabase.categoryById(habit.category);
                  final current = currentStreak(completedDays, scheduledDays);
                  final best = bestStreak(completedDays, scheduledDays);

                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HabitDetailPage(habitId: habit.id),
                      ),
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: colorScheme.secondary,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: category.color.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Text(habit.name, style: textTheme.bodyLarge),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('🔥 $current', style: textTheme.bodyMedium),
                              Text('Record : $best',
                                  style: textTheme.labelSmall),
                            ],
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Icon(Icons.chevron_right_rounded,
                              color: colorScheme.onSurfaceVariant, size: 20),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }

  // fraction of scheduled occurrences completed over the last 7 days,
  // across all habits.
  double _weeklyCompletionRate(HabitDatabase habitDatabase) {
    final today = DateTime.now();
    final habits = habitDatabase.currentHabits;

    int scheduled = 0;
    int completed = 0;

    for (final habit in habits) {
      final scheduledDays = parseFrequencyDays(habit.frequencyDays);
      final completedSet = habitDatabase
          .completedDaysFor(habit.id)
          .map((d) => DateTime(d.year, d.month, d.day))
          .toSet();

      for (int i = 0; i < 7; i++) {
        final day = DateTime(today.year, today.month, today.day)
            .subtract(Duration(days: i));
        if (scheduledDays.contains(day.weekday)) {
          scheduled++;
          if (completedSet.contains(day)) completed++;
        }
      }
    }

    if (scheduled == 0) return 0;
    return completed / scheduled;
  }
}

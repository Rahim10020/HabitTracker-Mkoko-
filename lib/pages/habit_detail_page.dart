import 'package:R_HabitTracker/components/my_heat_map.dart';
import 'package:R_HabitTracker/database/app_database.dart';
import 'package:R_HabitTracker/database/habit_database.dart';
import 'package:R_HabitTracker/theme/app_spacing.dart';
import 'package:R_HabitTracker/utils/habit_util.dart';
import 'package:R_HabitTracker/utils/streak_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Detail view for a single habit: its own streaks and a heatmap of just
/// its history, tinted to its category color (as opposed to the
/// aggregate, multi-habit heatmap on the home tab).
class HabitDetailPage extends StatelessWidget {
  final int habitId;

  const HabitDetailPage({super.key, required this.habitId});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Consumer<HabitDatabase>(
      builder: (context, habitDatabase, _) {
        Habit? habit;
        for (final h in habitDatabase.currentHabits) {
          if (h.id == habitId) {
            habit = h;
            break;
          }
        }

        if (habit == null) {
          // the habit was deleted while this page was open (e.g. via the
          // list behind it) — just back out.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (Navigator.canPop(context)) Navigator.pop(context);
          });
          return const Scaffold(body: SizedBox.shrink());
        }

        final category = habitDatabase.categoryById(habit.category);
        final completedDays = habitDatabase.completedDaysFor(habit.id);
        final scheduledDays = parseFrequencyDays(habit.frequencyDays);
        final current = currentStreak(completedDays, scheduledDays);
        final best = bestStreak(completedDays, scheduledDays);

        return Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            foregroundColor: colorScheme.onSurface,
            elevation: 0,
            title: Text(habit.name),
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: category.color.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child:
                          Icon(category.icon, color: category.color, size: 24),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(habit.name, style: textTheme.headlineMedium),
                          Text(
                            habit.targetCount > 1
                                ? '${category.label} · ${habit.targetCount}${habit.unit != null ? ' ${habit.unit}' : ''}/jour'
                                : category.label,
                            style: textTheme.bodyMedium
                                ?.copyWith(color: category.color),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.local_fire_department_rounded,
                        iconColor: const Color(0xFFF97316),
                        label: 'Série actuelle',
                        value: '$current',
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.emoji_events_rounded,
                        iconColor: category.color,
                        label: 'Record',
                        value: '$best',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                Text('Historique', style: textTheme.titleLarge),
                const SizedBox(height: AppSpacing.sm),
                FutureBuilder<DateTime?>(
                  future: habitDatabase.getFirstLaunch(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const SizedBox.shrink();
                    return MyHeatMap(
                      startDate: snapshot.data!,
                      datasets: prepareHabitHeatMapDataset(completedDays),
                      accentColor: category.color,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.secondary,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(height: AppSpacing.xs),
          Text(value, style: textTheme.headlineMedium),
          Text(label, style: textTheme.labelSmall),
        ],
      ),
    );
  }
}

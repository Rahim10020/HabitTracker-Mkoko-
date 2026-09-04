import 'package:R_HabitTracker/theme/app_spacing.dart';
import 'package:R_HabitTracker/components/animated_progress_indicator.dart';
import 'package:flutter/material.dart';

class HomeSummaryHeader extends StatelessWidget {
  final int completedCount;
  final int totalCount;

  const HomeSummaryHeader({
    super.key,
    required this.completedCount,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final progress = totalCount == 0 ? 0.0 : completedCount / totalCount;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.sm,
        AppSpacing.xl,
        AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Aujourd\'hui', style: textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '$completedCount/$totalCount habitudes complétées',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          AnimatedProgressIndicator(
            progress: progress,
            backgroundColor: colorScheme.secondary,
            valueColor: colorScheme.primary,
          ),
        ],
      ),
    );
  }
}

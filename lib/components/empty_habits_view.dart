import 'package:R_HabitTracker/icons/app_icons.dart';
import 'package:R_HabitTracker/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class EmptyHabitsView extends StatelessWidget {
  final VoidCallback onCreatePressed;

  const EmptyHabitsView({super.key, required this.onCreatePressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.xxxl,
      ),
      child: Column(
        children: [
          SizedBox(
            width: 88,
            height: 88,
            child: Icon(Icons.self_improvement_rounded,
                size: 54, color: colorScheme.primary),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Aucune habitude pour l\'instant',
            style: textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Crée ta première habitude pour commencer à suivre tes progrès.',
            style: textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          ElevatedButton.icon(
            onPressed: onCreatePressed,
            icon: const AppSvgIcon(
              icon: AppIcon.add,
              size: 16,
              color: Colors.white,
            ),
            label: const Text(
              'Créer une habitude',
              style: TextStyle(fontSize: 16),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.md,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

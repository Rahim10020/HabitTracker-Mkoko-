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
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.self_improvement_rounded,
                size: 44, color: colorScheme.primary),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Aucune habitude pour l\'instant',
            style: textTheme.headlineMedium,
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
            icon: const Icon(Icons.add_rounded),
            label: const Text('Créer une habitude'),
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

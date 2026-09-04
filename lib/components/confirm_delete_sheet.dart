import 'package:R_HabitTracker/components/app_modal_sheet.dart';
import 'package:R_HabitTracker/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// Shows a destructive-confirmation bottom sheet. Returns true if the user
/// confirmed the deletion.
Future<bool> showConfirmDeleteSheet(
  BuildContext context, {
  required String habitName,
}) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => _ConfirmDeleteSheet(habitName: habitName),
  );
  return result ?? false;
}

class _ConfirmDeleteSheet extends StatelessWidget {
  final String habitName;

  const _ConfirmDeleteSheet({required this.habitName});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AppModalSheet(
      title: 'Supprimer « $habitName » ?',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: AppSpacing.lg),
              decoration: BoxDecoration(
                color: colorScheme.outline,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Cette action supprime aussi tout l\'historique de complétion de cette habitude. C\'est irréversible.',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: OutlinedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                  ),
                  child: const Text('Annuler'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.error,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding:
                        const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                  ),
                  child: const Text('Supprimer'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

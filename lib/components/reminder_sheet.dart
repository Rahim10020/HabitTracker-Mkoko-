import 'package:R_HabitTracker/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class ReminderResult {
  final bool enabled;
  final TimeOfDay? time; // null when enabled is false

  const ReminderResult({required this.enabled, this.time});
}

/// Shows the reminder form as a modal bottom sheet and returns a
/// [ReminderResult], or null if the user cancelled.
Future<ReminderResult?> showReminderSheet(
  BuildContext context, {
  TimeOfDay? initialTime,
}) {
  return showModalBottomSheet<ReminderResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _ReminderSheet(initialTime: initialTime),
  );
}

class _ReminderSheet extends StatefulWidget {
  final TimeOfDay? initialTime;

  const _ReminderSheet({required this.initialTime});

  @override
  State<_ReminderSheet> createState() => _ReminderSheetState();
}

class _ReminderSheetState extends State<_ReminderSheet> {
  late bool enabled = widget.initialTime != null;
  late TimeOfDay time =
      widget.initialTime ?? const TimeOfDay(hour: 8, minute: 0);

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: time);
    if (picked != null) setState(() => time = picked);
  }

  void _save() {
    Navigator.pop(context, ReminderResult(enabled: enabled, time: time));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.md,
          AppSpacing.xl,
          AppSpacing.xl,
        ),
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
            Text('Rappel', style: textTheme.headlineMedium),
            const SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Activer un rappel', style: textTheme.titleLarge),
                Switch(
                  value: enabled,
                  activeThumbColor: colorScheme.primary,
                  onChanged: (v) => setState(() => enabled = v),
                ),
              ],
            ),
            if (enabled) ...[
              const SizedBox(height: AppSpacing.sm),
              GestureDetector(
                onTap: _pickTime,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.secondary,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.access_time_rounded,
                          color: colorScheme.onSurfaceVariant, size: 20),
                      const SizedBox(width: AppSpacing.sm),
                      Text(time.format(context), style: textTheme.bodyLarge),
                      const Spacer(),
                      Text('Modifier',
                          style: TextStyle(color: colorScheme.primary)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Le rappel ne sonne que les jours programmés de l\'habitude.',
                style: textTheme.labelSmall
                    ?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
            ],
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  elevation: 0,
                ),
                child: const Text('Enregistrer'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

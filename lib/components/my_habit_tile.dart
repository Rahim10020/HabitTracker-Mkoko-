import 'package:R_HabitTracker/theme/app_colors.dart';
import 'package:R_HabitTracker/theme/app_spacing.dart';
import 'package:R_HabitTracker/utils/habit_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyHabitTile extends StatelessWidget {
  final bool isCompleted;
  final String text;
  final HabitCategory category;
  final int targetCount;
  final String? unit;
  final int streak;

  // current progress for today (0..targetCount). Only meaningful — and
  // only used — when targetCount > 1 (quantifiable habits).
  final int currentValue;

  // "HH:mm", or null if no reminder is set. Tapping the bell (always
  // shown) opens the reminder sheet via onReminderTap.
  final String? reminderTime;
  final VoidCallback? onReminderTap;

  // simple on/off toggle — used when targetCount == 1.
  final Function(bool?)? onChanged;

  // +/- stepper — used when targetCount > 1.
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;

  final Function(BuildContext)? onEditPressed;
  final Function(BuildContext)? onDeletePressed;

  // optional drag handle for reordering (e.g. a ReorderableDragStartListener
  // wrapping a grip icon). Rendered at the tile's leading edge, before the
  // category icon, when provided. Kept as an injected widget rather than a
  // callback so the tile itself doesn't need to know about
  // ReorderableListView's index/listener plumbing.
  final Widget? dragHandle;

  const MyHabitTile({
    super.key,
    required this.isCompleted,
    required this.text,
    required this.category,
    required this.targetCount,
    required this.unit,
    required this.streak,
    this.currentValue = 0,
    this.reminderTime,
    this.onReminderTap,
    required this.onChanged,
    this.onIncrement,
    this.onDecrement,
    required this.onEditPressed,
    required this.onDeletePressed,
    this.dragHandle,
  });

  bool get _isQuantifiable => targetCount > 1;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final tileBody = Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.secondary, // card surface (see theme notes)
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: isCompleted ? 0 : 1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (dragHandle != null) ...[
            dragHandle!,
            const SizedBox(width: AppSpacing.xs),
          ],
          // category icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: category.color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(category.icon, color: category.color, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          // name + meta (+ progress bar for quantifiable habits)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: textTheme.bodyLarge?.copyWith(
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                    color: isCompleted
                        ? colorScheme.onSurfaceVariant
                        : colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    if (streak > 0) ...[
                      const Icon(Icons.local_fire_department_rounded,
                          size: 14, color: Color(0xFFF97316)),
                      const SizedBox(width: 2),
                      Text('$streak', style: textTheme.labelSmall),
                      const SizedBox(width: AppSpacing.sm),
                    ],
                    GestureDetector(
                      onTap: onReminderTap,
                      child: Row(
                        children: [
                          Icon(
                            reminderTime != null
                                ? Icons.notifications_active_rounded
                                : Icons.notifications_none_rounded,
                            size: 14,
                            color: reminderTime != null
                                ? colorScheme.primary
                                : colorScheme.onSurfaceVariant,
                          ),
                          if (reminderTime != null) ...[
                            const SizedBox(width: 2),
                            Text(reminderTime!, style: textTheme.labelSmall),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                if (_isQuantifiable) ...[
                  const SizedBox(height: AppSpacing.xs),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    child: LinearProgressIndicator(
                      value: (currentValue / targetCount).clamp(0.0, 1.0),
                      minHeight: 5,
                      backgroundColor:
                          colorScheme.outline.withValues(alpha: 0.3),
                      valueColor: AlwaysStoppedAnimation(
                        isCompleted
                            ? AppColors.lightSuccess
                            : colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          // trailing control: check toggle (simple) or +/- stepper (quantifiable)
          _isQuantifiable
              ? _ProgressStepper(
                  currentValue: currentValue,
                  targetCount: targetCount,
                  unit: unit,
                  isCompleted: isCompleted,
                  onIncrement: onIncrement,
                  onDecrement: onDecrement,
                )
              : _CompletionCheck(
                  isCompleted: isCompleted,
                  onTap: () => onChanged?.call(!isCompleted),
                ),
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.xs,
        horizontal: AppSpacing.xl,
      ),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          extentRatio: 0.4,
          children: [
            SlidableAction(
              onPressed: onEditPressed,
              backgroundColor: colorScheme.tertiary,
              foregroundColor: Colors.white,
              icon: Icons.edit_rounded,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppRadius.sm),
                bottomLeft: Radius.circular(AppRadius.sm),
              ),
            ),
            SlidableAction(
              onPressed: onDeletePressed,
              backgroundColor: AppColors.lightError,
              foregroundColor: Colors.white,
              icon: Icons.delete_rounded,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(AppRadius.lg),
                bottomRight: Radius.circular(AppRadius.lg),
              ),
            ),
          ],
        ),
        // quantifiable habits are driven entirely by the +/- stepper, so
        // the whole-tile tap-to-toggle only applies to simple habits.
        child: _isQuantifiable
            ? tileBody
            : GestureDetector(
                onTap: () => onChanged?.call(!isCompleted),
                child: tileBody,
              ),
      ),
    );
  }
}

class _CompletionCheck extends StatelessWidget {
  final bool isCompleted;
  final VoidCallback onTap;

  const _CompletionCheck({required this.isCompleted, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isCompleted ? AppColors.lightSuccess : Colors.transparent,
          border: Border.all(
            color: isCompleted
                ? AppColors.lightSuccess
                : colorScheme.onSurfaceVariant,
            width: 1.5,
          ),
        ),
        child: isCompleted
            ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
            : null,
      ),
    );
  }
}

// +/- stepper for quantifiable habits (e.g. "8 glasses of water"). Shows
// the current/target count and lets the user log progress one unit at a
// time; buttons disable themselves at the 0 and targetCount bounds.
class _ProgressStepper extends StatelessWidget {
  final int currentValue;
  final int targetCount;
  final String? unit;
  final bool isCompleted;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;

  const _ProgressStepper({
    required this.currentValue,
    required this.targetCount,
    required this.unit,
    required this.isCompleted,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _StepperButton(
              icon: Icons.remove_rounded,
              onTap: currentValue > 0 ? onDecrement : null,
            ),
            SizedBox(
              width: 28,
              child: Text(
                '$currentValue',
                textAlign: TextAlign.center,
                style: textTheme.labelLarge?.copyWith(
                  color: isCompleted
                      ? AppColors.lightSuccess
                      : colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            _StepperButton(
              icon: Icons.add_rounded,
              onTap: currentValue < targetCount ? onIncrement : null,
            ),
          ],
        ),
        Text(
          '/ $targetCount${unit != null && unit!.isNotEmpty ? ' ${unit!}' : ''}',
          style: textTheme.labelSmall
              ?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _StepperButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: enabled
              ? colorScheme.primary.withValues(alpha: 0.12)
              : colorScheme.outline.withValues(alpha: 0.08),
        ),
        child: Icon(
          icon,
          size: 16,
          color: enabled
              ? colorScheme.primary
              : colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}

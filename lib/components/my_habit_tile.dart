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
  final Function(bool?)? onChanged;
  final Function(BuildContext)? onEditPressed;
  final Function(BuildContext)? onDeletePressed;

  const MyHabitTile({
    super.key,
    required this.isCompleted,
    required this.text,
    required this.category,
    required this.targetCount,
    required this.unit,
    required this.streak,
    required this.onChanged,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
        child: GestureDetector(
          onTap: () => onChanged?.call(!isCompleted),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: colorScheme.secondary, // card surface (see theme notes)
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(
                color: colorScheme.outline.withOpacity(isCompleted ? 0 : 1),
              ),
            ),
            child: Row(
              children: [
                // category icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: category.color.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(category.icon, color: category.color, size: 20),
                ),
                const SizedBox(width: AppSpacing.md),
                // name + meta row
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        style: textTheme.bodyLarge?.copyWith(
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : null,
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
                          if (targetCount > 1) ...[
                            Icon(Icons.flag_rounded,
                                size: 14, color: colorScheme.onSurfaceVariant),
                            const SizedBox(width: 2),
                            Text(
                              '$targetCount${unit != null && unit!.isNotEmpty ? ' ${unit!}' : ''}',
                              style: textTheme.labelSmall,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                // completion toggle
                _CompletionCheck(isCompleted: isCompleted, onTap: () {
                  onChanged?.call(!isCompleted);
                }),
              ],
            ),
          ),
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

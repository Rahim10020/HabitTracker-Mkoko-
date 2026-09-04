import 'package:R_HabitTracker/components/animated_progress_indicator.dart';
import 'package:R_HabitTracker/theme/app_colors.dart';
import 'package:R_HabitTracker/theme/app_spacing.dart';
import 'package:R_HabitTracker/utils/habit_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyHabitTile extends StatefulWidget {
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

  @override
  State<MyHabitTile> createState() => _MyHabitTileState();
}

class _MyHabitTileState extends State<MyHabitTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );

  bool get _isQuantifiable => widget.targetCount > 1;

  @override
  void didUpdateWidget(covariant MyHabitTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    final wasComplete = oldWidget.currentValue >= oldWidget.targetCount;
    final isComplete = widget.currentValue >= widget.targetCount;
    if (widget.targetCount > 1 && !wasComplete && isComplete) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
          color:
              colorScheme.outline.withValues(alpha: widget.isCompleted ? 0 : 1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.dragHandle != null) ...[
            widget.dragHandle!,
            const SizedBox(width: AppSpacing.xs),
          ],
          // category icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: widget.category.color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(widget.category.icon,
                color: widget.category.color, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          // name + meta (+ progress bar for quantifiable habits)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.text,
                  style: textTheme.bodyLarge?.copyWith(
                    decoration:
                        widget.isCompleted ? TextDecoration.lineThrough : null,
                    color: widget.isCompleted
                        ? colorScheme.onSurfaceVariant
                        : colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    if (widget.streak > 0) ...[
                      const Icon(Icons.local_fire_department_rounded,
                          size: 14, color: Color(0xFFF97316)),
                      const SizedBox(width: 2),
                      Text('${widget.streak}', style: textTheme.labelSmall),
                      const SizedBox(width: AppSpacing.sm),
                    ],
                    GestureDetector(
                      onTap: widget.onReminderTap,
                      child: Row(
                        children: [
                          Icon(
                            widget.reminderTime != null
                                ? Icons.notifications_active_rounded
                                : Icons.notifications_none_rounded,
                            size: 14,
                            color: widget.reminderTime != null
                                ? colorScheme.primary
                                : colorScheme.onSurfaceVariant,
                          ),
                          if (widget.reminderTime != null) ...[
                            const SizedBox(width: 2),
                            Text(widget.reminderTime!,
                                style: textTheme.labelSmall),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                if (_isQuantifiable) ...[
                  const SizedBox(height: AppSpacing.xs),
                  AnimatedProgressIndicator(
                    progress: widget.currentValue / widget.targetCount,
                    minHeight: 5,
                    duration: const Duration(milliseconds: 350),
                    backgroundColor: colorScheme.outline.withValues(alpha: 0.3),
                    valueColor: widget.isCompleted
                        ? AppColors.lightSuccess
                        : colorScheme.primary,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          // trailing control: check toggle (simple) or +/- stepper (quantifiable)
          _isQuantifiable
              ? _ProgressStepper(
                  currentValue: widget.currentValue,
                  targetCount: widget.targetCount,
                  unit: widget.unit,
                  isCompleted: widget.isCompleted,
                  onIncrement: widget.onIncrement,
                  onDecrement: widget.onDecrement,
                )
              : _CompletionCheck(
                  isCompleted: widget.isCompleted,
                  onTap: () => widget.onChanged?.call(!widget.isCompleted),
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
              onPressed: widget.onEditPressed,
              backgroundColor: colorScheme.tertiary,
              foregroundColor: Colors.white,
              icon: Icons.edit_rounded,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppRadius.sm),
                bottomLeft: Radius.circular(AppRadius.sm),
              ),
            ),
            SlidableAction(
              onPressed: widget.onDeletePressed,
              backgroundColor: colorScheme.error,
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
                onTap: () => widget.onChanged?.call(!widget.isCompleted),
                child: tileBody,
              ),
      ),
    );
  }
}

class _CompletionCheck extends StatefulWidget {
  final bool isCompleted;
  final VoidCallback onTap;

  const _CompletionCheck({required this.isCompleted, required this.onTap});

  @override
  @override
  State<_CompletionCheck> createState() => _CompletionCheckState();
}

class _CompletionCheckState extends State<_CompletionCheck>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
  );

  @override
  void didUpdateWidget(covariant _CompletionCheck oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isCompleted != widget.isCompleted && mounted) {
      _controller.stop();
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        if (!widget.isCompleted) HapticFeedback.lightImpact();
        widget.onTap();
      },
      child: ScaleTransition(
        scale: _controller.drive(
          TweenSequence<double>([
            TweenSequenceItem(
              tween: Tween(begin: 1.0, end: 1.25)
                  .chain(CurveTween(curve: Curves.easeOut)),
              weight: 35,
            ),
            TweenSequenceItem(
              tween: Tween(begin: 1.25, end: 1.0)
                  .chain(CurveTween(curve: Curves.elasticOut)),
              weight: 65,
            ),
          ]),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.isCompleted
                ? AppColors.lightSuccess
                : Colors.transparent,
            border: Border.all(
              color: widget.isCompleted
                  ? AppColors.lightSuccess
                  : colorScheme.onSurfaceVariant,
              width: 1.5,
            ),
          ),
          child: widget.isCompleted
              ? AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) => CustomPaint(
                    size: const Size(18, 18),
                    painter: _CheckPainter(progress: _controller.value),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

class _CheckPainter extends CustomPainter {
  final double progress;

  const _CheckPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(size.width * 0.18, size.height * 0.52)
      ..lineTo(size.width * 0.43, size.height * 0.76)
      ..lineTo(size.width * 0.84, size.height * 0.28);
    final metric = path.computeMetrics().first;
    canvas.drawPath(metric.extractPath(0, metric.length * progress), paint);
  }

  @override
  bool shouldRepaint(covariant _CheckPainter oldDelegate) =>
      oldDelegate.progress != progress;
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

class _StepperButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _StepperButton({required this.icon, required this.onTap});

  @override
  State<_StepperButton> createState() => _StepperButtonState();
}

class _StepperButtonState extends State<_StepperButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final enabled = widget.onTap != null;
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
      onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
      onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
      child: AnimatedScale(
        scale: _pressed ? 0.88 : 1,
        duration: const Duration(milliseconds: 100),
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
            widget.icon,
            size: 16,
            color: enabled
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
          ),
        ),
      ),
    );
  }
}

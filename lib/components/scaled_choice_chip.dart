import 'package:R_HabitTracker/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class ScaledChoiceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;
  final Color selectedColor;
  final IconData? avatar;
  final Color? avatarColor;

  const ScaledChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
    required this.selectedColor,
    this.avatar,
    this.avatarColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1, end: selected ? 1.08 : 1),
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) => Transform.scale(
        scale: scale,
        child: child,
      ),
      child: ChoiceChip(
        label: Text(label),
        avatar: avatar == null
            ? null
            : Icon(
                avatar,
                size: 16,
                color: selected ? Colors.white : avatarColor,
              ),
        selected: selected,
        onSelected: (_) => onSelected(),
        selectedColor: selectedColor,
        backgroundColor: colorScheme.secondary,
        labelStyle: TextStyle(
          color: selected ? Colors.white : colorScheme.onSurface,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.full),
          side: BorderSide.none,
        ),
      ),
    );
  }
}

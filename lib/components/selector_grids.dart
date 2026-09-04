import 'package:R_HabitTracker/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class IconSelectorGrid extends StatelessWidget {
  final List<IconData> icons;
  final IconData selected;
  final ValueChanged<IconData> onSelected;
  final Color accentColor;

  const IconSelectorGrid({
    super.key,
    required this.icons,
    required this.selected,
    required this.onSelected,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: icons.map((icon) {
        final isSelected = icon == selected;
        return GestureDetector(
          onTap: () => onSelected(icon),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? accentColor.withValues(alpha: 0.2)
                  : colorScheme.secondary,
              border:
                  isSelected ? Border.all(color: accentColor, width: 2) : null,
            ),
            child: Icon(
              icon,
              size: 20,
              color: isSelected ? accentColor : colorScheme.onSurfaceVariant,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class ColorSelectorGrid extends StatelessWidget {
  final List<Color> colors;
  final Color selected;
  final ValueChanged<Color> onSelected;

  const ColorSelectorGrid({
    super.key,
    required this.colors,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: colors.map((color) {
        final isSelected = color == selected;
        return GestureDetector(
          onTap: () => onSelected(color),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              border: isSelected
                  ? Border.all(color: colorScheme.onSurface, width: 2)
                  : null,
            ),
            child: isSelected
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                : null,
          ),
        );
      }).toList(),
    );
  }
}

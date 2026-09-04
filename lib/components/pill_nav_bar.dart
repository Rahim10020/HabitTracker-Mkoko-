import 'package:R_HabitTracker/icons/app_icons.dart';
import 'package:R_HabitTracker/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class PillNavItem {
  final AppIcon icon;

  const PillNavItem({required this.icon});
}

class PillNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final List<PillNavItem> items;
  final double height;

  const PillNavBar({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
    required this.items,
    this.height = 62,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(AppRadius.full);

    return Container(
      width: items.length * 62,
      height: height,
      decoration: BoxDecoration(
        color: colorScheme.secondary,
        border: BoxBorder.all(color: colorScheme.onSurface, width: 2),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            for (var index = 0; index < items.length; index++)
              Expanded(
                child: _PillNavItem(
                  icon: items[index].icon,
                  selected: index == selectedIndex,
                  height: height,
                  onTap: () => onChanged(index),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PillNavItem extends StatelessWidget {
  final AppIcon icon;
  final bool selected;
  final double height;
  final VoidCallback onTap;

  const _PillNavItem({
    required this.icon,
    required this.selected,
    required this.height,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 62,
        height: height,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: selected ? colorScheme.primary : Colors.transparent,
            ),
            alignment: Alignment.center,
            child: AppSvgIcon(
              icon: icon,
              color: selected ? Colors.white : colorScheme.onSurface,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}

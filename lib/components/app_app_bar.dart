import 'package:R_HabitTracker/icons/app_icons.dart';
import 'package:flutter/material.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final VoidCallback? onSearchPressed;

  const AppAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.onSearchPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: titleWidget ?? (title == null ? null : Text(title!)),
      backgroundColor: Colors.transparent,
      foregroundColor: Theme.of(context).colorScheme.onSurface,
      elevation: 0,
      actions: [
        if (onSearchPressed != null)
          IconButton(
            onPressed: onSearchPressed,
            tooltip: 'Rechercher',
            icon: const AppSvgIcon(icon: AppIcon.search),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

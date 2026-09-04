import 'package:R_HabitTracker/components/celebration_overlay.dart';
import 'package:R_HabitTracker/components/pill_nav_bar.dart';
import 'package:R_HabitTracker/database/habit_database.dart';
import 'package:R_HabitTracker/pages/home_page.dart';
import 'package:R_HabitTracker/pages/settings_page.dart';
import 'package:R_HabitTracker/pages/stats_page.dart';
import 'package:R_HabitTracker/theme/app_spacing.dart';
import 'package:R_HabitTracker/utils/habit_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Root navigation shell — replaces the old side [Drawer] with a bottom
/// bar: a [PillNavBar] (Home / Stats / Réglages, icon-only) plus a
/// separate round "add habit" button at the same level, always visible
/// regardless of the active tab.
class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;
  final _celebrationKey = GlobalKey<CelebrationOverlayState>();

  static const _pages = [
    HomePage(),
    StatsPage(),
    SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    final database = context.read<HabitDatabase>();
    database.onDayCompleted =
        () => _celebrationKey.currentState?.show(const DayCompleted());
    database.onStreakMilestone =
        (days) => _celebrationKey.currentState?.show(StreakMilestone(days));
  }

  @override
  void dispose() {
    final database = context.read<HabitDatabase>();
    database.onDayCompleted = null;
    database.onStreakMilestone = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            switchInCurve: Curves.easeOutCubic,
            transitionBuilder: (child, animation) => SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.025, 0),
                end: Offset.zero,
              ).animate(animation),
              child: FadeTransition(opacity: animation, child: child),
            ),
            child: KeyedSubtree(key: ValueKey(_index), child: _pages[_index]),
          ),
          CelebrationOverlay(key: _celebrationKey),
        ],
      ),
      bottomNavigationBar: Container(
        color: colorScheme.surface,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PillNavBar(
                  selectedIndex: _index,
                  onChanged: (i) => setState(() => _index = i),
                  items: const [
                    PillNavItem(icon: Icons.home_rounded),
                    PillNavItem(icon: Icons.insights_rounded),
                    PillNavItem(icon: Icons.settings_rounded),
                  ],
                ),
                const SizedBox(width: AppSpacing.sm),
                _AddHabitButton(onPressed: () => createNewHabit(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Round "add habit" button, sitting at the same level as [PillNavBar]
/// instead of a page-level FAB.
class _AddHabitButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _AddHabitButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: colorScheme.primary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: const Icon(Icons.add_rounded, color: Colors.white),
        ),
      ),
    );
  }
}

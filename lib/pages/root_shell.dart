import 'package:R_HabitTracker/components/celebration_overlay.dart';
import 'package:R_HabitTracker/database/habit_database.dart';
import 'package:R_HabitTracker/pages/home_page.dart';
import 'package:R_HabitTracker/pages/settings_page.dart';
import 'package:R_HabitTracker/pages/stats_page.dart';
import 'package:R_HabitTracker/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

/// Root navigation shell — replaces the old side [Drawer] with a bottom
/// nav bar (Home / Stats / Réglages) built on google_nav_bar.
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
        decoration: BoxDecoration(
          color: colorScheme.secondary, // card-role surface, see theme notes
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: GNav(
              gap: AppSpacing.sm,
              activeColor: Colors.white,
              color: colorScheme.onSurfaceVariant,
              tabBackgroundColor: colorScheme.primary,
              tabBorderRadius: AppRadius.full,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              selectedIndex: _index,
              onTabChange: (i) => setState(() => _index = i),
              tabs: const [
                GButton(icon: Icons.home_rounded, text: 'Accueil'),
                GButton(icon: Icons.insights_rounded, text: 'Stats'),
                GButton(icon: Icons.settings_rounded, text: 'Réglages'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

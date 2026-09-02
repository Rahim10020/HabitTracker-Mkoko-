import 'package:R_HabitTracker/pages/home_page.dart';
import 'package:R_HabitTracker/pages/settings_page.dart';
import 'package:R_HabitTracker/pages/stats_page.dart';
import 'package:R_HabitTracker/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

/// Root navigation shell — replaces the old side [Drawer] with a bottom
/// nav bar (Home / Stats / Réglages) built on google_nav_bar.
class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;

  static const _pages = [
    HomePage(),
    StatsPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colorScheme.secondary, // card-role surface, see theme notes
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
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

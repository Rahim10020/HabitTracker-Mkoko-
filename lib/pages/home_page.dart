import 'package:R_HabitTracker/components/confirm_delete_sheet.dart';
import 'package:R_HabitTracker/components/app_app_bar.dart';
import 'package:R_HabitTracker/components/app_text_field.dart';
import 'package:R_HabitTracker/components/empty_habits_view.dart';
import 'package:R_HabitTracker/components/habit_form_sheet.dart';
import 'package:R_HabitTracker/components/home_summary_header.dart';
import 'package:R_HabitTracker/components/my_habit_tile.dart';
import 'package:R_HabitTracker/components/my_heat_map.dart';
import 'package:R_HabitTracker/components/reminder_sheet.dart';
import 'package:R_HabitTracker/database/app_database.dart';
import 'package:R_HabitTracker/database/habit_database.dart';
import 'package:R_HabitTracker/icons/app_icons.dart';
import 'package:R_HabitTracker/utils/habit_util.dart';
import 'package:R_HabitTracker/utils/streak_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) _searchController.clear();
    });
  }

  @override
  void initState() {
    // we gonna read existing habits (and custom categories) on app startup
    final habitDatabase = Provider.of<HabitDatabase>(context, listen: false);
    habitDatabase.readHabits();
    habitDatabase.readCategories();
    super.initState();
  }

  Future<void> createNewHabit() async {
    final result = await showHabitFormSheet(context);
    if (result == null || !mounted) return;
    context.read<HabitDatabase>().addHabit(
          result.name,
          category: result.category,
          frequencyType: result.frequencyType,
          frequencyDays: result.frequencyDays,
          targetCount: result.targetCount,
          unit: result.unit,
        );
  }

  void checkHabitOnAndOff(bool? value, Habit habit) {
    if (value != null) {
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
    }
  }

  void incrementHabit(Habit habit) {
    context.read<HabitDatabase>().adjustHabitProgress(habit.id, 1);
  }

  void decrementHabit(Habit habit) {
    context.read<HabitDatabase>().adjustHabitProgress(habit.id, -1);
  }

  Future<void> editHabitBox(Habit habit) async {
    final result = await showHabitFormSheet(
      context,
      initialName: habit.name,
      initialCategory: habit.category,
      initialFrequencyType: habit.frequencyType,
      initialFrequencyDays: habit.frequencyDays,
      initialTargetCount: habit.targetCount,
      initialUnit: habit.unit,
    );
    if (result == null || !mounted) return;
    context.read<HabitDatabase>().updateHabit(
          habit.id,
          name: result.name,
          category: result.category,
          frequencyType: result.frequencyType,
          frequencyDays: result.frequencyDays,
          targetCount: result.targetCount,
          unit: result.unit,
        );
  }

  Future<void> deleteHabitBox(Habit habit) async {
    final confirmed =
        await showConfirmDeleteSheet(context, habitName: habit.name);
    if (!confirmed || !mounted) return;
    context.read<HabitDatabase>().deleteHabit(habit.id);
  }

  Future<void> openReminderSheet(Habit habit) async {
    TimeOfDay? initialTime;
    if (habit.reminderTime != null) {
      final parts = habit.reminderTime!.split(':');
      initialTime =
          TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }

    final result = await showReminderSheet(context, initialTime: initialTime);
    if (result == null || !mounted) return;
    context
        .read<HabitDatabase>()
        .setReminder(habit.id, result.enabled ? result.time : null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        titleWidget: _isSearching
            ? Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: _searchController,
                      hintText: 'Rechercher une habitude',
                      autofocus: true,
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  IconButton(
                    onPressed: _toggleSearch,
                    tooltip: 'Fermer la recherche',
                    icon: const AppSvgIcon(icon: AppIcon.close),
                  ),
                ],
              )
            : null,
        onSearchPressed: _isSearching ? null : _toggleSearch,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Consumer<HabitDatabase>(
        builder: (context, habitDatabase, _) {
          if (habitDatabase.currentHabits.isEmpty) {
            return EmptyHabitsView(onCreatePressed: createNewHabit);
          }
          return Column(
            children: [
              _buildSummaryHeader(habitDatabase),
              _buildHeatMap(habitDatabase),
              Expanded(child: _buildHabitList(habitDatabase)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryHeader(HabitDatabase habitDatabase) {
    final habits = habitDatabase.currentHabits;
    final completedToday = habits
        .where(
            (h) => isHabitCompletedToday(habitDatabase.completedDaysFor(h.id)))
        .length;
    return HomeSummaryHeader(
      completedCount: completedToday,
      totalCount: habits.length,
    );
  }

  Widget _buildHeatMap(HabitDatabase habitDatabase) {
    return FutureBuilder<DateTime?>(
      future: habitDatabase.getFirstLaunch(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MyHeatMap(
            startDate: snapshot.data!,
            datasets: prepareHeatMapDataset(habitDatabase.completedDaysByHabit),
          );
        }
        return Container();
      },
    );
  }

  Widget _buildHabitList(HabitDatabase habitDatabase) {
    final query = _searchController.text.trim().toLowerCase();
    final currentHabits = habitDatabase.currentHabits
        .where((habit) =>
            query.isEmpty || habit.name.toLowerCase().contains(query))
        .toList();
    final colorScheme = Theme.of(context).colorScheme;
    if (currentHabits.isEmpty) {
      return Center(
        child: Text(
          'Aucune habitude trouvée',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }
    return ReorderableListView.builder(
      itemCount: currentHabits.length,
      padding: const EdgeInsets.only(bottom: 100),
      // only the explicit grip icon (below) starts a drag — the default
      // whole-tile long-press handle is turned off so it doesn't fight
      // with the tile's Slidable swipe-to-edit/delete gesture.
      buildDefaultDragHandles: false,
      onReorderItem: query.isEmpty
          ? (oldIndex, newIndex) =>
              habitDatabase.reorderHabits(oldIndex, newIndex)
          : (_, __) {},
      itemBuilder: (context, index) {
        final habit = currentHabits[index];
        final completedDays = habitDatabase.completedDaysFor(habit.id);
        final scheduledDays = parseFrequencyDays(habit.frequencyDays);
        bool isCompletedToday = isHabitCompletedToday(completedDays);

        return _AnimatedListItem(
          key: ValueKey(habit.id),
          child: MyHabitTile(
            isCompleted: isCompletedToday,
            text: habit.name,
            category: habitDatabase.categoryById(habit.category),
            targetCount: habit.targetCount,
            unit: habit.unit,
            streak: currentStreak(completedDays, scheduledDays),
            currentValue: habitDatabase.progressFor(habit.id),
            reminderTime: habit.reminderTime,
            onReminderTap: () => openReminderSheet(habit),
            onChanged: (value) => checkHabitOnAndOff(value, habit),
            onIncrement: () => incrementHabit(habit),
            onDecrement: () => decrementHabit(habit),
            onEditPressed: (context) => editHabitBox(habit),
            onDeletePressed: (context) => deleteHabitBox(habit),
            dragHandle: ReorderableDragStartListener(
              index: index,
              child: Icon(Icons.drag_indicator_rounded,
                  color: colorScheme.onSurfaceVariant),
            ),
          ),
        );
      },
    );
  }
}

class _AnimatedListItem extends StatefulWidget {
  final Widget child;

  const _AnimatedListItem({super.key, required this.child});

  @override
  State<_AnimatedListItem> createState() => _AnimatedListItemState();
}

class _AnimatedListItemState extends State<_AnimatedListItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  )..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.08),
          end: Offset.zero,
        ).animate(animation),
        child: widget.child,
      ),
    );
  }
}

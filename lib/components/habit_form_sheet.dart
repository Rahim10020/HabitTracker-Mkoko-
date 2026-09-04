import 'package:R_HabitTracker/components/app_text_field.dart';
import 'package:R_HabitTracker/components/new_category_sheet.dart';
import 'package:R_HabitTracker/database/habit_database.dart';
import 'package:R_HabitTracker/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HabitFormResult {
  final String name;
  final String category;
  final String frequencyType; // 'daily' | 'weekly'
  final String frequencyDays; // comma-separated ISO weekdays
  final int targetCount;
  final String? unit;

  const HabitFormResult({
    required this.name,
    required this.category,
    required this.frequencyType,
    required this.frequencyDays,
    required this.targetCount,
    required this.unit,
  });
}

const _weekdayLabels = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];

/// Shows the create/edit habit form as a modal bottom sheet and returns a
/// [HabitFormResult], or null if the user cancelled.
Future<HabitFormResult?> showHabitFormSheet(
  BuildContext context, {
  String? initialName,
  String initialCategory = 'other',
  String initialFrequencyType = 'daily',
  String initialFrequencyDays = '1,2,3,4,5,6,7',
  int initialTargetCount = 1,
  String? initialUnit,
}) {
  return showModalBottomSheet<HabitFormResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _HabitFormSheet(
      initialName: initialName,
      initialCategory: initialCategory,
      initialFrequencyType: initialFrequencyType,
      initialFrequencyDays: initialFrequencyDays,
      initialTargetCount: initialTargetCount,
      initialUnit: initialUnit,
    ),
  );
}

class _HabitFormSheet extends StatefulWidget {
  final String? initialName;
  final String initialCategory;
  final String initialFrequencyType;
  final String initialFrequencyDays;
  final int initialTargetCount;
  final String? initialUnit;

  const _HabitFormSheet({
    required this.initialName,
    required this.initialCategory,
    required this.initialFrequencyType,
    required this.initialFrequencyDays,
    required this.initialTargetCount,
    required this.initialUnit,
  });

  @override
  State<_HabitFormSheet> createState() => _HabitFormSheetState();
}

class _HabitFormSheetState extends State<_HabitFormSheet> {
  late final TextEditingController nameController =
      TextEditingController(text: widget.initialName ?? '');
  late final TextEditingController unitController =
      TextEditingController(text: widget.initialUnit ?? '');

  late String category = widget.initialCategory;
  late String frequencyType = widget.initialFrequencyType;
  late Set<int> selectedDays = widget.initialFrequencyDays
      .split(',')
      .where((s) => s.trim().isNotEmpty)
      .map(int.parse)
      .toSet();
  late bool isQuantifiable = widget.initialTargetCount > 1;
  late int targetCount =
      widget.initialTargetCount > 1 ? widget.initialTargetCount : 1;

  @override
  void dispose() {
    nameController.dispose();
    unitController.dispose();
    super.dispose();
  }

  Future<void> _createCategory(BuildContext context) async {
    final key = await showNewCategorySheet(context);
    if (key == null || !mounted) return;
    setState(() => category = key);
  }

  void _submit() {
    final name = nameController.text.trim();
    if (name.isEmpty) return;

    final days = frequencyType == 'daily'
        ? [1, 2, 3, 4, 5, 6, 7]
        : (selectedDays.isEmpty ? [1, 2, 3, 4, 5, 6, 7] : selectedDays.toList()
          ..sort());

    Navigator.pop(
      context,
      HabitFormResult(
        name: name,
        category: category,
        frequencyType: frequencyType,
        frequencyDays: days.join(','),
        targetCount: isQuantifiable ? targetCount : 1,
        unit: isQuantifiable && unitController.text.trim().isNotEmpty
            ? unitController.text.trim()
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isEditing = widget.initialName != null;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.md,
          AppSpacing.xl,
          AppSpacing.xl,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: colorScheme.outline,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                ),
              ),
              Text(
                isEditing ? 'Modifier l\'habitude' : 'Nouvelle habitude',
                style: textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.lg),

               // name
               AppTextField(
                 controller: nameController,
                 hintText: 'Nom de l\'habitude',
                 autofocus: !isEditing,
               ),
              const SizedBox(height: AppSpacing.lg),

              // category
              Text('Catégorie', style: textTheme.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              Consumer<HabitDatabase>(
                builder: (context, habitDatabase, _) {
                  return Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      ...habitDatabase.allCategories.map((c) {
                        final selected = category == c.id;
                        return TweenAnimationBuilder<double>(
                          tween: Tween(begin: 1, end: selected ? 1.08 : 1),
                          duration: const Duration(milliseconds: 180),
                          curve: Curves.easeOutBack,
                          builder: (context, scale, child) => Transform.scale(
                            scale: scale,
                            child: child,
                          ),
                          child: ChoiceChip(
                            label: Text(c.label),
                            avatar: Icon(c.icon,
                                size: 16,
                                color: selected ? Colors.white : c.color),
                            selected: selected,
                            onSelected: (_) => setState(() => category = c.id),
                            selectedColor: c.color,
                            backgroundColor: colorScheme.secondary,
                            labelStyle: TextStyle(
                              color: selected
                                  ? Colors.white
                                  : colorScheme.onSurface,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppRadius.full),
                              side: BorderSide.none,
                            ),
                          ),
                        );
                      }),
                      ActionChip(
                        avatar: Icon(Icons.add_rounded,
                            size: 16, color: colorScheme.primary),
                        label: Text(
                          'Nouvelle catégorie',
                          style: TextStyle(color: colorScheme.primary),
                        ),
                        backgroundColor: colorScheme.secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.full),
                          side: BorderSide(color: colorScheme.primary),
                        ),
                        onPressed: () => _createCategory(context),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: AppSpacing.lg),

              // frequency
              Text('Fréquence', style: textTheme.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  ChoiceChip(
                    label: const Text('Tous les jours'),
                    selected: frequencyType == 'daily',
                    onSelected: (_) => setState(() => frequencyType = 'daily'),
                    backgroundColor: colorScheme.secondary,
                    selectedColor: colorScheme.primary,
                    labelStyle: TextStyle(
                      color: frequencyType == 'daily'
                          ? Colors.white
                          : colorScheme.onSurface,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      side: BorderSide.none,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  ChoiceChip(
                    label: const Text('Jours précis'),
                    selected: frequencyType == 'weekly',
                    onSelected: (_) => setState(() => frequencyType = 'weekly'),
                    backgroundColor: colorScheme.secondary,
                    selectedColor: colorScheme.primary,
                    labelStyle: TextStyle(
                      color: frequencyType == 'weekly'
                          ? Colors.white
                          : colorScheme.onSurface,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      side: BorderSide.none,
                    ),
                  ),
                ],
              ),
              if (frequencyType == 'weekly') ...[
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(7, (i) {
                    final weekday = i + 1; // 1=Mon..7=Sun
                    final selected = selectedDays.contains(weekday);
                    return GestureDetector(
                      onTap: () => setState(() {
                        selected
                            ? selectedDays.remove(weekday)
                            : selectedDays.add(weekday);
                      }),
                      child: AnimatedScale(
                        scale: selected ? 1.08 : 1,
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeOutBack,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: selected
                              ? colorScheme.primary
                              : colorScheme.secondary,
                          child: Text(
                            _weekdayLabels[i],
                            style: TextStyle(
                              color: selected
                                  ? Colors.white
                                  : colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),

              // quantifiable objective
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Objectif quantifiable', style: textTheme.titleLarge),
                  Switch(
                    value: isQuantifiable,
                    activeThumbColor: colorScheme.primary,
                    onChanged: (v) => setState(() => isQuantifiable = v),
                  ),
                ],
              ),
              if (isQuantifiable) ...[
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => setState(() {
                        if (targetCount > 1) targetCount--;
                      }),
                      icon: const Icon(Icons.remove_circle_outline_rounded),
                    ),
                    Text('$targetCount', style: textTheme.titleLarge),
                    IconButton(
                      onPressed: () => setState(() => targetCount++),
                      icon: const Icon(Icons.add_circle_outline_rounded),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: AppTextField(
                        controller: unitController,
                        hintText: 'Unité (ex: verres, pages, min)',
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: AppSpacing.xl),

              // save button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    elevation: 0,
                  ),
                  child: Text(isEditing ? 'Enregistrer' : 'Créer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:R_HabitTracker/theme/app_spacing.dart';
import 'package:R_HabitTracker/utils/habit_category.dart';
import 'package:flutter/material.dart';

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
              TextField(
                controller: nameController,
                autofocus: !isEditing,
                decoration: InputDecoration(
                  hintText: 'Nom de l\'habitude',
                  filled: true,
                  fillColor: colorScheme.secondary,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // category
              Text('Catégorie', style: textTheme.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: kHabitCategories.map((c) {
                  final selected = category == c.id;
                  return ChoiceChip(
                    label: Text(c.label),
                    avatar: Icon(c.icon,
                        size: 16,
                        color: selected ? Colors.white : c.color),
                    selected: selected,
                    onSelected: (_) => setState(() => category = c.id),
                    selectedColor: c.color,
                    backgroundColor: colorScheme.secondary,
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : colorScheme.onSurface,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      side: BorderSide.none,
                    ),
                  );
                }).toList(),
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
                    onSelected: (_) =>
                        setState(() => frequencyType = 'daily'),
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
                    onSelected: (_) =>
                        setState(() => frequencyType = 'weekly'),
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
                    activeColor: colorScheme.primary,
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
                      child: TextField(
                        controller: unitController,
                        decoration: InputDecoration(
                          hintText: 'Unité (ex: verres, pages, min)',
                          filled: true,
                          fillColor: colorScheme.secondary,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            borderSide: BorderSide.none,
                          ),
                        ),
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

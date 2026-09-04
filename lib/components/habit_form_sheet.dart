import 'package:R_HabitTracker/components/app_text_field.dart';
import 'package:R_HabitTracker/components/app_modal_sheet.dart';
import 'package:R_HabitTracker/components/choice_chip_group.dart';
import 'package:R_HabitTracker/components/new_category_sheet.dart';
import 'package:R_HabitTracker/components/primary_button.dart';
import 'package:R_HabitTracker/components/scaled_choice_chip.dart';
import 'package:R_HabitTracker/components/weekday_selector.dart';
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

    return AppModalSheet(
      title: isEditing ? 'Modifier l\'habitude' : 'Nouvelle habitude',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // name
          AppTextField(
            controller: nameController,
            hintText: 'Nom de l\'habitude',
            borderWidth: 2,
            borderColor: colorScheme.primary,
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
                    return ScaledChoiceChip(
                      label: c.label,
                      selected: selected,
                      onSelected: () => setState(() => category = c.id),
                      selectedColor: c.color,
                      avatar: c.icon,
                      avatarColor: c.color,
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
          ChoiceChipGroup(
            options: const ['Tous les jours', 'Jours précis'],
            selected:
                frequencyType == 'daily' ? 'Tous les jours' : 'Jours précis',
            onSelected: (value) => setState(() {
              frequencyType = value == 'Tous les jours' ? 'daily' : 'weekly';
            }),
          ),
          if (frequencyType == 'weekly') ...[
            const SizedBox(height: AppSpacing.sm),
            WeekdaySelector(
              selectedDays: selectedDays,
              onChanged: (days) => setState(() => selectedDays = days),
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
          PrimaryButton(
            onPressed: _submit,
            label: isEditing ? 'Enregistrer' : 'Créer',
          ),
        ],
      ),
    );
  }
}

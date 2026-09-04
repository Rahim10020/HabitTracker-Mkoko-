import 'package:R_HabitTracker/components/app_text_field.dart';
import 'package:R_HabitTracker/components/app_modal_sheet.dart';
import 'package:R_HabitTracker/components/primary_button.dart';
import 'package:R_HabitTracker/components/selector_grids.dart';
import 'package:R_HabitTracker/database/habit_database.dart';
import 'package:R_HabitTracker/theme/app_spacing.dart';
import 'package:R_HabitTracker/utils/custom_category_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Shows the "new category" form as a modal bottom sheet, saves it, and
/// returns the new category's key — or null if the user cancelled.
Future<String?> showNewCategorySheet(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const _NewCategorySheet(),
  );
}

class _NewCategorySheet extends StatefulWidget {
  const _NewCategorySheet();

  @override
  State<_NewCategorySheet> createState() => _NewCategorySheetState();
}

class _NewCategorySheetState extends State<_NewCategorySheet> {
  final TextEditingController labelController = TextEditingController();
  IconData selectedIcon = kCustomCategoryIcons.first;
  Color selectedColor = kCustomCategoryColors.first;
  bool saving = false;

  @override
  void dispose() {
    labelController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final label = labelController.text.trim();
    if (label.isEmpty || saving) return;

    setState(() => saving = true);
    final key = await context.read<HabitDatabase>().addCategory(
          label: label,
          icon: selectedIcon,
          color: selectedColor,
        );
    if (!mounted) return;
    Navigator.pop(context, key);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AppModalSheet(
      title: 'Nouvelle catégorie',
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
          // live preview
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: selectedColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(selectedIcon, color: selectedColor, size: 22),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppTextField(
                  controller: labelController,
                  hintText: 'Nom de la catégorie',
                  autofocus: true,
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // icon grid
          Text('Icône', style: textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          IconSelectorGrid(
            icons: kCustomCategoryIcons,
            selected: selectedIcon,
            onSelected: (icon) => setState(() => selectedIcon = icon),
            accentColor: selectedColor,
          ),
          const SizedBox(height: AppSpacing.lg),

          // color swatch
          Text('Couleur', style: textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          ColorSelectorGrid(
            colors: kCustomCategoryColors,
            selected: selectedColor,
            onSelected: (color) => setState(() => selectedColor = color),
          ),
          const SizedBox(height: AppSpacing.xl),

          // save button
          PrimaryButton(
            onPressed: _save,
            label: 'Créer la catégorie',
            isLoading: saving,
            enabled: labelController.text.trim().isNotEmpty,
          ),
        ],
      ),
    );
  }
}

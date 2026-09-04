import 'package:R_HabitTracker/components/app_text_field.dart';
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
              Text('Nouvelle catégorie', style: textTheme.headlineMedium),
              const SizedBox(height: AppSpacing.lg),

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
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: kCustomCategoryIcons.map((icon) {
                  final selected = icon == selectedIcon;
                  return GestureDetector(
                    onTap: () => setState(() => selectedIcon = icon),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: selected
                            ? selectedColor.withValues(alpha: 0.2)
                            : colorScheme.secondary,
                        border: selected
                            ? Border.all(color: selectedColor, width: 2)
                            : null,
                      ),
                      child: Icon(
                        icon,
                        size: 20,
                        color: selected
                            ? selectedColor
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.lg),

              // color swatch
              Text('Couleur', style: textTheme.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: kCustomCategoryColors.map((color) {
                  final selected = color == selectedColor;
                  return GestureDetector(
                    onTap: () => setState(() => selectedColor = color),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color,
                        border: selected
                            ? Border.all(color: colorScheme.onSurface, width: 2)
                            : null,
                      ),
                      child: selected
                          ? const Icon(Icons.check_rounded,
                              color: Colors.white, size: 16)
                          : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.xl),

              // save button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: labelController.text.trim().isEmpty ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    elevation: 0,
                  ),
                  child: saving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : const Text('Créer la catégorie'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

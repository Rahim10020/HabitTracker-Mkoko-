# Plan global — Maintenabilité & réutilisation des composants

## État actuel
- `app_text_field.dart` existe déjà et est utilisé dans `habit_form_sheet.dart` et `new_category_sheet.dart`.
- 4 bottom sheets partagent la même structure scaffold (drag-handle, titre, padding, SingleChildScrollView).
- 3 bottom sheets utilisent le même bouton CTA primaire.
- Des `ChoiceChip` animés sont dupliqués pour les catégories et la fréquence.
- `AppColors.lightError` est hardcodé au lieu d'utiliser `colorScheme.error`.
- Plusieurs sélecteurs (icônes, couleurs, jours) ont des patterns visuels similaires mais pas extraits.

## Tâches de refactoring

### 1. Extraire `AppModalSheet` (scaffold de bottom sheet)
**Fichiers impactés** : `habit_form_sheet.dart`, `new_category_sheet.dart`, `reminder_sheet.dart`, `confirm_delete_sheet.dart`
- Créer un widget `AppModalSheet` qui encapsule :
  - `Padding(bottom: MediaQuery.viewInsets.bottom)`
  - `Container` avec `colorScheme.surface`, `BorderRadius.vertical(top: AppRadius.xl)`
  - `EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.md, AppSpacing.xl, AppSpacing.xl)`
  - `SingleChildScrollView` + `Column`
  - Drag handle pill (40×4, `colorScheme.outline`, `AppRadius.full`)
  - Slot pour le titre (`headlineMedium`) + `SizedBox(height: AppSpacing.lg)`
- API : `AppModalSheet({required String title, required Widget child})`
- Les sheets appelantes gardent leur logique métier mais déléguent le layout.

### 2. Extraire `PrimaryButton`
**Fichiers impactés** : `habit_form_sheet.dart`, `new_category_sheet.dart`, `reminder_sheet.dart`
- Créer un widget `PrimaryButton` pour le CTA principal.
- Style par défaut : `SizedBox(width: double.infinity, height: 52)`, `ElevatedButton` avec `backgroundColor: colorScheme.primary`, `foregroundColor: Colors.white`, `elevation: 0`, `borderRadius: AppRadius.full`.
- API : `PrimaryButton({required VoidCallback onPressed, required String label, bool isLoading = false})`
- Support d'un état de chargement avec `CircularProgressIndicator` (réutilise le pattern de `new_category_sheet.dart`).

### 3. Extraire `ScaledChoiceChip`
**Fichier impacté** : `habit_form_sheet.dart`
- Créer un widget `ScaledChoiceChip` qui encapsule :
  - `TweenAnimationBuilder<double>` (tween 1→1.08, 180ms, easeOutBack)
  - `Transform.scale`
  - `ChoiceChip` avec le style standard (shape, backgroundColor, labelStyle)
- API : `ScaledChoiceChip({required String label, required bool selected, required VoidCallback onSelected, required Color selectedColor, IconData? avatar, Color? avatarColor})`
- Remplacer les 2×3 occurrences (catégories + fréquence) dans `habit_form_sheet.dart`.

### 4. Extraire `WeekdaySelector`
**Fichier impacté** : `habit_form_sheet.dart`
- Créer un widget `WeekdaySelector` pour le sélecteur de jours.
- API : `WeekdaySelector({required Set<int> selectedDays, required ValueChanged<Set<int>> onChanged})`
- Garder l'animation `AnimatedScale` et le style `CircleAvatar` existants.

### 5. Extraire `IconSelectorGrid` et `ColorSelectorGrid`
**Fichier impacté** : `new_category_sheet.dart`
- `IconSelectorGrid` : grille d'icônes avec `Container(40×40)`, sélection par bordure + fond teinté.
  - API : `IconSelectorGrid({required List<IconData> icons, required IconData selected, required ValueChanged<IconData> onSelected, required Color accentColor})`
- `ColorSelectorGrid` : grille de couleurs avec `Container(32×32)`, sélection par bordure + check icon.
  - API : `ColorSelectorGrid({required List<Color> colors, required Color selected, required ValueChanged<Color> onSelected})`

### 6. Rendre `error` theme-aware
**Fichiers impactés** : `confirm_delete_sheet.dart`, `my_habit_tile.dart`
- Remplacer `AppColors.lightError` par `colorScheme.error` dans :
  - `confirm_delete_sheet.dart` (bouton "Supprimer")
  - `my_habit_tile.dart` (action Slidable delete)
- Supprimer l'import de `app_colors.dart` dans `my_habit_tile.dart` si plus aucune autre référence.

### 7. Extraire `AnimatedProgressIndicator`
**Fichiers impactés** : `home_summary_header.dart`, `my_habit_tile.dart`
- Créer un widget `AnimatedProgressIndicator` qui encapsule :
  - `TweenAnimationBuilder<double>`
  - `ClipRRect` + `LinearProgressIndicator`
  - `minHeight: 8` par défaut, customisable
  - Support d'une `valueColor` personnalisée
- API : `AnimatedProgressIndicator({required double progress, Color? backgroundColor, Color? valueColor, double minHeight = 8})`

### 8. Extraire `AppAppBar`
**Fichier impacté** : `home_page.dart`
- Créer un widget `AppAppBar` pour le pattern transparent répété.
- API : `AppAppBar({String? title})` avec `backgroundColor: Colors.transparent`, `foregroundColor: colorScheme.onSurface`, `elevation: 0`.

### 9. Extraire `PrimaryFAB`
**Fichier impacté** : `home_page.dart`
- Créer un widget `PrimaryFAB` pour le FAB d'ajout.
- API : `PrimaryFAB({required VoidCallback onPressed})` avec `backgroundColor: colorScheme.primary`, `Icons.add_rounded`, `Colors.white`.

### 10. Extraire `ChoiceChipGroup`
**Fichier impacté** : `habit_form_sheet.dart`
- Le groupe de `ChoiceChip` "Tous les jours / Jours précis" suit le même pattern que les catégories mais sans l'animation scale.
- Créer un widget `ChoiceChipGroup` générique pour 2+ chips en ligne.
- API : `ChoiceChipGroup({required List<String> options, required String selected, required ValueChanged<String> onSelected})`

## Ordre d'exécution recommandé
1. `AppModalSheet` (plus gros gain, 4 fichiers touchés)
2. `PrimaryButton` (3 fichiers)
3. `ScaledChoiceChip` + `ChoiceChipGroup` (habit_form_sheet)
4. `WeekdaySelector` (habit_form_sheet)
5. `AnimatedProgressIndicator` (home_summary_header + my_habit_tile)
6. `IconSelectorGrid` + `ColorSelectorGrid` (new_category_sheet)
7. Rendre `error` theme-aware (confirm_delete_sheet + my_habit_tile)
8. `AppAppBar` + `PrimaryFAB` (home_page)

## Validation
- Lancer `flutter analyze` après chaque étape.
- Lancer `flutter test` à la fin.
- Vérifier visuellement que les bottom sheets, les chips, les sélecteurs et les barres de progression sont identiques à l'état initial.

## Risques
- Faible : extractions conservatives, aucun changement de comportement.
- Moyen : `AppModalSheet` change la structure des sheets existantes — bien vérifier les `EdgeInsets` et le comportement clavier.

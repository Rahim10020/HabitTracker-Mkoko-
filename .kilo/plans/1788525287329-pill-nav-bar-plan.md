# Plan: Créer le widget `PillNavBar` manquant

## Problème
`lib/pages/root_shell.dart` importe `package:R_HabitTracker/components/pill_nav_bar.dart` et utilise `PillNavBar` / `PillNavItem`, mais ce fichier n'existe pas dans le projet. L'erreur de compilation empêche l'appli de démarrer.

## Objectif
Créer `lib/components/pill_nav_bar.dart` avec un widget `PillNavBar` (pilule flottante à 3 icônes, indicateur actif en couleur d'accent) et un `PillNavItem`, en respectant l'API déjà utilisée dans `root_shell.dart`.

## Décisions de design

### API publique (déjà fixée par `root_shell.dart`)
- `PillNavItem` : classe const immutable avec un champ `final IconData icon`.
- `PillNavBar` : `StatelessWidget` recevant :
  - `required int selectedIndex`
  - `required ValueChanged<int> onChanged`
  - `required List<PillNavItem> items`
  - `double? height` (défaut 56)

### Style visuel
- Icônes seules (pas de labels texte).
- État actif : `colorScheme.primary`.
- État inactif : `colorScheme.onSurfaceVariant`.
- Pilule flottante : `colorScheme.surface` avec `borderRadius: AppRadius.full` et une ombre portée (`BoxShadow` avec `colorScheme.shadow` ou `Colors.black.withValues(alpha: 0.08)`).
- Tap target : chaque item prend toute la largeur via `Expanded`, hauteur égale à `height`.
- L'ensemble `PillNavBar + _AddHabitButton` est déjà aligné en Row dans `root_shell.dart` ; pas de modification de ce fichier.

### Structure du widget
```
PillNavBar (Container flottant arrondi + elevation)
└── Row
    └── [pour chaque item] Expanded
        └── _PillNavItem (InkWell + Icon)
```

## Tâches d'implémentation

1. **Créer `lib/components/pill_nav_bar.dart`**
   - Importer `package:flutter/material.dart` et `package:R_HabitTracker/theme/app_spacing.dart` (pour `AppRadius`).
   - Définir `PillNavItem` (const, `IconData icon`).
   - Définir `PillNavBar` (StatelessWidget).
   - Définir `_PillNavItem` (privé) avec `InkWell`, `BorderRadius.circular(AppRadius.full)`, icône active en `colorScheme.primary`, inactive en `colorScheme.onSurfaceVariant`.

2. **Vérifier `root_shell.dart`**
   - L'import existe déjà (ligne 2).
   - L'usage (lignes 87-95) correspond à l'API prévue.
   - Aucune modification nécessaire dans `root_shell.dart` une fois le widget créé.

3. **Validation**
   - Lancer `flutter analyze` sur `lib/components/pill_nav_bar.dart` et `lib/pages/root_shell.dart`.
   - Lancer `flutter analyze` sur tout le projet pour vérifier qu'aucune erreur n'est introduite.

## Risques / Points d'attention
- `AppRadius` vit dans `lib/theme/app_spacing.dart`.
- Le `colorScheme.shadow` est disponible en SDK ^3.5.2 ; sinon fallback sur `Colors.black.withValues(alpha: 0.08)`.
- Le design doit être cohérent avec le bouton rond `_AddHabitButton` existant (même hauteur, même alignement).

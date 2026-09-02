import 'package:flutter/material.dart';

class HabitCategory {
  final String id;
  final String label;
  final IconData icon;
  final Color color;

  const HabitCategory({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
  });
}

// Fixed set of categories for now — kept small and curated rather than
// user-defined, since a free-form category manager is its own feature.
const List<HabitCategory> kHabitCategories = [
  HabitCategory(
    id: 'health',
    label: 'Santé',
    icon: Icons.favorite_rounded,
    color: Color(0xFFEF4444),
  ),
  HabitCategory(
    id: 'mindfulness',
    label: 'Bien-être',
    icon: Icons.self_improvement_rounded,
    color: Color(0xFF8B5CF6),
  ),
  HabitCategory(
    id: 'fitness',
    label: 'Sport',
    icon: Icons.fitness_center_rounded,
    color: Color(0xFFFF7A59),
  ),
  HabitCategory(
    id: 'work',
    label: 'Travail',
    icon: Icons.work_rounded,
    color: Color(0xFF0F9B8E),
  ),
  HabitCategory(
    id: 'learning',
    label: 'Apprentissage',
    icon: Icons.menu_book_rounded,
    color: Color(0xFF3B82F6),
  ),
  HabitCategory(
    id: 'other',
    label: 'Autre',
    icon: Icons.star_rounded,
    color: Color(0xFF6B6963),
  ),
];

HabitCategory habitCategoryById(String id) => kHabitCategories.firstWhere(
      (c) => c.id == id,
      orElse: () => kHabitCategories.last,
    );

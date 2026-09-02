import 'package:flutter/material.dart';

/// Curated icon grid offered when creating a custom category. Kept to a
/// fixed, small set (rather than free icon search) so the picker stays
/// simple and every icon reads clearly at the small size used on tiles.
const List<IconData> kCustomCategoryIcons = [
  Icons.star_rounded,
  Icons.favorite_rounded,
  Icons.self_improvement_rounded,
  Icons.fitness_center_rounded,
  Icons.work_rounded,
  Icons.menu_book_rounded,
  Icons.restaurant_rounded,
  Icons.local_drink_rounded,
  Icons.bedtime_rounded,
  Icons.directions_run_rounded,
  Icons.spa_rounded,
  Icons.palette_rounded,
  Icons.music_note_rounded,
  Icons.brush_rounded,
  Icons.school_rounded,
  Icons.savings_rounded,
  Icons.pets_rounded,
  Icons.eco_rounded,
  Icons.code_rounded,
  Icons.camera_alt_rounded,
  Icons.groups_rounded,
  Icons.home_rounded,
  Icons.travel_explore_rounded,
  Icons.emoji_events_rounded,
];

/// Curated color swatch for custom categories — vibrant, distinct at a
/// glance, and consistent with the accent colors already used by the
/// built-in categories in `habit_category.dart`.
const List<Color> kCustomCategoryColors = [
  Color(0xFFEF4444), // red
  Color(0xFFFF7A59), // orange
  Color(0xFFF59E0B), // amber
  Color(0xFFEAB308), // yellow
  Color(0xFF22C55E), // green
  Color(0xFF0F9B8E), // teal
  Color(0xFF06B6D4), // cyan
  Color(0xFF3B82F6), // blue
  Color(0xFF6366F1), // indigo
  Color(0xFF8B5CF6), // violet
  Color(0xFFD946EF), // fuchsia
  Color(0xFF6B6963), // neutral
];

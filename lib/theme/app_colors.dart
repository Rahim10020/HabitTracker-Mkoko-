import 'package:flutter/material.dart';

/// Design tokens — color palette.
///
/// This is the source of truth for the app's colors. Component-level
/// styling (habit tiles, category chips, nav bar...) lands in the next
/// patch; this patch only wires these tokens into [ThemeData].
class AppColors {
  AppColors._();

  // ---- Light ----
  static const lightPrimary = Color(0xFFda627d);
  static const lightPrimaryContainer = Color(0xFFFFE8DE);
  static const lightSecondary = Color(0xFF0F9B8E);
  static const lightSuccess = Color(0xFF22C55E);
  static const lightBackground = Color(0xFFF3F3F3);
  static const lightSurface = Color(0xFFE8E8E8);
  static const lightTextPrimary = Color(0xFF1C1B1A);
  static const lightTextSecondary = Color(0xFF6B6963);
  static const lightBorder = Color(0xFFE7E5E0);
  static const lightError = Color(0xFFEF4444);

  // ---- Dark ----
  static const darkPrimary = Color(0xFFFF8A66);
  static const darkPrimaryContainer = Color(0xFF3A2A22);
  static const darkSecondary = Color(0xFF2DBDAF);
  static const darkSuccess = Color(0xFF34D399);
  static const darkBackground = Color(0xFF121212);
  static const darkSurface = Color(0xFF1E1D22);
  static const darkTextPrimary = Color(0xFFF5F3F0);
  static const darkTextSecondary = Color(0xFFA8A6A0);
  static const darkBorder = Color(0xFF2C2B30);
  static const darkError = Color(0xFFF87171);
}

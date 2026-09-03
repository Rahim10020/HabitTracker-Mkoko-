import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.darkBackground,
  colorScheme: const ColorScheme.dark(
    surface: AppColors.darkBackground,
    primary: AppColors.darkPrimary,
    primaryContainer: AppColors.darkPrimaryContainer,
    // secondary/tertiary are used as structural (card/edit-action)
    // backgrounds by widgets that haven't been restyled yet — that
    // rewiring happens in the next (components/nav) patch.
    secondary: AppColors.darkSurface,
    tertiary: AppColors.darkSecondary,
    error: AppColors.darkError,
    onSurface: AppColors.darkTextPrimary,
    onSurfaceVariant: AppColors.darkTextSecondary,
    outline: AppColors.darkBorder,
    inversePrimary: AppColors.darkTextPrimary,
  ),
  textTheme: GoogleFonts.snigletTextTheme(ThemeData.dark().textTheme).copyWith(
    displayLarge: GoogleFonts.sniglet(
      fontSize: 32,
      height: 40 / 32,
      fontWeight: FontWeight.w700,
      color: AppColors.darkTextPrimary,
    ),
    headlineMedium: GoogleFonts.sniglet(
      fontSize: 24,
      height: 32 / 24,
      fontWeight: FontWeight.w600,
      color: AppColors.darkTextPrimary,
    ),
    titleLarge: GoogleFonts.sniglet(
      fontSize: 18,
      height: 24 / 18,
      fontWeight: FontWeight.w600,
      color: AppColors.darkTextPrimary,
    ),
    bodyLarge: GoogleFonts.sniglet(
      fontSize: 16,
      height: 24 / 16,
      fontWeight: FontWeight.w400,
      color: AppColors.darkTextPrimary,
    ),
    bodyMedium: GoogleFonts.sniglet(
      fontSize: 14,
      height: 20 / 14,
      fontWeight: FontWeight.w400,
      color: AppColors.darkTextSecondary,
    ),
    labelSmall: GoogleFonts.sniglet(
      fontSize: 12,
      height: 16 / 12,
      fontWeight: FontWeight.w500,
      color: AppColors.darkTextSecondary,
    ),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    systemOverlayStyle: SystemUiOverlayStyle.light,
  ),
);

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.lightBackground,
  colorScheme: const ColorScheme.light(
    surface: AppColors.lightBackground,
    primary: AppColors.lightPrimary,
    primaryContainer: AppColors.lightPrimaryContainer,
    // secondary/tertiary are used as structural (card/edit-action)
    // backgrounds by widgets that haven't been restyled yet — that
    // rewiring happens in the next (components/nav) patch.
    secondary: AppColors.lightSurface,
    tertiary: AppColors.lightSecondary,
    error: AppColors.lightError,
    onSurface: AppColors.lightTextPrimary,
    onSurfaceVariant: AppColors.lightTextSecondary,
    outline: AppColors.lightBorder,
    inversePrimary: AppColors.lightTextPrimary,
  ),
  textTheme: GoogleFonts.manropeTextTheme().copyWith(
    displayLarge: GoogleFonts.manrope(
      fontSize: 32,
      height: 40 / 32,
      fontWeight: FontWeight.w700,
      color: AppColors.lightTextPrimary,
    ),
    headlineMedium: GoogleFonts.manrope(
      fontSize: 24,
      height: 32 / 24,
      fontWeight: FontWeight.w600,
      color: AppColors.lightTextPrimary,
    ),
    titleLarge: GoogleFonts.manrope(
      fontSize: 18,
      height: 24 / 18,
      fontWeight: FontWeight.w600,
      color: AppColors.lightTextPrimary,
    ),
    bodyLarge: GoogleFonts.manrope(
      fontSize: 16,
      height: 24 / 16,
      fontWeight: FontWeight.w400,
      color: AppColors.lightTextPrimary,
    ),
    bodyMedium: GoogleFonts.manrope(
      fontSize: 14,
      height: 20 / 14,
      fontWeight: FontWeight.w400,
      color: AppColors.lightTextSecondary,
    ),
    labelSmall: GoogleFonts.manrope(
      fontSize: 12,
      height: 16 / 12,
      fontWeight: FontWeight.w500,
      color: AppColors.lightTextSecondary,
    ),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  ),
);

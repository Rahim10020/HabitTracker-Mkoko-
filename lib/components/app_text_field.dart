import 'package:R_HabitTracker/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// Shared text input used across the app's modal sheets.
///
/// Encapsulates the common [InputDecoration] (filled surface with no
/// outline, rounded corners) so individual sheets no longer need to
/// duplicate the styling. It is a plain [TextField] wrapper — no
/// [Form]/[validator] logic — keeping validation manual at the call site.
class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final double borderWidth;
  final Color? borderColor;
  final bool autofocus;
  final bool enabled;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.borderWidth = 0,
    this.borderColor,
    this.autofocus = false,
    this.enabled = true,
    this.obscureText = false,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextField(
      controller: controller,
      autofocus: autofocus,
      enabled: enabled,
      obscureText: obscureText,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: colorScheme.secondary,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: borderColor ?? colorScheme.outline,
            width: borderWidth,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class AnimatedProgressIndicator extends StatelessWidget {
  final double progress;
  final Color? backgroundColor;
  final Color? valueColor;
  final double minHeight;
  final Duration duration;

  const AnimatedProgressIndicator({
    super.key,
    required this.progress,
    this.backgroundColor,
    this.valueColor,
    this.minHeight = 8,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: progress.clamp(0.0, 1.0)),
        duration: duration,
        curve: Curves.easeOutCubic,
        builder: (context, value, _) => LinearProgressIndicator(
          value: value,
          minHeight: minHeight,
          backgroundColor: backgroundColor ?? colorScheme.secondary,
          valueColor: AlwaysStoppedAnimation(valueColor ?? colorScheme.primary),
        ),
      ),
    );
  }
}

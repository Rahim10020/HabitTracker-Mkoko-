import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

sealed class CelebrationReason {
  const CelebrationReason();
}

class DayCompleted extends CelebrationReason {
  const DayCompleted();
}

class StreakMilestone extends CelebrationReason {
  final int days;

  const StreakMilestone(this.days);
}

class CelebrationOverlay extends StatefulWidget {
  const CelebrationOverlay({super.key});

  @override
  State<CelebrationOverlay> createState() => CelebrationOverlayState();
}

class CelebrationOverlayState extends State<CelebrationOverlay>
    with SingleTickerProviderStateMixin {
  late final ConfettiController _confetti = ConfettiController(
    duration: const Duration(milliseconds: 1500),
  );
  late final AnimationController _banner = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
    reverseDuration: const Duration(milliseconds: 350),
  );
  int? _streakDays;

  void show(CelebrationReason reason) {
    if (!mounted || MediaQuery.disableAnimationsOf(context)) return;
    HapticFeedback.mediumImpact();
    if (reason is StreakMilestone) {
      setState(() => _streakDays = reason.days);
      _banner.forward(from: 0);
    }
    _confetti.play();
    if (reason is StreakMilestone) {
      Future<void>.delayed(const Duration(seconds: 2), () {
        if (mounted) _banner.reverse();
      });
    }
  }

  @override
  void dispose() {
    _confetti.dispose();
    _banner.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return IgnorePointer(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confetti,
              blastDirection: math.pi / 2,
              emissionFrequency: 0.06,
              numberOfParticles: 12,
              gravity: 0.25,
              colors: [colors.primary, colors.tertiary, Colors.amber],
            ),
          ),
          if (_streakDays != null)
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -1),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _banner,
                    curve: Curves.easeOutCubic,
                  )),
                  child: Material(
                    color: colors.primary,
                    borderRadius: BorderRadius.circular(24),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Text(
                        'Série de $_streakDays jours !',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

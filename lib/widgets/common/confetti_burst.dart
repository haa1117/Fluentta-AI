import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';

/// Self-playing celebration confetti — drop it as a Stack child (top-center
/// aligned) on any "completion" screen. Plays once on mount, matching the
/// effect already used by LessonCompleteLayout so every completion screen
/// in the app celebrates the same way.
class ConfettiBurst extends StatefulWidget {
  const ConfettiBurst({super.key});

  @override
  State<ConfettiBurst> createState() => _ConfettiBurstState();
}

class _ConfettiBurstState extends State<ConfettiBurst> {
  late final ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: const Duration(seconds: 3));
    WidgetsBinding.instance.addPostFrameCallback((_) => _controller.play());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
        confettiController: _controller,
        blastDirectionality: BlastDirectionality.explosive,
        shouldLoop: false,
        maxBlastForce: 28,
        minBlastForce: 12,
        emissionFrequency: 0.04,
        numberOfParticles: 24,
        gravity: 0.12,
        colors: const [
          AppColors.primaryColor,
          AppColors.learnReadingOrange,
          AppColors.primaryBlueColor,
          AppColors.splashDotCyan,
          AppColors.splashDotPink,
        ],
      ),
    );
  }
}

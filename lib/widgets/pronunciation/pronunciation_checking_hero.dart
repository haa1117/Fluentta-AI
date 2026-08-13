import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';

/// Checking hero: centered bird inside faint rings + left-side waveform
/// matching the pronunciation checking design reference.
class PronunciationCheckingHero extends StatefulWidget {
  const PronunciationCheckingHero({super.key});

  @override
  State<PronunciationCheckingHero> createState() =>
      _PronunciationCheckingHeroState();
}

class _PronunciationCheckingHeroState extends State<PronunciationCheckingHero>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  static const Color _waveColor = Color(0xFFC9A8F5);
  static const Color _ringColor = Color(0xFFE4D4F7);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final outerSize = AppSizes.w(210);
    final innerSize = AppSizes.w(178);
    final birdSize = AppSizes.w(118);

    return SizedBox(
      width: outerSize,
      height: outerSize,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final floatOffset =
              math.sin(_controller.value * 2 * math.pi) * AppSizes.h(4);

          return Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              _StaticRing(size: outerSize, color: _ringColor, strokeWidth: 1.5),
              _StaticRing(size: innerSize, color: _ringColor, strokeWidth: 1.5),
              _SoftPulseRing(
                progress: _controller.value,
                size: outerSize,
                color: _ringColor,
              ),
              Transform.translate(
                offset: Offset(0, floatOffset),
                child: Image.asset(
                  AppAssets.pronunciationCheckingBird,
                  width: birdSize,
                  height: birdSize,
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                left: AppSizes.w(28),
                top: outerSize * 0.34,
                child: _CheckingSideWaveform(
                  controller: _controller,
                  barColor: _waveColor,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StaticRing extends StatelessWidget {
  const _StaticRing({
    required this.size,
    required this.color,
    required this.strokeWidth,
  });

  final double size;
  final Color color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: strokeWidth),
      ),
    );
  }
}

class _SoftPulseRing extends StatelessWidget {
  const _SoftPulseRing({
    required this.progress,
    required this.size,
    required this.color,
  });

  final double progress;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final scale = 0.96 + progress * 0.08;
    final opacity = (1 - progress) * 0.28;

    return Transform.scale(
      scale: scale,
      child: Opacity(
        opacity: opacity.clamp(0.0, 1.0),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: color.withValues(alpha: 0.7),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class _CheckingSideWaveform extends StatelessWidget {
  const _CheckingSideWaveform({
    required this.controller,
    required this.barColor,
  });

  final AnimationController controller;
  final Color barColor;

  /// 7 bars — diamond shape: short → tall → short (design reference).
  static const List<double> _baseHeights = [
    0.38,
    0.58,
    0.82,
    1.0,
    0.82,
    0.58,
    0.38,
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return SizedBox(
          height: AppSizes.h(34),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(_baseHeights.length, (index) {
              final phase =
                  controller.value * 2 * math.pi + index * 0.72;
              final wave = 0.62 + 0.38 * math.sin(phase);
              final height =
                  AppSizes.h(8 + 20 * _baseHeights[index] * wave);

              return Container(
                width: AppSizes.w(3.5),
                height: height,
                margin: EdgeInsets.only(
                  right: index < _baseHeights.length - 1
                      ? AppSizes.w(2.5)
                      : 0,
                ),
                decoration: BoxDecoration(
                  color: barColor,
                  borderRadius: BorderRadius.circular(AppSizes.w(2)),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

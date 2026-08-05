import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';

class SplashDots extends StatefulWidget {
  const SplashDots({super.key});

  @override
  State<SplashDots> createState() => _SplashDotsState();
}

class _SplashDotsState extends State<SplashDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const List<Color> _dotColors = [
    AppColors.splashDotCyan,
    AppColors.splashDotPurple,
    AppColors.splashDotPink,
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _scaleForDot(int index) {
    final staggerOffset = index * 0.2;
    final progress = (_controller.value + staggerOffset) % 1.0;
    final wave = math.sin(progress * math.pi);
    return 0.5 + (wave * 0.5);
  }

  double _opacityForDot(int index) {
    final staggerOffset = index * 0.2;
    final progress = (_controller.value + staggerOffset) % 1.0;
    final wave = math.sin(progress * math.pi);
    return 0.4 + (wave * 0.6);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < _dotColors.length; i++) ...[
              if (i > 0) SizedBox(width: AppSizes.w(8)),
              _AnimatedDot(
                color: _dotColors[i],
                scale: _scaleForDot(i),
                opacity: _opacityForDot(i),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _AnimatedDot extends StatelessWidget {
  const _AnimatedDot({
    required this.color,
    required this.scale,
    required this.opacity,
  });

  final Color color;
  final double scale;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    final size = AppSizes.w(10);

    return Opacity(
      opacity: opacity,
      child: Transform.scale(
        scale: scale,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.4),
                blurRadius: size * scale,
                spreadRadius: size * 0.1 * scale,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';

class AudioWaveform extends StatefulWidget {
  final bool isDark;
  const AudioWaveform({super.key, this.isAnimating = true, required this.isDark});

  final bool isAnimating;

  @override
  State<AudioWaveform> createState() => _AudioWaveformState();
}

class _AudioWaveformState extends State<AudioWaveform>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    if (widget.isAnimating) _controller.repeat();
  }

  @override
  void didUpdateWidget(covariant AudioWaveform oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isAnimating && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(9, (index) {
            final phase = _controller.value * 2 * math.pi + index * 0.6;
            final height = widget.isAnimating
                ? AppSizes.h(12 + 20 * (0.5 + 0.5 * math.sin(phase)))
                : AppSizes.h(8);
            return Container(
              width: AppSizes.w(4),
              height: height,
              margin: EdgeInsets.symmetric(horizontal: AppSizes.w(3)),
              decoration: BoxDecoration(
                color:widget.isDark ? AppColors.primaryDarkColor : AppColors.primaryColor,
                borderRadius: BorderRadius.circular(AppSizes.w(4)),
              ),
            );
          }),
        );
      },
    );
  }
}

class PhraseProgressSegments extends StatelessWidget {
  final bool isDark;
  const PhraseProgressSegments({
    super.key,
    required this.current,
    required this.total, required this.isDark,
  });

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (index) {
        final isActive = index < current;
        return Expanded(
          child: Container(
            height: AppSizes.h(6),
            margin: EdgeInsets.only(left: index == 0 ? 0 : AppSizes.w(4)),
            decoration: BoxDecoration(
              color: isActive
                  ? isDark ? AppColors.primaryDarkColor : AppColors.primarySecondaryColor
                  : isDark ? Color(0xff81768D) :Color(0xffD3E4FE),
              borderRadius: BorderRadius.circular(AppSizes.w(4)),
            ),
          ),
        );
      }),
    );
  }
}

class PronunciationScoreRing extends StatelessWidget {
  final bool isDark;
  const PronunciationScoreRing({super.key, required this.score, required this.isDark});

  final int score;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSizes.w(120),
      height: AppSizes.w(120),
      child: CustomPaint(
        painter: _ScoreRingPainter(score: score / 100, isDark: isDark),
        child: Center(
          child: Text(
            '$score%',
            style: TextStyle(
              fontFamily: AppFonts.plusJakartaSans,
              fontSize: AppSizes.sp(28),
              fontWeight: FontWeight.w700,
              color:isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _ScoreRingPainter extends CustomPainter {
  final bool isDark;
  _ScoreRingPainter({required this.score, required this.isDark});

  final double score;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    const stroke = 8.0;

    final track = Paint()
      ..color =isDark ? AppColors.brandDarkSoftColor : AppColors.progressTrack
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    final progress = Paint()
      ..color =isDark ? AppColors.primaryDarkColor : AppColors.primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, track);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * score,
      false,
      progress,
    );
  }

  @override
  bool shouldRepaint(covariant _ScoreRingPainter oldDelegate) =>
      oldDelegate.score != score;
}

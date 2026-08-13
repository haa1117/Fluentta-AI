import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';

class AudioWaveform extends StatefulWidget {
  const AudioWaveform({super.key, this.isAnimating = true});

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
                color: AppColors.primaryColor,
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
  const PhraseProgressSegments({
    super.key,
    required this.current,
    required this.total,
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
                  ? AppColors.primarySecondaryColor
                  : Color(0xffD3E4FE),
              borderRadius: BorderRadius.circular(AppSizes.w(4)),
            ),
          ),
        );
      }),
    );
  }
}

class PronunciationScoreRing extends StatelessWidget {
  const PronunciationScoreRing({super.key, required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSizes.w(120),
      height: AppSizes.w(120),
      child: CustomPaint(
        painter: _ScoreRingPainter(score: score / 100),
        child: Center(
          child: Text(
            '$score%',
            style: TextStyle(
              fontFamily: AppFonts.plusJakartaSans,
              fontSize: AppSizes.sp(28),
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _ScoreRingPainter extends CustomPainter {
  _ScoreRingPainter({required this.score});

  final double score;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    const stroke = 8.0;

    final track = Paint()
      ..color = AppColors.progressTrack
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    final progress = Paint()
      ..color = AppColors.primaryColor
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

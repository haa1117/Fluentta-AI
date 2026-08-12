import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/viewmodels/home_view_model.dart';
import 'package:fluentta_ai/viewmodels/learn_view_model.dart';
import 'package:provider/provider.dart';

class LearnLevelCard extends StatelessWidget {
  const LearnLevelCard({super.key});

  @override
  Widget build(BuildContext context) {
    context.watch<HomeViewModel>();
    final viewModel = context.watch<LearnViewModel>();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.w(14)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border.all(
          color: AppColors.borderLight
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: AppSizes.w(100),
            height: AppSizes.h(100),
            child: Image.asset(
              AppAssets.yourLevelBird,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(width: AppSizes.w(8)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'YOUR LEVEL',
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(14),
                    fontWeight: FontWeight.w700,
                    color: Color(0xff630ED4),
                    letterSpacing: 0.6,
                  ),
                ),
                SizedBox(height: AppSizes.h(10)),
                Text(
                  viewModel.levelCode,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(28),
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1,
                  ),
                ),
                Text(
                  viewModel.levelName,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(14),
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: AppSizes.w(64),
            height: AppSizes.w(64),
            child: CustomPaint(
              painter: _LearnProgressPainter(
                progress: viewModel.levelProgress,
              ),
              child: Center(
                child: Text(
                  '${viewModel.levelProgressPercent}%',
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(13),
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
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

class _LearnProgressPainter extends CustomPainter {
  _LearnProgressPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 3;
    const strokeWidth = 5.0;

    final trackPaint = Paint()
      ..color = AppColors.progressTrack
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = AppColors.primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _LearnProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

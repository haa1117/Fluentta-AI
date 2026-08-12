import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/views/pronunciation/pronunciation_flow.dart';
import 'package:fluentta_ai/widgets/common/appbar_widget.dart';

class PronunciationCheckingScreen extends StatefulWidget {
  const PronunciationCheckingScreen({super.key});

  @override
  State<PronunciationCheckingScreen> createState() =>
      _PronunciationCheckingScreenState();
}

class _PronunciationCheckingScreenState
    extends State<PronunciationCheckingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..forward();

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        Navigator.of(context).pushReplacementNamed(
          PronunciationFlow.routeResult,
        );
      }
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: AppBarWidget(
        title: l10n.pronunciation,
        showBackButton: true,
        centerTitle: true,
        onBack: () => PronunciationFlow.popOrExitFlow(context),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
        child: Column(
          children: [
            SizedBox(height: AppSizes.h(24)),
            Container(
              width: AppSizes.w(160),
              height: AppSizes.w(160),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.homeCardLavenderDark,
                  width: 2,
                ),
              ),
              child: Center(
                child: Image.asset(
                  AppAssets.authBird,
                  width: AppSizes.w(100),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: AppSizes.h(24)),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppSizes.w(20)),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                border: Border.all(color: AppColors.borderLight),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withValues(alpha: 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    l10n.checkingPronunciation,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppFonts.plusJakartaSans,
                      fontSize: AppSizes.sp(18),
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: AppSizes.h(10)),
                  Text(
                    l10n.checkingPronunciationSub,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppFonts.plusJakartaSans,
                      fontSize: AppSizes.sp(14),
                      color: AppColors.textSecondary,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSizes.h(24)),
            AnimatedBuilder(
              animation: _progressController,
              builder: (context, _) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.w(8)),
                  child: LinearProgressIndicator(
                    value: _progressController.value,
                    minHeight: AppSizes.h(8),
                    backgroundColor: AppColors.progressTrack,
                    color: AppColors.primaryColor,
                  ),
                );
              },
            ),
            SizedBox(height: AppSizes.h(12)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.refresh_rounded,
                  size: AppSizes.sp(16),
                  color: AppColors.primaryColor,
                ),
                SizedBox(width: AppSizes.w(6)),
                Text(
                  l10n.onlyTakesMoment,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(13),
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

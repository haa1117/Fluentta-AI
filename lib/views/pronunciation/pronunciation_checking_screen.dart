import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/views/pronunciation/pronunciation_flow.dart';
import 'package:fluentta_ai/widgets/common/appbar_widget.dart';
import 'package:fluentta_ai/widgets/pronunciation/pronunciation_checking_hero.dart';

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
      duration: const Duration(milliseconds: 1200),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
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
            SizedBox(height: AppSizes.h(44)),
            const Center(child: PronunciationCheckingHero()),
            SizedBox(height: AppSizes.h(44)),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppSizes.w(23)),
              decoration: BoxDecoration(
                color:isDark ? AppColors.surfaceBgDarkColor : AppColors.white,
                borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                border: Border.all(color:isDark ? AppColors.borderDarkColor : AppColors.borderLight),
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
                      fontSize: AppSizes.sp(24),
                      fontWeight: FontWeight.w700,
                      color:isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: AppSizes.h(10)),
                  Text(
                    l10n.checkingPronunciationSub,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppFonts.plusJakartaSans,
                      fontSize: AppSizes.sp(15),
                      color:isDark ? AppColors.textSecondaryDark : AppColors.profileSubtitleColor,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSizes.h(50)),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
              child: AnimatedBuilder(
                animation: _progressController,
                builder: (context, _) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(AppSizes.w(8)),
                    child: LinearProgressIndicator(
                      value: _progressController.value,
                      minHeight: AppSizes.h(8),
                      backgroundColor:isDark ? AppColors.brandDarkSoftColor : Color(0xffF3E8FF),
                      color:isDark ? AppColors.primaryDarkColor : AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: AppSizes.h(15)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.refresh_rounded,
                  size: AppSizes.sp(16),
                  color:isDark ? AppColors.primaryDarkColor : AppColors.primaryColor,
                ),
                SizedBox(width: AppSizes.w(6)),
                Text(
                  l10n.onlyTakesMoment,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(14),
                    fontWeight: FontWeight.w600,
                    color:isDark ? AppColors.primaryDarkColor : AppColors.primaryColor,
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

import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/viewmodels/pronunciation_view_model.dart';
import 'package:fluentta_ai/views/pronunciation/pronunciation_flow.dart';
import 'package:fluentta_ai/widgets/common/appbar_widget.dart';
import 'package:fluentta_ai/widgets/common/primary_button.dart';
import 'package:provider/provider.dart';

/// Practice-complete summary shown after all pronunciation phrases are done.
class PronunciationCompleteScreen extends StatelessWidget {
  const PronunciationCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final vm = context.watch<PronunciationViewModel>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: AppBarWidget(
        title: l10n.pronunciation,
        showBackButton: true,
        centerTitle: true,
        showActionButton: false,
        onBack: () => PronunciationFlow.popOrExitFlow(context),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPadding,
                ),
                child: Column(
                  children: [
                    SizedBox(height: AppSizes.h(12)),
                    Image.asset(
                      AppAssets.pronunciationPracticeBird,
                      height: AppSizes.h(180),
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: AppSizes.h(20)),
                    Text(
                      l10n.practiceComplete,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppFonts.plusJakartaSans,
                        fontSize: AppSizes.sp(28),
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    SizedBox(height: AppSizes.h(8)),
                    Text(
                      l10n.practicedPhrases(vm.totalPhrases),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppFonts.plusJakartaSans,
                        fontSize: AppSizes.sp(14),
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: AppSizes.h(24)),
                    _AverageScoreCard(score: vm.averageScore, label: l10n.averageScore),
                    SizedBox(height: AppSizes.h(12)),
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            label: l10n.phrasesLabel,
                            value: '${vm.totalPhrases}',
                            valueColor: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(width: AppSizes.w(12)),
                        Expanded(
                          child: _StatCard(
                            label: l10n.bestWord,
                            value: vm.bestWord,
                            valueColor: AppColors.primaryColor,
                            trailing: Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.primaryColor,
                              size: AppSizes.sp(18),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.h(24)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSizes.horizontalPadding,
                0,
                AppSizes.horizontalPadding,
                AppSizes.h(24),
              ),
              child: Column(
                children: [
                  PrimaryButton(
                    text: l10n.practiceMore,
                    onPressed: () {
                      vm.resetSession();
                      Navigator.of(context).pushReplacementNamed(
                        PronunciationFlow.routeHome,
                      );
                    },
                  ),
                  SizedBox(height: AppSizes.h(12)),
                  SizedBox(
                    width: double.infinity,
                    height: AppSizes.buttonHeight,
                    child: OutlinedButton(
                      onPressed: () => PronunciationFlow.popFlow(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryColor,
                        side: const BorderSide(color: AppColors.primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppSizes.buttonRadius),
                        ),
                      ),
                      child: Text(
                        l10n.backToSpeak,
                        style: TextStyle(
                          fontFamily: AppFonts.plusJakartaSans,
                          fontSize: AppSizes.sp(16),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AverageScoreCard extends StatelessWidget {
  const _AverageScoreCard({
    required this.score,
    required this.label,
  });

  final int score;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.w(20),
        vertical: AppSizes.h(18),
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withValues(alpha: 0.08),
            blurRadius: AppSizes.w(16),
            offset: Offset(0, AppSizes.h(6)),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(11),
                    fontWeight: FontWeight.w600,
                    color: AppColors.textTertiary,
                    letterSpacing: 0.8,
                  ),
                ),
                SizedBox(height: AppSizes.h(4)),
                Text(
                  '$score%',
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(36),
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryColor,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
          _MedalBadge(size: AppSizes.w(52)),
        ],
      ),
    );
  }
}

class _MedalBadge extends StatelessWidget {
  const _MedalBadge({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryGradientStart,
            AppColors.primaryGradientEnd,
          ],
        ),
        borderRadius: BorderRadius.circular(AppSizes.w(14)),
      ),
      child: Icon(
        Icons.star_rounded,
        color: AppColors.white,
        size: size * 0.52,
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.valueColor,
    this.trailing,
  });

  final String label;
  final String value;
  final Color valueColor;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.w(16),
        vertical: AppSizes.h(14),
      ),
      decoration: BoxDecoration(
        color: AppColors.homeCardLavender,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: AppFonts.plusJakartaSans,
              fontSize: AppSizes.sp(12),
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppSizes.h(4)),
          Row(
            children: [
              Flexible(
                child: Text(
                  value,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(20),
                    fontWeight: FontWeight.w700,
                    color: valueColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (trailing != null) ...[
                SizedBox(width: AppSizes.w(4)),
                trailing!,
              ],
            ],
          ),
        ],
      ),
    );
  }
}

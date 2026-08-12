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
        onBack: () => PronunciationFlow.popOrExitFlow(context),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
        child: Column(
          children: [
            SizedBox(height: AppSizes.h(16)),
            Image.asset(
              AppAssets.lessonCompletedBird,
              height: AppSizes.h(140),
              fit: BoxFit.contain,
            ),
            SizedBox(height: AppSizes.h(16)),
            Text(
              l10n.practiceComplete,
              style: TextStyle(
                fontFamily: AppFonts.plusJakartaSans,
                fontSize: AppSizes.sp(26),
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
                color: AppColors.textSecondary,
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
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.averageScore,
                        style: TextStyle(
                          fontFamily: AppFonts.plusJakartaSans,
                          fontSize: AppSizes.sp(11),
                          fontWeight: FontWeight.w600,
                          color: AppColors.textTertiary,
                          letterSpacing: 0.6,
                        ),
                      ),
                      Text(
                        '${vm.averageScore}%',
                        style: TextStyle(
                          fontFamily: AppFonts.plusJakartaSans,
                          fontSize: AppSizes.sp(32),
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Icon(
                    Icons.emoji_events_rounded,
                    color: AppColors.primaryColor,
                    size: AppSizes.sp(40),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSizes.h(12)),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(AppSizes.w(14)),
                    decoration: BoxDecoration(
                      color: AppColors.homeCardLavender,
                      borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.phrasesLabel,
                          style: TextStyle(
                            fontFamily: AppFonts.plusJakartaSans,
                            fontSize: AppSizes.sp(12),
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          '${vm.totalPhrases}',
                          style: TextStyle(
                            fontFamily: AppFonts.plusJakartaSans,
                            fontSize: AppSizes.sp(20),
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: AppSizes.w(10)),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(AppSizes.w(14)),
                    decoration: BoxDecoration(
                      color: AppColors.homeCardLavender,
                      borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.bestWord,
                          style: TextStyle(
                            fontFamily: AppFonts.plusJakartaSans,
                            fontSize: AppSizes.sp(12),
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                vm.bestWord,
                                style: TextStyle(
                                  fontFamily: AppFonts.plusJakartaSans,
                                  fontSize: AppSizes.sp(18),
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.primaryColor,
                              size: AppSizes.sp(18),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
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
                    borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
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
            SizedBox(height: AppSizes.h(24)),
          ],
        ),
      ),
    );
  }
}

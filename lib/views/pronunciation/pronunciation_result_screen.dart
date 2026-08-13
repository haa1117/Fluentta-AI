import 'package:fluentta_ai/widgets/common/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/viewmodels/pronunciation_view_model.dart';
import 'package:fluentta_ai/views/pronunciation/pronunciation_flow.dart';
import 'package:fluentta_ai/widgets/common/appbar_widget.dart';
import 'package:fluentta_ai/widgets/pronunciation/pronunciation_widgets.dart';
import 'package:fluentta_ai/widgets/pronunciation/word_feedback_tile.dart';
import 'package:provider/provider.dart';

class PronunciationResultScreen extends StatefulWidget {
  const PronunciationResultScreen({super.key});

  @override
  State<PronunciationResultScreen> createState() =>
      _PronunciationResultScreenState();
}

class _PronunciationResultScreenState extends State<PronunciationResultScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PronunciationViewModel>().completeCurrentPhrase();
    });
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final vm = context.watch<PronunciationViewModel>();
    final phrase = vm.currentPhrase;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: AppBarWidget(
        title: l10n.pronunciation,
        showBackButton: true,
        centerTitle: true,
        onBack: () => PronunciationFlow.popOrExitFlow(context),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                AppSizes.horizontalPadding,
                AppSizes.spaceMd,
                AppSizes.horizontalPadding,
                AppSizes.spaceMd,
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(AppSizes.w(20)),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                      // border: Border.all(color: AppColors.borderLight),
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
                          l10n.greatEffort,
                          style: TextStyle(
                            fontFamily: AppFonts.plusJakartaSans,
                            fontSize: AppSizes.sp(22),
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: AppSizes.h(16)),
                        PronunciationScoreRing(score: phrase.overallScore),
                        SizedBox(height: AppSizes.h(16)),
                        Text(
                          l10n.pronunciationScoreMessage(phrase.overallScore),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: AppFonts.plusJakartaSans,
                            fontSize: AppSizes.sp(14),
                            color: AppColors.profileSubtitleColor,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSizes.h(20)),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      l10n.wordFeedback,
                      style: TextStyle(
                        fontFamily: AppFonts.plusJakartaSans,
                        fontSize: AppSizes.sp(12),
                        fontWeight: FontWeight.w600,
                        color: AppColors.profileSubtitleColor,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  SizedBox(height: AppSizes.h(10)),
                  ...phrase.words.map(
                    (w) => WordFeedbackTile(feedback: w),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSizes.horizontalPadding,
              0,
              AppSizes.horizontalPadding,
              AppSizes.spaceLg,
            ),
            child: Column(
              children: [

                PrimaryButton(text: l10n.tryAgain , onPressed: (){
                  Navigator.of(context).pushReplacementNamed(
                    PronunciationFlow.routeRecording,
                  );
                }),
                // SizedBox(
                //   width: double.infinity,
                //   height: AppSizes.buttonHeight,
                //   child: ElevatedButton(
                //     onPressed: () {
                //       Navigator.of(context).pushReplacementNamed(
                //         PronunciationFlow.routeRecording,
                //       );
                //     },
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: AppColors.primaryColor,
                //       foregroundColor: AppColors.white,
                //       elevation: 0,
                //       shape: RoundedRectangleBorder(
                //         borderRadius:
                //             BorderRadius.circular(AppSizes.buttonRadius),
                //       ),
                //     ),
                //     child: Text(
                //       l10n.tryAgain,
                //       style: TextStyle(
                //         fontFamily: AppFonts.plusJakartaSans,
                //         fontSize: AppSizes.sp(16),
                //         fontWeight: FontWeight.w700,
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(height: AppSizes.h(10)),
                SizedBox(
                  width: double.infinity,
                  height: AppSizes.buttonHeight,
                  child: OutlinedButton(
                    onPressed: () {
                      if (vm.isLastPhrase) {
                        Navigator.of(context).pushReplacementNamed(
                          PronunciationFlow.routeComplete,
                        );
                      } else {
                        vm.nextPhrase();
                        Navigator.of(context).popUntil(
                          (route) =>
                              route.settings.name == PronunciationFlow.routeHome,
                        );
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryColor,
                      side: const BorderSide(color: AppColors.primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSizes.buttonRadius),
                      ),
                    ),
                    child: Text(
                      vm.isLastPhrase ? l10n.finish : l10n.nextPhrase,
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
    );
  }
}

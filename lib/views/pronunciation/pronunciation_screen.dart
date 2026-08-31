import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/views/pronunciation/pronunciation_check_helper.dart';
import 'package:fluentta_ai/viewmodels/pronunciation_view_model.dart';
import 'package:fluentta_ai/views/pronunciation/pronunciation_flow.dart';
import 'package:fluentta_ai/widgets/common/appbar_widget.dart';
import 'package:fluentta_ai/widgets/pronunciation/pronunciation_widgets.dart';
import 'package:provider/provider.dart';

class PronunciationScreen extends StatelessWidget {
  const PronunciationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final vm = context.watch<PronunciationViewModel>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      appBar: AppBarWidget(
        title: l10n.pronunciation,
        showBackButton: true,
        centerTitle: true,
        showHearts: true,
        onBack: () => PronunciationFlow.popOrExitFlow(context),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [ 
            Expanded(
              child: SingleChildScrollView(
                // padding: EdgeInsets.fromLTRB(
                //   AppSizes.horizontalPadding,
                //   AppSizes.spaceMd,
                //   AppSizes.horizontalPadding,
                //   AppSizes.spaceLg,
                // ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: AppSizes.spaceLg,
                    ),
                    SizedBox(
                      width: AppSizes.screenWidth,
                      child: Image.asset(
                        'assets/images/pronuncition_practice_banner.png',
                        width: double.infinity,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    // Container(
                    //   width: double.infinity,
                    //   padding: EdgeInsets.all(AppSizes.w(16)),
                    //   decoration: BoxDecoration(
                    //     gradient: AppColors.primaryGradient,
                    //     borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                    //   ),
                    //   child: Row(
                    //     children: [
                    //       Expanded(
                    //         child: Column(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             Text(
                    //               l10n.pronunciationPractice,
                    //               style: TextStyle(
                    //                 fontFamily: AppFonts.plusJakartaSans,
                    //                 fontSize: AppSizes.sp(18),
                    //                 fontWeight: FontWeight.w700,
                    //                 color: AppColors.white,
                    //               ),
                    //             ),
                    //             SizedBox(height: AppSizes.h(6)),
                    //             Text(
                    //               l10n.pronunciationPracticeDesc,
                    //               style: TextStyle(
                    //                 fontFamily: AppFonts.plusJakartaSans,
                    //                 fontSize: AppSizes.sp(13),
                    //                 color: AppColors.white.withValues(alpha: 0.9),
                    //                 height: 1.4,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //       Image.asset(
                    //         AppAssets.authBird,
                    //         width: AppSizes.w(72),
                    //         height: AppSizes.w(72),
                    //         fit: BoxFit.contain,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(height: AppSizes.h(20)),
                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal:   AppSizes.horizontalPadding),
                      child: Row(
                        children: [
                          Text(
                            l10n.phraseOf(
                              vm.currentPhraseIndex + 1,
                              vm.totalPhrases,
                            ),
                            style: TextStyle(
                              fontFamily: AppFonts.plusJakartaSans,
                              fontSize: AppSizes.sp(14),
                              fontWeight: FontWeight.w600,
                              color: AppColors.profileSubtitleColor,
                            ),
                          ),
                          SizedBox(width: AppSizes.w(60)),
                          Expanded(
                            child: PhraseProgressSegments(
                              current: vm.currentPhraseIndex + 1,
                              total: vm.totalPhrases,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSizes.h(16)),
                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal:   AppSizes.horizontalPadding),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSizes.w(20),
                          vertical: AppSizes.h(32),
                        ),
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
                              '"${vm.currentPhraseText}"',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: AppFonts.plusJakartaSans,
                                fontSize: AppSizes.sp(23),
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                                height: 1.35,
                              ),
                            ),
                            SizedBox(height: AppSizes.h(16)),
                            OutlinedButton.icon(
                              onPressed: vm.isListeningPhrase
                                  ? null
                                  : () async {
                                      final didSpeak = await vm.listenToCurrentPhrase();
                                      if (!context.mounted) return;
                                      if (!didSpeak) {
                                        SnackbarHelper.showError(
                                          context,
                                          l10n.listenUnavailable,
                                        );
                                      }
                                    },
                              icon: Icon(Icons.volume_up_rounded, size: AppSizes.sp(18)),
                              label: Text(l10n.listen,style: TextStyle(
                               fontFamily: AppFonts.plusJakartaSans,
                               fontSize: AppSizes.sp(14),
                               fontWeight: FontWeight.w600
                              )),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primaryColor,
                                backgroundColor: Color(0xfff8f4ff),
                                side: BorderSide(color: AppColors.borderLight,
                                width: 1.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppSizes.w(20)),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppSizes.w(16),
                                  vertical: AppSizes.h(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: AppSizes.h(14)),
              
                  ],
                ),
              ),
            ),
        
            Padding(
              padding:  EdgeInsets.symmetric(horizontal:   AppSizes.horizontalPadding),
              child: SizedBox(
                width: double.infinity,
                height: AppSizes.buttonHeight,
                child: ElevatedButton.icon(
                  onPressed: () => startPronunciationCheck(context),
                  icon: Icon(Icons.mic_none_rounded, size: AppSizes.sp(22)),
                  label: Text(
                    l10n.startRecording,
                    style: TextStyle(
                      fontFamily: AppFonts.plusJakartaSans,
                      fontSize: AppSizes.sp(16),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: AppSizes.h(18)),
            Center(
              child: Text(
                '❤️ ${l10n.heartPerPronunciation}',
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(12),
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            SizedBox(height: AppSizes.h(12)),
        
          ],
        ),
      ),
    );
  }
}

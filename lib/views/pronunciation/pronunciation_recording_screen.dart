import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/viewmodels/pronunciation_view_model.dart';
import 'package:fluentta_ai/views/pronunciation/pronunciation_flow.dart';
import 'package:fluentta_ai/widgets/common/appbar_widget.dart';
import 'package:fluentta_ai/widgets/pronunciation/pronunciation_widgets.dart';
import 'package:provider/provider.dart';

class PronunciationRecordingScreen extends StatelessWidget {
  const PronunciationRecordingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final phrase = context.watch<PronunciationViewModel>().currentPhrase.phrase;

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
            SizedBox(height: AppSizes.h(32)),
            Container(
              width: AppSizes.w(80),
              height: AppSizes.w(80),
              decoration: BoxDecoration(
                color: AppColors.homeCardLavender,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.record_voice_over_rounded,
                color: AppColors.primaryColor,
                size: AppSizes.sp(36),
              ),
            ),
            SizedBox(height: AppSizes.h(20)),
            Text(
              l10n.speakClearly,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppFonts.plusJakartaSans,
                fontSize: AppSizes.sp(22),
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSizes.h(24)),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.w(20),
                vertical: AppSizes.h(28),
              ),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Text(
                '"$phrase"',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(20),
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            SizedBox(height: AppSizes.h(32)),
            const AudioWaveform(),
            SizedBox(height: AppSizes.h(16)),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.w(14),
                vertical: AppSizes.h(6),
              ),
              decoration: BoxDecoration(
                color: AppColors.heartRed.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSizes.w(20)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: AppSizes.w(8),
                    height: AppSizes.w(8),
                    decoration: const BoxDecoration(
                      color: AppColors.heartRed,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: AppSizes.w(8)),
                  Text(
                    l10n.recording,
                    style: TextStyle(
                      fontFamily: AppFonts.plusJakartaSans,
                      fontSize: AppSizes.sp(12),
                      fontWeight: FontWeight.w700,
                      color: AppColors.heartRed,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: AppSizes.buttonHeight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(
                    PronunciationFlow.routeChecking,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
                  ),
                ),
                child: Text(
                  l10n.stopRecording,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(16),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SizedBox(height: AppSizes.h(12)),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                l10n.cancelBtn,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(15),
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
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

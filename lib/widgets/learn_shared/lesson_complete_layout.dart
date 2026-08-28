import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/widgets/common/primary_button.dart';

class LessonCompleteLayout extends StatefulWidget {
  const LessonCompleteLayout({
    super.key,
    required this.xpEarned,
    required this.subtitle,
    required this.buttonText,
    required this.onClose,
    required this.onButtonPressed,
    this.summaryCard,
    this.chips,
  });

  final int xpEarned;
  final String subtitle;
  final String buttonText;
  final VoidCallback onClose;
  final VoidCallback onButtonPressed;
  final Widget? summaryCard;
  final List<Widget>? chips;

  @override
  State<LessonCompleteLayout> createState() => _LessonCompleteLayoutState();
}

class _LessonCompleteLayoutState extends State<LessonCompleteLayout> {
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _confettiController.play();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                maxBlastForce: 28,
                minBlastForce: 12,
                emissionFrequency: 0.04,
                numberOfParticles: 24,
                gravity: 0.12,
                colors: const [
                  AppColors.primaryColor,
                  AppColors.learnReadingOrange,
                  AppColors.primaryBlueColor,
                  AppColors.splashDotCyan,
                  AppColors.splashDotPink,
                ],
              ),
            ),
            Positioned(
              top: AppSizes.spaceSm,
              right: AppSizes.horizontalPadding,
              child: GestureDetector(
                onTap: widget.onClose,
                child: Container(
                  width: AppSizes.w(36),
                  height: AppSizes.w(36),
                  decoration: const BoxDecoration(
                    color: AppColors.homeCardLavender,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    color: AppColors.iconColor,
                    size: AppSizes.sp(20),
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPadding,
              ),
              child: Column(
                children: [
                  SizedBox(height: AppSizes.spaceXl * 2),
                  Image.asset(
                    AppAssets.lessonCompletedBird,
                    height: AppSizes.h(200),
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: AppSizes.spaceLg),
                  Text(
                    l10n.xpEarnedCelebration(widget.xpEarned),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppFonts.plusJakartaSans,
                      fontSize: AppSizes.sp(28),
                      fontWeight: FontWeight.w700,
                      color: AppColors.xpEarnedTextColor,
                    ),
                  ),
                  SizedBox(height: AppSizes.spaceXl),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.horizontalPadding,
                    ),
                    child: Text(
                      widget.subtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppFonts.plusJakartaSans,
                        fontSize: AppSizes.sp(16),
                        fontWeight: FontWeight.w400,
                        color: AppColors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                  ),
                  SizedBox(height: AppSizes.spaceMd),
                  PrimaryButton(
                    text: widget.buttonText,
                    onPressed: widget.onButtonPressed,
                  ),
                  SizedBox(height: AppSizes.spaceLg),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LessonCompleteChip extends StatelessWidget {
  const LessonCompleteChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.w(16),
        vertical: AppSizes.h(8),
      ),
      decoration: BoxDecoration(
        color: AppColors.chipBackgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.w(20)),
        border: Border.all(color: AppColors.chipBorderColor),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: AppFonts.plusJakartaSans,
          fontSize: AppSizes.sp(15),
          fontWeight: FontWeight.w600,
          color: AppColors.primaryBlueColor,
        ),
      ),
    );
  }
}

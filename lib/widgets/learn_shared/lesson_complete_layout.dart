import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/core/xp/lesson_xp_rewards.dart';
import 'package:fluentta_ai/data/services/entitlements_service.dart';
import 'package:fluentta_ai/data/services/progress_sync_service.dart';
import 'package:fluentta_ai/widgets/common/primary_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class LessonCompleteLayout extends StatefulWidget {
  const LessonCompleteLayout({
    super.key,
    required this.xpEarned,
    required this.subtitle,
    required this.buttonText,
    required this.onClose,
    required this.onButtonPressed,
    this.boostLessonKey,
    this.xpBoostAmount = LessonXpRewards.rewardedBoost,
    this.showXpBoost = true,
    this.summaryCard,
    this.chips,
  });

  final int xpEarned;
  final String subtitle;
  final String buttonText;
  final VoidCallback onClose;
  final VoidCallback onButtonPressed;
  final String? boostLessonKey;
  final int xpBoostAmount;
  final bool showXpBoost;
  final Widget? summaryCard;
  final List<Widget>? chips;

  @override
  State<LessonCompleteLayout> createState() => _LessonCompleteLayoutState();
}

class _LessonCompleteLayoutState extends State<LessonCompleteLayout> {
  late final ConfettiController _confettiController;
  bool _boostClaimed = false;
  bool _boostChecked = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _confettiController.play();
      _maybeAutoBoostForPremium();
    });
  }

  Future<void> _maybeAutoBoostForPremium() async {
    final lessonKey = widget.boostLessonKey;
    if (lessonKey == null || !widget.showXpBoost) {
      if (mounted) setState(() => _boostChecked = true);
      return;
    }

    final sync = context.read<ProgressSyncService>();
    final isPro = context.read<EntitlementsService>().isPro;
    var claimed = await sync.hasLessonXpBoostClaimed(lessonKey);

    if (!claimed && isPro) {
      claimed = await sync.claimLessonXpBoost(
        lessonKey: lessonKey,
        boostAmount: widget.xpBoostAmount,
      );
    }

    if (!mounted) return;
    setState(() {
      _boostClaimed = claimed;
      _boostChecked = true;
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _playCelebration() {
    _confettiController.play();
  }

  Future<void> _onBoostTap() async {
    final lessonKey = widget.boostLessonKey;
    if (lessonKey == null || _boostClaimed) return;

    // Stub rewarded ad — same as out-of-hearts flow until ads SDK is wired.
    final sync = context.read<ProgressSyncService>();
    final granted = await sync.claimLessonXpBoost(
      lessonKey: lessonKey,
      boostAmount: widget.xpBoostAmount,
    );
    if (!mounted) return;
    if (granted) {
      setState(() => _boostClaimed = true);
      _playCelebration();
      SnackbarHelper.showSuccess(
        context,
        context.l10n.xpBoostApplied(widget.xpBoostAmount),
      );
    }
  }

  bool get _showBoostCard {
    if (!widget.showXpBoost || widget.boostLessonKey == null) return false;
    if (!_boostChecked) return false;
    if (_boostClaimed) return false;
    final isPro = context.select<EntitlementsService, bool>((s) => s.isPro);
    return !isPro;
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
                    padding:  EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
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
                  SizedBox(height: AppSizes.spaceLg),
                  if (_showBoostCard) ...[
                    _XpBoostCard(
                      boostAmount: widget.xpBoostAmount,
                      onBoost: _onBoostTap,
                    ),
                    SizedBox(height: AppSizes.spaceLg),
                  ],
                  // if (widget.summaryCard != null) widget.summaryCard!,
                  // if (widget.chips != null)
                  //   Padding(
                  //     padding: EdgeInsets.only(top: AppSizes.spaceMd),
                  //     child: Wrap(
                  //       alignment: WrapAlignment.center,
                  //       spacing: AppSizes.w(18),
                  //       runSpacing: AppSizes.h(15),
                  //       children: widget.chips!,
                  //     ),
                  //   ),
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

class _XpBoostCard extends StatelessWidget {
  const _XpBoostCard({
    required this.boostAmount,
    required this.onBoost,
  });

  final int boostAmount;
  final VoidCallback onBoost;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.w(20)),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.boostYourXp,
                      style: TextStyle(
                        fontFamily: AppFonts.plusJakartaSans,
                        fontSize: AppSizes.sp(20),
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                    SizedBox(height: AppSizes.h(4)),
                    Text(
                      l10n.watchShortAd,
                      style: TextStyle(
                        fontFamily: AppFonts.plusJakartaSans,
                        fontSize: AppSizes.sp(12),
                        fontWeight: FontWeight.w500,
                        color: AppColors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
              SvgPicture.asset(
                'assets/svg/Icon.svg',
                color: AppColors.white.withValues(alpha: 0.35),
                width: AppSizes.sp(38),
                height: AppSizes.sp(38),
              ),
            ],
          ),
          SizedBox(height: AppSizes.spaceMd),
          Material(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSizes.w(10)),
            child: InkWell(
              onTap: onBoost,
              borderRadius: BorderRadius.circular(AppSizes.w(28)),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: AppSizes.h(14)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                    AppAssets.watchAdSvg,
                      width: AppSizes.sp(20),
                      height: AppSizes.sp(20),
                      // colorFilter: const ColorFilter.mode(
                      //   AppColors.primaryColor,
                      //   BlendMode.srcIn,
                      // ),
                    ),
                    SizedBox(width: AppSizes.w(15)),
                    Text(
                      l10n.boostXpButton(boostAmount),
                      style: TextStyle(
                        fontFamily: AppFonts.plusJakartaSans,
                        fontSize: AppSizes.sp(15),
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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

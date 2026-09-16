import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/ads/ad_placement.dart';
import 'package:fluentta_ai/core/ads/admob_service.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/core/xp/lesson_xp_rewards.dart';
import 'package:fluentta_ai/data/services/progress_sync_service.dart';
import 'package:fluentta_ai/viewmodels/home_view_model.dart';
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
    this.interstitialOnExit = true,
    this.summaryCard,
    this.chips,
    this.newlyUnlocked,
  });

  final int xpEarned;
  final String subtitle;
  final String buttonText;
  final VoidCallback onClose;
  final VoidCallback onButtonPressed;
  final String? boostLessonKey;
  final int xpBoostAmount;
  final bool showXpBoost;

  /// PRD 4.4 — count this completion toward the "every 3rd lesson" interstitial
  /// and show one when due. Disabled for roleplay module screens.
  final bool interstitialOnExit;
  final Widget? summaryCard;
  final List<Widget>? chips;

  /// PRD 4.2.4 / 4.2.7 — labels for anything (a CEFR level, a roleplay
  /// scenario) whose XP threshold this lesson's completion just crossed.
  /// Shown as its own "You've just unlocked" section when non-empty.
  final List<String>? newlyUnlocked;

  @override
  State<LessonCompleteLayout> createState() => _LessonCompleteLayoutState();
}

class _LessonCompleteLayoutState extends State<LessonCompleteLayout> {
  late final ConfettiController _confettiController;
  bool _boostClaimed = false;
  bool _boostChecked = false;
  bool _boostLoading = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _confettiController.play();
      _checkBoostClaimed();
    });
  }

  Future<void> _checkBoostClaimed() async {
    final lessonKey = widget.boostLessonKey;
    if (lessonKey == null || !widget.showXpBoost) {
      if (mounted) setState(() => _boostChecked = true);
      return;
    }

    final claimed =
        await context.read<ProgressSyncService>().hasLessonXpBoostClaimed(
              lessonKey,
            );
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

  bool _exiting = false;

  Future<void> _exitWith(VoidCallback action) async {
    if (_exiting) return;
    _exiting = true;
    if (widget.interstitialOnExit) {
      await AdMobService.instance.maybeShowLessonInterstitial();
    }
    if (!mounted) {
      action();
      return;
    }
    action();
  }

  Future<void> _onBoostTap() async {
    final lessonKey = widget.boostLessonKey;
    if (lessonKey == null || _boostClaimed || _boostLoading) return;

    setState(() => _boostLoading = true);

    final rewarded = await AdMobService.instance.showRewarded(
      AdPlacement.rewardedXpBoost,
      onReward: () {},
    );

    if (!mounted) return;
    setState(() => _boostLoading = false);

    if (!rewarded) return;

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

  bool get _grantsBoost =>
      widget.showXpBoost && widget.boostLessonKey != null;

  bool get _isPremium {
    try {
      return context.read<HomeViewModel>().isPro;
    } catch (_) {
      return false;
    }
  }

  /// XP number shown in the celebration. Premium learners get the +5 boost
  /// applied automatically (PRD 4.2.3), so fold it into the headline.
  int get _displayXp =>
      _grantsBoost && _isPremium ? widget.xpEarned + widget.xpBoostAmount : widget.xpEarned;

  bool get _showBoostCard {
    if (!_grantsBoost || !_boostChecked) return false;
    if (_isPremium) return false; // auto-applied, no ad
    if (!AdMobService.instance.shouldDisplay(AdPlacement.rewardedXpBoost)) {
      return false;
    }
    return !_boostClaimed;
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
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
            // The button must always stay on screen — only the content above
            // it (which can grow with a boost card + unlocked-items list)
            // scrolls if it doesn't fit, instead of pushing the button off
            // the bottom of a short device.
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.horizontalPadding,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: AppSizes.spaceXl * 1.4),
                        Image.asset(
                          AppAssets.lessonCompletedBird,
                          height: AppSizes.h(150),
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: AppSizes.spaceMd),
                        Text(
                          l10n.xpEarnedCelebration(_displayXp),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: AppFonts.plusJakartaSans,
                            fontSize: AppSizes.sp(26),
                            fontWeight: FontWeight.w700,
                            color: AppColors.xpEarnedTextColor,
                          ),
                        ),
                        SizedBox(height: AppSizes.spaceMd),
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
                              color:isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                              height: 1.4,
                            ),
                          ),
                        ),
                        if (widget.summaryCard != null) ...[
                          SizedBox(height: AppSizes.spaceMd),
                          widget.summaryCard!,
                        ],
                        if (widget.chips != null && widget.chips!.isNotEmpty) ...[
                          SizedBox(height: AppSizes.spaceMd),
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: AppSizes.w(8),
                            runSpacing: AppSizes.h(8),
                            children: widget.chips!,
                          ),
                        ],
                        if (widget.newlyUnlocked != null &&
                            widget.newlyUnlocked!.isNotEmpty) ...[
                          SizedBox(height: AppSizes.spaceMd),
                          _NewlyUnlockedSection(items: widget.newlyUnlocked!),
                        ],
                        if (_showBoostCard) ...[
                          SizedBox(height: AppSizes.spaceMd),
                          _XpBoostCard(
                            boostAmount: widget.xpBoostAmount,
                            isLoading: _boostLoading,
                            onBoost: _onBoostTap,
                          ),
                        ],
                        SizedBox(height: AppSizes.spaceMd),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSizes.horizontalPadding,
                    AppSizes.spaceSm,
                    AppSizes.horizontalPadding,
                    AppSizes.spaceLg,
                  ),
                  child: PrimaryButton(
                    text: widget.buttonText,
                    onPressed: () => _exitWith(widget.onButtonPressed),
                  ),
                ),
              ],
            ),
            Positioned(
              top: AppSizes.spaceSm,
              right: AppSizes.horizontalPadding,
              child: GestureDetector(
                onTap: () => _exitWith(widget.onClose),
                child: Container(
                  width: AppSizes.w(36),
                  height: AppSizes.w(36),
                  decoration:  BoxDecoration(
                    color:isDark ? AppColors.brandDarkSoftColor : AppColors.homeCardLavender,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    color:isDark ? AppColors.textSecondaryDark : AppColors.iconColor,
                    size: AppSizes.sp(20),
                  ),
                ),
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
    this.isLoading = false,
  });

  final int boostAmount;
  final VoidCallback onBoost;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
                colorFilter: ColorFilter.mode(
                  AppColors.white.withValues(alpha: 0.35),
                  BlendMode.srcIn,
                ),
                width: AppSizes.sp(38),
                height: AppSizes.sp(38),
              ),
            ],
          ),
          SizedBox(height: AppSizes.spaceMd),
          Material(
            color:isDark ? AppColors.surfaceBgDarkColor: AppColors.white,
            borderRadius: BorderRadius.circular(AppSizes.w(10)),
            child: InkWell(
              onTap: isLoading ? null : onBoost,
              borderRadius: BorderRadius.circular(AppSizes.w(28)),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: AppSizes.h(14)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isLoading)
                      SizedBox(
                        width: AppSizes.sp(20),
                        height: AppSizes.sp(20),
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primaryColor,
                        ),
                      )
                    else
                      SvgPicture.asset(
                       isDark ? AppAssets.watchAdDarkSvg : AppAssets.watchAdSvg,
                        width: AppSizes.sp(20),
                        height: AppSizes.sp(20),
                      ),
                    SizedBox(width: AppSizes.w(15)),
                    Text(
                      l10n.boostXpButton(boostAmount),
                      style: TextStyle(
                        fontFamily: AppFonts.plusJakartaSans,
                        fontSize: AppSizes.sp(15),
                        fontWeight: FontWeight.w700,
                        color:isDark ? AppColors.white : AppColors.primaryColor,
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

class _NewlyUnlockedSection extends StatelessWidget {
  const _NewlyUnlockedSection({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.w(16)),
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
              Icon(
                Icons.lock_open_rounded,
                size: AppSizes.sp(18),
                color: AppColors.white,
              ),
              SizedBox(width: AppSizes.w(8)),
              Text(
                l10n.newlyUnlockedHeading,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(14),
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.spaceMd),
          Wrap(
            spacing: AppSizes.w(8),
            runSpacing: AppSizes.h(8),
            children: items
                .map(
                  (label) => Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.w(14),
                      vertical: AppSizes.h(8),
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.surfaceBgDarkColor
                          : AppColors.white,
                      borderRadius: BorderRadius.circular(AppSizes.w(20)),
                    ),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontFamily: AppFonts.plusJakartaSans,
                        fontSize: AppSizes.sp(13),
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                )
                .toList(),
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

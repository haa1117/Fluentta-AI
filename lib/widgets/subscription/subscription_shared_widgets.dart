import 'package:dotted_line/dotted_line.dart';
import 'package:fluentta_ai/widgets/common/icon_background_container.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';

class SubscriptionCloseButton extends StatelessWidget {
  const SubscriptionCloseButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    return Align(
      alignment: Alignment.centerRight,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppSizes.w(20)),
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
    );
  }
}

class SubscriptionOrDivider extends StatelessWidget {
  const SubscriptionOrDivider({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    return Row(
      children: [
        Expanded(
          child: DottedLine(
            dashColor:  Color(0xffD3C4DC),

            // height: 1,
            // color: AppColors.borderLight,
          ),
        ),
        SizedBox(
          width: AppSizes.spaceSm,
        ),
        IconBackgroundContainerWidget(
width: 40,
          height: 40,
          // alignment: Alignment.center,
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: AppFonts.plusJakartaSans,
                fontSize: AppSizes.sp(12),
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),
        SizedBox(
          width: AppSizes.spaceSm,
        ),
        Expanded(
          child: DottedLine(
            // height: 1,
            dashColor:  Color(0xffD3C4DC),
            // color: AppColors.borderLight,
          ),
        ),
      ],
    );
  }
}

class SubscriptionLegalLinks extends StatelessWidget {
  const SubscriptionLegalLinks({
    super.key,
    required this.termsLabel,
    required this.privacyLabel,
    required this.restoreLabel,
    this.onTerms,
    this.onPrivacy,
    this.onRestore,
  });

  final String termsLabel;
  final String privacyLabel;
  final String restoreLabel;
  final VoidCallback? onTerms;
  final VoidCallback? onPrivacy;
  final VoidCallback? onRestore;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _Link(text: termsLabel, onTap: onTerms),
        _dot(),
        _Link(text: privacyLabel, onTap: onPrivacy),
        _dot(),
        _Link(text: restoreLabel, onTap: onRestore),
      ],
    );
  }

  Widget _dot() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.w(8)),
      child: Text(
        '•',
        style: TextStyle(
          color: AppColors.primaryColor,
          fontSize: AppSizes.sp(14),
        ),
      ),
    );
  }
}

class _Link extends StatelessWidget {
  const _Link({required this.text, this.onTap});

  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          fontFamily: AppFonts.plusJakartaSans,
          fontSize: AppSizes.sp(13),
          fontWeight: FontWeight.w600,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }
}

class SubscriptionFeatureList extends StatelessWidget {
  const SubscriptionFeatureList({
    super.key,
    required this.title,
    required this.features,
  });

  final String title;
  final List<String> features;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: AppFonts.plusJakartaSans,
            fontSize: AppSizes.sp(16),
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppSizes.h(12)),
        ...features.map(
          (feature) => Padding(
            padding: EdgeInsets.only(bottom: AppSizes.h(10)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: AppSizes.w(22),
                  height: AppSizes.w(22),
                  decoration: const BoxDecoration(
                    color: AppColors.learnSuccessGreen,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    color: AppColors.white,
                    size: AppSizes.sp(14),
                  ),
                ),
                SizedBox(width: AppSizes.w(10)),
                Expanded(
                  child: Text(
                    feature,
                    style: TextStyle(
                      fontFamily: AppFonts.plusJakartaSans,
                      fontSize: AppSizes.sp(14),
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SubscriptionPlanSummaryCard extends StatelessWidget {
  const SubscriptionPlanSummaryCard({
    super.key,
    required this.goalLabel,
    required this.levelLabel,
    required this.dailyLabel,
    required this.goalTitle,
    required this.levelTitle,
    required this.dailyTitle,
  });

  final String goalLabel;
  final String levelLabel;
  final String dailyLabel;
  final String goalTitle;
  final String levelTitle;
  final String dailyTitle;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.w(12),
        vertical: AppSizes.h(16),
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border.all(color: AppColors.borderLight),
        // boxShadow: [
        //   BoxShadow(
        //     color: AppColors.primaryColor.withValues(alpha: 0.05),
        //     blurRadius: 12,
        //     offset: const Offset(0, 4),
        //   ),
        // ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: _SummaryColumn(label: goalLabel, value: goalTitle),
            ),
            _divider(),
            Expanded(
              child: _SummaryColumn(label: levelLabel, value: levelTitle),
            ),
            _divider(),
            Expanded(
              child: _SummaryColumn(label: dailyLabel, value: dailyTitle),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      margin: EdgeInsets.symmetric(vertical: AppSizes.h(4)),
      color: AppColors.borderLight,
    );
  }
}

class _SummaryColumn extends StatelessWidget {
  const _SummaryColumn({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: AppFonts.plusJakartaSans,
            fontSize: AppSizes.sp(10),
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
            letterSpacing: 0.6,
          ),
        ),
        SizedBox(height: AppSizes.h(4)),
        Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: AppFonts.plusJakartaSans,
            fontSize: AppSizes.sp(15),
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

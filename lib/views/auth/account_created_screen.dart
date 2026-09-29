import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/analytics/analytics_events.dart';
import 'package:fluentta_ai/core/analytics/analytics_params.dart';
import 'package:fluentta_ai/core/analytics/analytics_service.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/widgets/common/primary_button.dart';

class AccountCreatedScreen extends StatefulWidget {
  const AccountCreatedScreen({
    super.key,
    required this.onContinue,
    required this.signupMethod,
  });

  final VoidCallback onContinue;
  final String signupMethod;

  @override
  State<AccountCreatedScreen> createState() => _AccountCreatedScreenState();
}

class _AccountCreatedScreenState extends State<AccountCreatedScreen> {
  bool _loggedViewed = false;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (!_loggedViewed) {
      _loggedViewed = true;
      AnalyticsService.instance.logScreenView('account_created');
      AnalyticsService.instance.log(AnalyticsEvents.accountCreatedViewed, {
        AnalyticsParams.signupMethod: widget.signupMethod,
      });
    }

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRect(
                child: Image.asset(
                  AppAssets.accountCreated,
                  height: AppSizes.h(280),
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: AppSizes.spaceLg),
              Text(
                l10n.accountCreatedTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(28),
                  fontWeight: FontWeight.w700,
                  color:isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.spaceSm / 2),
              Text(
                l10n.accountCreatedSafeDesc,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(14),
                  fontWeight: FontWeight.w400,
                  color:isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              SizedBox(height: AppSizes.spaceXl),
              PrimaryButton(
                text: l10n.continueBtn,
                onPressed: () {
                  AnalyticsService.instance.log(
                    AnalyticsEvents.accountCreatedContinueClicked,
                    {
                      AnalyticsParams.sourceScreen: 'account_created',
                      AnalyticsParams.destinationScreen: 'personalization_goal',
                    },
                  );
                  widget.onContinue();
                },
              ),
              SizedBox(height: AppSizes.spaceXxl),
            ],
          ),
        ),
      ),
    );
  }
}

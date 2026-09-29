import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/analytics/analytics_events.dart';
import 'package:fluentta_ai/core/analytics/analytics_service.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/widgets/auth/auth_widgets.dart';
import 'package:fluentta_ai/widgets/common/primary_button.dart';

class PasswordUpdatedScreen extends StatefulWidget {
  const PasswordUpdatedScreen({super.key, this.onBackToSignIn});

  final VoidCallback? onBackToSignIn;

  @override
  State<PasswordUpdatedScreen> createState() => _PasswordUpdatedScreenState();
}

class _PasswordUpdatedScreenState extends State<PasswordUpdatedScreen> {
  bool _loggedViewed = false;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;

    if (!_loggedViewed) {
      _loggedViewed = true;
      AnalyticsService.instance.logScreenView('password_updated');
    }

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
          child: Column(
            children: [
              const Spacer(flex: 2),
              const AuthIllustration(
                imagePath: AppAssets.passwordUpdated,
                height: 220,
              ),
              SizedBox(height: AppSizes.spaceLg),
              Text(
                l10n.passwordUpdated,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.fontHeadline,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.spaceSm),
              Text(
                l10n.passwordUpdatedDesc,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(14),
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const Spacer(flex: 3),
              PrimaryButton(
                text: l10n.backToSignIn,
                onPressed: () {
                  AnalyticsService.instance.log(
                    AnalyticsEvents.passwordUpdatedReturnClicked,
                  );
                  widget.onBackToSignIn?.call();
                  Navigator.of(context).popUntil((route) => route.isFirst);
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

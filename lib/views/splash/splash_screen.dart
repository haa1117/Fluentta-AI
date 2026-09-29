import 'dart:async';

import 'package:fluentta_ai/core/analytics/analytics_events.dart';
import 'package:fluentta_ai/core/analytics/analytics_params.dart';
import 'package:fluentta_ai/core/analytics/analytics_service.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/viewmodels/splash_view_model.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/widgets/common/splash_dots.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.onComplete});

  final void Function(int durationMs) onComplete;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    AnalyticsService.instance.logScreenView('splash');
    unawaited(_logSplashViewed());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final splash = context.read<SplashViewModel>();
      splash.initializeAndNavigate(() {
        if (!mounted) return;
        widget.onComplete(splash.elapsedMs);
      });
    });
  }

  Future<void> _logSplashViewed() async {
    final info = await PackageInfo.fromPlatform();
    await AnalyticsService.instance.log(AnalyticsEvents.splashViewed, {
      AnalyticsParams.appVersion: info.version,
      // Distinguishing cold/warm/first_open/app_update needs process-lifecycle
      // tracking this app doesn't have yet; cold_start is the safe default.
      AnalyticsParams.launchType: 'cold_start',
    });
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
          child: Column(
            children: [

              SizedBox(
                height: AppSizes.spaceXl * 2,
              ),
              Center(
                child: Image.asset(
                  AppAssets.splashBird,
                  height: AppSizes.splashImageHeight,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: AppSizes.spaceLg),
              Text(
                l10n.appName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily:AppFonts.plusJakartaSans ,
                  fontSize: AppSizes.fontDisplay,
                  fontWeight: FontWeight.w700,
                  color:isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.spaceMd),
              Text(
                l10n.aiEnglishTutor,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: AppSizes.fontTitle,
                  fontWeight: FontWeight.w400,
                  color:isDark ? AppColors.primaryDarkColor : AppColors.primaryColor,
                ),
              ),
              SizedBox(height: AppSizes.spaceMd),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
                child: Text(
                  l10n.speakWithAiTutor,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: AppSizes.fontBody,
                    fontWeight: FontWeight.w500,
                    color:isDark ? AppColors.textSecondaryDark: AppColors.textSecondary,
                  ),
                ),
              ),
              const Spacer(),
              const SplashDots(),
              SizedBox(height: AppSizes.spaceXxl * 2),
            ],
          ),
        ),
      ),
    );
  }

}

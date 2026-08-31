import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/viewmodels/splash_view_model.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/widgets/common/splash_dots.dart';
import 'package:provider/provider.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.onComplete});

  final VoidCallback onComplete;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SplashViewModel>().initializeAndNavigate(
            widget.onComplete,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;

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
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.spaceMd),
              Text(
                l10n.aiEnglishTutor,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: AppSizes.fontTitle,
                  fontWeight: FontWeight.w400,
                  color: AppColors.primaryColor,
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
                    color: AppColors.textSecondary,
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

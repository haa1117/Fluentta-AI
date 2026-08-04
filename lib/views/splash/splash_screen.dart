import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/viewmodels/splash_view_model.dart';
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
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context.read<SplashViewModel>().navigateAfterDelay(
    //         context,
    //         widget.onComplete,
    //       );
    // });
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
          child: Column(
            children: [

              SizedBox(
                height: AppSizes.spaceXl * 2,
              ),
              // const Spacer(flex: 2),
              Center(
                child: Image.asset(
                  AppAssets.splashBird,
                  height: AppSizes.splashImageHeight,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: AppSizes.spaceLg),
              Text(
                'Fluenta',
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
                'AI English Tutor',
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
                  'Speak English with your AI tutor.',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _dot(AppColors.splashDotCyan),
                  SizedBox(width: AppSizes.w(8)),
                  _dot(AppColors.splashDotPurple),
                  SizedBox(width: AppSizes.w(8)),
                  _dot(AppColors.splashDotPink),
                ],
              ),
              SizedBox(height: AppSizes.spaceXxl * 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dot(Color color) {
    return Container(
      width: AppSizes.w(10),
      height: AppSizes.w(10),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

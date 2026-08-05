import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: Center(
        child: Text(
          'Welcome to Fluenta!',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: AppSizes.fontHeadline,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

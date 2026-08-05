import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';

class AppTheme {
  AppTheme._();

  static const String fontFamily = 'PlusJakartaSans';

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryColor,
        primary: AppColors.primaryColor,
        surface: AppColors.scaffoldBackgroundColor,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: fontFamily,
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        headlineMedium: TextStyle(
          fontFamily: fontFamily,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        titleLarge: TextStyle(
          fontFamily: fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        titleMedium: TextStyle(
          fontFamily: fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontFamily: fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
        ),
        bodyMedium: TextStyle(
          fontFamily: fontFamily,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
        ),
        labelLarge: TextStyle(
          fontFamily: fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.white,
        ),
      ),
    );
  }
}

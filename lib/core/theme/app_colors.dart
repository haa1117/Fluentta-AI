import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primaryColor = Color(0xFF9B35F4);
  static const Color scaffoldBackgroundColor = Color(0xFFFCF7FF);

  static const Color primaryGradientStart = Color(0xFF8C31EF);
  static const Color primaryGradientEnd = Color(0xFFB247F3);

  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF665D72);
  static const Color textTertiary = Color(0xFF9CA3AF);

  static const Color borderLight = Color(0xFFE0D5E9);
  static const Color borderSelected = primaryColor;

  static const Color white = Color(0xFFFFFFFF);
  static const Color adBackground = Color(0xFFF9FAFB);
  static const Color adBorder = Color(0xFFE5E7EB);
  static const Color adPlaceholder = Color(0xFFD1D5DB);
  static const Color adBadgeBorder = Color(0xFFFBBF24);

  static const Color splashDotCyan = Color(0xFF09EBD5);
  static const Color splashDotPurple = Color(0xFF6934FF);
  static const Color splashDotPink = Color(0xFFE65BFF);

  static const Color bannerGradientStart = Color(0xFFF3E8FF);
  static const Color bannerGradientEnd = Color(0xFFEDE9FE);

  static const Color radioUnselected = Color(0xFFD1D5DB);

  static const Color heartRed = Color(0xFFFF4D6D);
  static const Color homeCardLavender = Color(0xFFF3EBFF);
  static const Color homeCardLavenderDark = Color(0xFFEDE4FF);
  static const Color navInactive = Color(0xFF9CA3AF);
  static const Color progressTrack = Color(0xFFE8D9F8);
  static const Color resumeButtonBg = Color(0xFFF3EBFF);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      primaryGradientStart,
      primaryGradientEnd,
    ],
  );

  static const LinearGradient bannerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      bannerGradientStart,
      bannerGradientEnd,
    ],
  );
}

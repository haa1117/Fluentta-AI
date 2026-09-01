import 'package:flutter/material.dart';

class AppSizes {
  AppSizes._();

  static const double _designWidth = 375;
  static const double _designHeight = 812;

  static late double screenWidth;
  static late double screenHeight;

  static void init(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    screenWidth = size.width;
    screenHeight = size.height;
  }

  static double w(double value) => value * screenWidth / _designWidth;

  static double h(double value) => value * screenHeight / _designHeight;

  static double sp(double value) => value * screenWidth / _designWidth;

  // Padding & Margins
  static double get horizontalPadding => w(24);
  static double get verticalPadding => h(16);
  static double get screenPadding => w(20);

  // Font Sizes
  static double get fontDisplay => sp(32);
  static double get fontHeadline => sp(22);
  static double get fontTitle => sp(22);
  static double get fontSubtitle => sp(16);
  static double get fontBody => sp(19);
  static double get fontCaption => sp(12);
  static double get fontButton => sp(16);
  static double get fontSmall => sp(11);

  // Component Sizes
  static double get buttonHeight => h(54);
  static double get buttonRadius => w(12);
  static double get cardRadius => w(16);
  static double get tileRadius => w(12);
  static double get adRadius => w(12);

  static double get iconSmall => w(20);
  static double get iconMedium => w(24);
  static double get iconLarge => w(40);

  static double get pageIndicatorActiveWidth => w(24);
  static double get pageIndicatorInactiveSize => w(8);
  static double get pageIndicatorHeight => h(8);

  static double get flagSize => w(40);
  static double get radioSize => w(22);

  // Spacing
  static double get spaceXs => h(4);
  static double get spaceSm => h(8);
  static double get spaceMd => h(16);
  static double get spaceLg => h(24);
  static double get spaceXl => h(32);
  static double get spaceXxl => h(48);

  static double get onboardingImageHeight => h(280);
  static double get splashImageHeight => h(320);
  static double get adPlaceholderHeight => h(180);
  static double get bannerHeight => h(140);
}

import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/ads/ad_placement.dart';
import 'package:fluentta_ai/core/ads/admob_service.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/widgets/ads/ad_banner_widget.dart';

class SetupBannerAd extends StatelessWidget {
  const SetupBannerAd({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AdMobService.instance,
      builder: (context, _) {
        if (!AdMobService.instance.shouldDisplay(AdPlacement.setupBanner)) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            // Text(
            //   'ADVERTISEMENT',
            //   style: TextStyle(
            //     fontFamily: AppFonts.plusJakartaSans,
            //     fontSize: AppSizes.sp(10),
            //     fontWeight: FontWeight.w500,
            //     color: AppColors.textTertiary,
            //     letterSpacing: 0.8,
            //   ),
            // ),
            // SizedBox(height: AppSizes.spaceSm),
            AdBannerWidget(
              placement: AdPlacement.setupBanner,
              fallbackHeight: AppSizes.h(50),
            ),
          ],
        );
      },
    );
  }
}

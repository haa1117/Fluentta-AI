import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/data/models/roleplay_scenario_model.dart';

class RoleplayScenarioCard extends StatelessWidget {
  const RoleplayScenarioCard({
    super.key,
    required this.scenario,
    required this.isSelected,
    required this.onTap,
    this.isLocked = false, required this.isDark,
  });

  final RoleplayScenarioModel scenario;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isLocked;
  final bool isDark;

  /// Height for horizontal scenario lists — keeps cards from clipping.
  static double listExtent(BuildContext context) {
    AppSizes.init(context);
    return AppSizes.w(150) +
        AppSizes.h(8) +
        AppSizes.sp(13) * 1.2 * 2 +
        AppSizes.h(4);
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final imageSize = AppSizes.w(160);

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: imageSize,
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: imageSize,
              height: imageSize,
              decoration: BoxDecoration(
                color:isDark ? AppColors.surfaceBgDarkColor :const Color(0xffFFFFFF),
                border: Border.all(
                  color:isDark? AppColors.borderDarkColor : AppColors.borderLight,
                ),
                borderRadius: BorderRadius.circular(AppSizes.cardRadius),
              ),
              child: Stack(
                children: [
                  if (scenario.imagePath != null)
                    Center(
                      child: Image.asset(
                        scenario.imagePath!,
                        width: AppSizes.sp(96),
                        height: AppSizes.sp(96),
                        color: isLocked
                            ? Colors.grey.withValues(alpha: 0.35)
                            : null,
                        colorBlendMode:
                            isLocked ? BlendMode.saturation : null,
                      ),
                    )
                  else
                    _ScenarioPlaceholder(icon: scenario.icon),
                  // if (isLocked)
                  //   Positioned(
                  //     top: AppSizes.h(8),
                  //     right: AppSizes.w(8),
                  //     child: Container(
                  //       padding: EdgeInsets.all(AppSizes.w(6)),
                  //       decoration: BoxDecoration(
                  //         color: Colors.black.withValues(alpha: 0.55),
                  //         shape: BoxShape.circle,
                  //       ),
                  //       child: Icon(
                  //         Icons.lock_rounded,
                  //         color: AppColors.white,
                  //         size: AppSizes.sp(14),
                  //       ),
                  //     ),
                  //   ),
                ],
              ),
            ),
            SizedBox(height: AppSizes.h(8)),
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  scenario.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(13),
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScenarioPlaceholder extends StatelessWidget {
  const _ScenarioPlaceholder({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        icon,
        size: AppSizes.w(48),
        color: AppColors.primaryColor.withValues(alpha: 0.6),
      ),
    );
  }
}

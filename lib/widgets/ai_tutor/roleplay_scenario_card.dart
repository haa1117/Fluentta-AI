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
    this.isLocked = false,
    this.isAdvanced = false,
    this.xpRequired,
    required this.isDark,
  });

  final RoleplayScenarioModel scenario;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isLocked;

  /// PRD 7.3 — advanced roleplays (Pro-only) get a distinct "ADVANCED" banner.
  final bool isAdvanced;

  /// PRD 4.2.7 — cumulative XP still needed to unlock this scenario. Null or
  /// 0 when the scenario's XP milestone has already been reached.
  final int? xpRequired;
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
                  if (isAdvanced)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(AppSizes.cardRadius),
                          bottomRight: Radius.circular(AppSizes.cardRadius),
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            vertical: AppSizes.h(3),
                          ),
                          color: AppColors.xpEarnedTextColor,
                          child: Text(
                            'ADVANCED',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: AppFonts.plusJakartaSans,
                              fontSize: AppSizes.sp(9),
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.6,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (isLocked)
                    Positioned(
                      top: AppSizes.h(6),
                      right: AppSizes.w(6),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSizes.w(6),
                          vertical: AppSizes.h(3),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(AppSizes.w(8)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.lock_rounded,
                              color: AppColors.white,
                              size: AppSizes.sp(11),
                            ),
                            if (xpRequired != null && xpRequired! > 0) ...[
                              SizedBox(width: AppSizes.w(3)),
                              Text(
                                '$xpRequired XP',
                                style: TextStyle(
                                  fontFamily: AppFonts.plusJakartaSans,
                                  fontSize: AppSizes.sp(10),
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
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
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimary,
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

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
  });

  final RoleplayScenarioModel scenario;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: AppSizes.w(140),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: AppSizes.w(140),
              height: AppSizes.w(140),
              decoration: BoxDecoration(
                color: AppColors.homeCardLavender,
                borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryColor
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: scenario.imagePath != null
                  ? Center(
                    child: Image.asset(
                      scenario.imagePath!,
                      // fit: BoxFit.cover,
                      width: AppSizes.sp(80),
                      height: AppSizes.sp(80),
                    ),
                  )
                  : _ScenarioPlaceholder(icon: scenario.icon),
            ),
            SizedBox(height: AppSizes.h(10)),
            Text(
              scenario.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: AppFonts.plusJakartaSans,
                fontSize: AppSizes.sp(14),
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                height: 1.2,
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

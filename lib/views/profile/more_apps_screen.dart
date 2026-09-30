import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/analytics/analytics_events.dart';
import 'package:fluentta_ai/core/analytics/analytics_params.dart';
import 'package:fluentta_ai/core/analytics/analytics_service.dart';
import 'package:fluentta_ai/core/config/more_apps_catalog.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/haptics/haptic_service.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/core/utils/online_gate.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/widgets/common/appbar_widget.dart';
import 'package:url_launcher/url_launcher.dart';

/// Profile > Support & Legal > More Apps: other Futurewatch apps with store links.
class MoreAppsScreen extends StatelessWidget {
  const MoreAppsScreen({super.key});

  Future<void> _openApp(BuildContext context, MoreAppEntry app) async {
    if (!OnlineGate.guard(context)) return;
    AnalyticsService.instance.log(AnalyticsEvents.moreAppsClicked, {
      AnalyticsParams.sourceScreen: 'more_apps',
      AnalyticsParams.appName: app.name,
    });
    try {
      final launched = await launchUrl(
        Uri.parse(app.storeUrl),
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        SnackbarHelper.showError(context, context.l10n.featureNeedsInternet);
      }
    } catch (_) {
      if (context.mounted) {
        SnackbarHelper.showError(context, context.l10n.featureNeedsInternet);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceBgDarkColor : AppColors.white;
    final border = isDark ? AppColors.borderDarkColor : AppColors.borderLight;
    final titleColor =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final subColor =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      appBar: AppBarWidget(
        title: l10n.moreApps,
        showBackButton: true,
        showActionButton: false,
        centerTitle: true,
      ),
      body: SafeArea(
        top: false,
        child: ListView.separated(
          padding: EdgeInsets.fromLTRB(
            AppSizes.horizontalPadding,
            AppSizes.spaceMd,
            AppSizes.horizontalPadding,
            AppSizes.spaceLg,
          ),
          itemCount: MoreAppsCatalog.apps.length + 1,
          separatorBuilder: (_, _) => SizedBox(height: AppSizes.h(12)),
          itemBuilder: (context, index) {
            if (index == 0) {
              return Text(
                l10n.moreAppsSub,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(14),
                  height: 1.4,
                  color: subColor,
                ),
              );
            }
            final app = MoreAppsCatalog.apps[index - 1];
            return Material(
              color: surface,
              borderRadius: BorderRadius.circular(AppSizes.w(16)),
              child: InkWell(
                borderRadius: BorderRadius.circular(AppSizes.w(16)),
                onTap: HapticService.wrap(() => _openApp(context, app)),
                child: Container(
                  padding: EdgeInsets.all(AppSizes.w(12)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSizes.w(16)),
                    border: Border.all(color: border),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppSizes.w(14)),
                        child: Image.asset(
                          app.iconAsset,
                          width: AppSizes.w(52),
                          height: AppSizes.w(52),
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: AppSizes.w(14)),
                      Expanded(
                        child: Text(
                          app.name,
                          style: TextStyle(
                            fontFamily: AppFonts.plusJakartaSans,
                            fontSize: AppSizes.sp(15),
                            fontWeight: FontWeight.w700,
                            color: titleColor,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: AppSizes.w(22),
                        color: subColor,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

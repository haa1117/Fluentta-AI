import 'package:fluentta_ai/core/haptics/haptic_service.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/network/connectivity_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/viewmodels/auth_view_model.dart';
import 'package:fluentta_ai/widgets/common/primary_button.dart';
import 'package:provider/provider.dart';

/// Offline gate card: Figma 382:3414 (light) and 781:9653 (dark).
class OfflineGate extends StatelessWidget {
  const OfflineGate({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();
    final net = context.watch<ConnectivityViewModel>();
    final show = auth.isAuthenticated && net.showOfflinePrompt;

    return Stack(
      children: [
        child,
        if (show) ...[
          const ModalBarrier(
            dismissible: false,
            color: Color(0x99000000),
          ),
          const SafeArea(
            child: Center(child: OfflineModeCard()),
          ),
        ],
      ],
    );
  }
}

class OfflineModeCard extends StatefulWidget {
  const OfflineModeCard({super.key});

  @override
  State<OfflineModeCard> createState() => _OfflineModeCardState();
}

class _OfflineModeCardState extends State<OfflineModeCard> {
  bool _retrying = false;

  Future<void> _retry() async {
    setState(() => _retrying = true);
    await context.read<ConnectivityViewModel>().retryConnection();
    if (mounted) setState(() => _retrying = false);
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final net = context.watch<ConnectivityViewModel>();

    final surface =
        isDark ? AppColors.surfaceBgDarkColor : AppColors.white;
    final border =
        isDark ? AppColors.borderDarkColor : AppColors.borderLight;
    final titleColor =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final bodyColor =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final continueColor =
        isDark ? AppColors.brandDeepDarkColor : AppColors.primaryBlueColor;

    return Material(
      color: Colors.transparent,
      child: Container(
        width: AppSizes.w(370),
        margin: EdgeInsets.symmetric(horizontal: AppSizes.w(24)),
        padding: EdgeInsets.all(AppSizes.w(24)),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(AppSizes.w(28)),
          border: Border.all(color: border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: AppSizes.w(140),
              height: AppSizes.h(132),
              child: Image.asset(
                isDark
                    ? AppAssets.offlineModeBirdDark
                    : AppAssets.offlineModeBird,
                width: AppSizes.w(140),
                height: AppSizes.w(140),
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: AppSizes.h(8)),
              child: Text(
                l10n.youreOffline,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(20),
                  fontWeight: FontWeight.w600,
                  height: 28 / 20,
                  color: titleColor,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSizes.w(12),
                0,
                AppSizes.w(12),
                AppSizes.h(32),
              ),
              child: Text(
                l10n.youreOfflineBody,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(16),
                  fontWeight: FontWeight.w400,
                  height: 24 / 16,
                  color: bodyColor,
                ),
              ),
            ),
            PrimaryButton(
              text: l10n.retryConnection,
              isLoading: _retrying,
              onPressed: _retrying ? null : _retry,
            ),
            SizedBox(height: AppSizes.h(8)),
            SizedBox(
              height: AppSizes.h(52),
              width: double.infinity,
              child: TextButton(
                onPressed: HapticService.wrap(net.continueOffline),
                child: Text(
                  l10n.continueOffline,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(16),
                    fontWeight: FontWeight.w600,
                    color: continueColor,
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

import 'package:fluentta_ai/core/haptics/haptic_service.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/network/connectivity_view_model.dart';
import 'package:fluentta_ai/core/network/network_status.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/widgets/common/primary_button.dart';
import 'package:provider/provider.dart';

/// If already online, returns true. Otherwise asks the learner to connect,
/// waits until they are online (or cancel), then returns whether to show the ad.
Future<bool> ensureOnlineForRewardedAd(BuildContext context) async {
  if (NetworkStatus.lastKnownOnline) return true;
  final connected = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (_) => const ConnectToWatchAdDialog(),
  );
  return connected == true && NetworkStatus.lastKnownOnline;
}

class ConnectToWatchAdDialog extends StatefulWidget {
  const ConnectToWatchAdDialog({super.key});

  @override
  State<ConnectToWatchAdDialog> createState() => _ConnectToWatchAdDialogState();
}

class _ConnectToWatchAdDialogState extends State<ConnectToWatchAdDialog> {
  bool _retrying = false;
  bool _closed = false;

  void _finish(bool connected) {
    if (_closed || !mounted) return;
    _closed = true;
    Navigator.of(context).pop(connected);
  }

  Future<void> _retry() async {
    setState(() => _retrying = true);
    final online =
        await context.read<ConnectivityViewModel>().retryConnection();
    if (!mounted) return;
    setState(() => _retrying = false);
    if (online) _finish(true);
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final net = context.watch<ConnectivityViewModel>();

    if (net.isOnline) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _finish(true);
      });
    }

    final surface = isDark ? AppColors.surfaceBgDarkColor : AppColors.white;
    final border = isDark ? AppColors.borderDarkColor : AppColors.borderLight;
    final titleColor =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final bodyColor =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final cancelColor =
        isDark ? AppColors.brandDeepDarkColor : AppColors.primaryBlueColor;

    return Dialog(
      backgroundColor: surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.w(25)),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: AppSizes.w(28)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.w(25)),
          border: Border.all(color: border),
        ),
        padding: EdgeInsets.all(AppSizes.w(24)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.connectToWatchAdTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppFonts.plusJakartaSans,
                fontSize: AppSizes.sp(20),
                fontWeight: FontWeight.w700,
                color: titleColor,
              ),
            ),
            SizedBox(height: AppSizes.h(10)),
            Text(
              l10n.connectToWatchAdMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppFonts.plusJakartaSans,
                fontSize: AppSizes.sp(14),
                height: 1.45,
                color: bodyColor,
              ),
            ),
            SizedBox(height: AppSizes.h(24)),
            PrimaryButton(
              text: l10n.retryConnection,
              isLoading: _retrying,
              onPressed: _retrying ? null : _retry,
            ),
            SizedBox(
              height: AppSizes.h(52),
              width: double.infinity,
              child: TextButton(
                onPressed: HapticService.wrap(() => _finish(false)),
                child: Text(
                  l10n.cancelBtn,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(16),
                    fontWeight: FontWeight.w600,
                    color: cancelColor,
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

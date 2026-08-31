import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/viewmodels/profile_view_model.dart';
import 'package:fluentta_ai/views/profile/reminder_time_screen.dart';
import 'package:fluentta_ai/widgets/common/appbar_widget.dart';
import 'package:provider/provider.dart';

class NotificationsRemindersScreen extends StatelessWidget {
  const NotificationsRemindersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final profile = context.watch<ProfileViewModel>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      appBar: AppBarWidget(
        title: l10n.notificationsReminders,
        showBackButton: true,
        showActionButton: false,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          AppSizes.horizontalPadding,
          AppSizes.spaceMd,
          AppSizes.horizontalPadding,
          AppSizes.spaceLg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ToggleCard(
              title: l10n.allowNotifications,
              subtitle: l10n.allowNotificationsSub,
              value: profile.notificationsEnabled,
              onChanged: profile.setNotificationsEnabled,
            ),
            SizedBox(height: AppSizes.h(20)),
            Text(
              l10n.practiceReminders,
              style: TextStyle(
                fontFamily: AppFonts.plusJakartaSans,
                fontSize: AppSizes.sp(11),
                fontWeight: FontWeight.w600,
                color: AppColors.textTertiary,
                letterSpacing: 0.8,
              ),
            ),
            SizedBox(height: AppSizes.h(8)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.w(2),vertical: AppSizes.w(10)),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppSizes.sp(20) ),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                children: [
                  _ReminderToggleRow(
                    icon: Icons.event_repeat_rounded,
                    title: l10n.dailyReminder,
                    value: profile.dailyReminderEnabled,
                    enabled: profile.notificationsEnabled,
                    onChanged: profile.setDailyReminderEnabled,
                  ),
                  // Divider(
                  //   height: 1,
                  //   color: AppColors.borderLight.withValues(alpha: 0.7),
                  //   indent: AppSizes.w(16),
                  //   endIndent: AppSizes.w(16),
                  // ),
                  SizedBox(
                    height: AppSizes.spaceLg,
                  ),
                  _ReminderTimeRow(
                    title: l10n.reminderTime,
                    timeLabel: profile.formattedReminderTime(context),
                    enabled: profile.notificationsEnabled &&
                        profile.dailyReminderEnabled,
                    onTap: () {
                      Navigator.of(context).push<void>(
                        MaterialPageRoute<void>(
                          builder: (_) => const ReminderTimeScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSizes.h(24)),
            const _AdPlaceholder(),
          ],
        ),
      ),
    );
  }
}

class _ToggleCard extends StatelessWidget {
  const _ToggleCard({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.w(20)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.sp(20) ),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(16),
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSizes.h(4)),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(13),
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeTrackColor: AppColors.primaryColor.withValues(alpha: 0.35),
            thumbColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.selected)
                  ? AppColors.primaryColor
                  : null,
            ),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _ReminderToggleRow extends StatelessWidget {
  const _ReminderToggleRow({
    required this.icon,
    required this.title,
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final bool value;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.w(16),
        vertical: AppSizes.h(12),
      ),
      child: Row(
        children: [
          Container(
            width: AppSizes.w(40),
            height: AppSizes.w(40),
            decoration: const BoxDecoration(
              color: AppColors.homeCardLavender,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primaryColor, size: AppSizes.sp(20)),
          ),
          SizedBox(width: AppSizes.w(12)),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: AppFonts.plusJakartaSans,
                fontSize: AppSizes.sp(15),
                fontWeight: FontWeight.w400,
                color: enabled
                    ? AppColors.textPrimary
                    : AppColors.textTertiary,
              ),
            ),
          ),
          Switch.adaptive(
            value: value && enabled,
            activeTrackColor: AppColors.primaryColor.withValues(alpha: 0.35),
            thumbColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.selected)
                  ? AppColors.primaryColor
                  : null,
            ),
            onChanged: enabled ? onChanged : null,
          ),
        ],
      ),
    );
  }
}

class _ReminderTimeRow extends StatelessWidget {
  const _ReminderTimeRow({
    required this.title,
    required this.timeLabel,
    required this.enabled,
    required this.onTap,
  });

  final String title;
  final String timeLabel;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.w(16),
            vertical: AppSizes.h(12),
          ),
          child: Row(
            children: [
              Container(
                width: AppSizes.w(40),
                height: AppSizes.w(40),
                decoration: const BoxDecoration(
                  color: AppColors.homeCardLavender,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.alarm_rounded,
                  color: AppColors.primaryColor,
                  size: AppSizes.sp(20),
                ),
              ),
              SizedBox(width: AppSizes.w(12)),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(15),
                    fontWeight: FontWeight.w400,
                    color: enabled
                        ? AppColors.textPrimary
                        : AppColors.textTertiary,
                  ),
                ),
              ),
              Text(
                timeLabel,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(14),
                  fontWeight: FontWeight.w600,
                  color: enabled
                      ? AppColors.primaryColor
                      : AppColors.textTertiary,
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary,
                size: AppSizes.sp(22),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdPlaceholder extends StatelessWidget {
  const _AdPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.w(16)),
      decoration: BoxDecoration(
        color: AppColors.adBackground,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border.all(color: AppColors.adBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.w(8),
              vertical: AppSizes.h(2),
            ),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.adBadgeBorder),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'Ad',
              style: TextStyle(
                fontFamily: AppFonts.plusJakartaSans,
                fontSize: AppSizes.sp(10),
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          SizedBox(height: AppSizes.h(12)),
          Row(
            children: [
              Container(
                width: AppSizes.w(36),
                height: AppSizes.w(36),
                decoration: const BoxDecoration(
                  color: AppColors.adPlaceholder,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: AppSizes.w(10)),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      height: AppSizes.h(8),
                      decoration: BoxDecoration(
                        color: AppColors.adPlaceholder,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    SizedBox(height: AppSizes.h(6)),
                    Container(
                      height: AppSizes.h(8),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.adPlaceholder.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.h(12)),
          Container(
            height: AppSizes.h(80),
            decoration: BoxDecoration(
              color: AppColors.adPlaceholder.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppSizes.w(12)),
            ),
          ),
        ],
      ),
    );
  }
}

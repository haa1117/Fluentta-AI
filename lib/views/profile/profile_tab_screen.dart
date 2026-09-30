import 'package:fluentta_ai/core/analytics/analytics_events.dart';
import 'package:fluentta_ai/core/analytics/analytics_params.dart';
import 'package:fluentta_ai/core/analytics/analytics_service.dart';
import 'package:fluentta_ai/core/constants/legal_urls.dart';
import 'package:fluentta_ai/widgets/common/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/core/theme/theme_view_model.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/data/repositories/auth_repository.dart';
import 'package:fluentta_ai/data/repositories/user_repository.dart';
import 'package:fluentta_ai/data/services/rate_app_service.dart';
import 'package:fluentta_ai/viewmodels/setup_view_model.dart';
import 'package:fluentta_ai/views/setup/setup_flow_screen.dart';
import 'package:fluentta_ai/viewmodels/auth_view_model.dart';
import 'package:fluentta_ai/viewmodels/grammar_view_model.dart';
import 'package:fluentta_ai/viewmodels/learn_view_model.dart';
import 'package:fluentta_ai/viewmodels/reading_view_model.dart';
import 'package:fluentta_ai/viewmodels/vocabulary_view_model.dart';
import 'package:fluentta_ai/viewmodels/profile_view_model.dart';
import 'package:fluentta_ai/viewmodels/subscription_view_model.dart';
import 'package:fluentta_ai/views/language/language_selection_screen.dart';
import 'package:fluentta_ai/views/profile/account_and_security_screen.dart';
import 'package:fluentta_ai/views/profile/notifications_reminders_screen.dart';
import 'package:fluentta_ai/widgets/profile/app_appearance_sheet.dart';
import 'package:fluentta_ai/widgets/profile/profile_daily_goal_card.dart';
import 'package:fluentta_ai/views/profile/weekly_progress_report_screen.dart';
import 'package:fluentta_ai/widgets/common/pro_feature_sheet.dart';
import 'package:fluentta_ai/widgets/profile/profile_dialogs.dart';
import 'package:fluentta_ai/widgets/profile/profile_premium_card.dart';
import 'package:fluentta_ai/widgets/profile/profile_section_header.dart';
import 'package:fluentta_ai/widgets/profile/profile_settings_tile.dart';
import 'package:fluentta_ai/widgets/profile/profile_stats_grid.dart';
import 'package:fluentta_ai/widgets/profile/profile_user_card.dart';
import 'package:fluentta_ai/core/consent/consent_service.dart';
import 'package:fluentta_ai/views/tutorial/tutorial_screen.dart';
import 'package:fluentta_ai/views/profile/more_apps_screen.dart';
import 'package:provider/provider.dart';

class ProfileTabScreen extends StatefulWidget {
  const ProfileTabScreen({super.key});

  @override
  State<ProfileTabScreen> createState() => _ProfileTabScreenState();
}

class _ProfileTabScreenState extends State<ProfileTabScreen> {
  bool _loggedViewed = false;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final authViewModel = context.watch<AuthViewModel>();
    context.watch<LocaleViewModel>();
    final profile = context.watch<ProfileViewModel>();
    final themeViewModel = context.watch<ThemeViewModel>();
    final languageCode = authViewModel.selectedLanguage ?? 'en';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (!_loggedViewed) {
      _loggedViewed = true;
      AnalyticsService.instance.logScreenView('profile');
      AnalyticsService.instance.log(AnalyticsEvents.profileViewed, {
        AnalyticsParams.subscriptionTierAtEvent: profile.isPro ? 'pro' : 'free',
        AnalyticsParams.currentXp: profile.xpEarned,
        AnalyticsParams.currentCefrLevel: profile.cefrLevelCode(l10n),
      });
    }

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      appBar: AppBarWidget(title: l10n.profileTitle),
      body: SafeArea(
        child: Column(
          children: [
            // Padding(
            //   padding: EdgeInsets.fromLTRB(
            //     AppSizes.horizontalPadding,
            //     AppSizes.spaceMd,
            //     AppSizes.horizontalPadding,
            //     0,
            //   ),
            //   child: Row(
            //     children: [
            //       Text(
            //         l10n.profileTitle,
            //         style: TextStyle(
            //           fontFamily: AppFonts.plusJakartaSans,
            //           fontSize: AppSizes.sp(24),
            //           fontWeight: FontWeight.w700,
            //           color: AppColors.primaryColor,
            //         ),
            //       ),
            //       const Spacer(),
            //       Container(
            //         padding: EdgeInsets.symmetric(
            //           horizontal: AppSizes.w(12),
            //           vertical: AppSizes.h(6),
            //         ),
            //         decoration: BoxDecoration(
            //           color: AppColors.homeCardLavender,
            //           borderRadius: BorderRadius.circular(AppSizes.w(20)),
            //         ),
            //         child: Row(
            //           children: [
            //             Text(
            //               '${profile.lives}',
            //               style: TextStyle(
            //                 fontFamily: AppFonts.plusJakartaSans,
            //                 fontSize: AppSizes.sp(14),
            //                 fontWeight: FontWeight.w700,
            //                 color: AppColors.textPrimary,
            //               ),
            //             ),
            //             SizedBox(width: AppSizes.w(4)),
            //             Icon(
            //               Icons.favorite,
            //               color: AppColors.heartRed,
            //               size: AppSizes.sp(16),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  AppSizes.horizontalPadding,
                  AppSizes.spaceMd,
                  AppSizes.horizontalPadding,
                  AppSizes.spaceLg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ProfileUserCard(),
                    SizedBox(height: AppSizes.h(16)),
                    const ProfilePremiumCard(),
                    SizedBox(height: AppSizes.h(20)),
                    ProfileSectionHeader(title: l10n.yourStats, isDark: isDark),
                    const ProfileStatsGrid(),
                    SizedBox(height: AppSizes.h(20)),
                    ProfileDailyGoalCard(
                      onChangeGoal: () {
                        AnalyticsService.instance.log(
                          AnalyticsEvents.changeDailyGoalClicked,
                          {
                            AnalyticsParams.sourceScreen: 'profile',
                            AnalyticsParams.dailyGoalMinutes:
                                profile.dailyGoalMinutes,
                          },
                        );
                        _openLearningPreferences(context);
                      },
                      isDark: isDark,
                    ),
                    SizedBox(height: AppSizes.h(20)),
                    ProfileSectionHeader(
                      title: l10n.accountSection,
                      isDark: isDark,
                    ),
                    ProfileSettingsGroup(
                      children: [
                        ProfileSettingsTile(
                          isDark: isDark,
                          svgIcon: 'assets/svg/account_settings_icon.svg',
                          title: l10n.accountAndSecurity,
                          subtitle: l10n.accountAndSecuritySub,
                          onTap: () {
                            AnalyticsService.instance.log(
                              AnalyticsEvents.accountSecurityClicked,
                              {
                                AnalyticsParams.sourceScreen: 'profile',
                                AnalyticsParams.destinationScreen:
                                    'account_and_security',
                              },
                            );
                            Navigator.of(context).push<void>(
                              MaterialPageRoute<void>(
                                builder: (_) =>
                                    const AccountAndSecurityScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.h(20)),
                    ProfileSectionHeader(
                      title: l10n.settingsSection,
                      isDark: isDark,
                    ),
                    ProfileSettingsGroup(
                      children: [
                        // ProfileSettingsTile(
                        //   svgIcon: 'assets/svg/learn.svg',
                        //   title: l10n.learningPreferences,
                        //   subtitle: l10n.learningPreferencesSub,
                        //   onTap: () => _openLearningPreferences(context),
                        // ),
                        ProfileSettingsTile(
                          isDark: isDark,
                          svgIcon: 'assets/svg/language.svg',
                          title: l10n.profileLanguage,
                          subtitle: l10n.englishExplanationsIn(
                            localizedLanguageName(l10n, languageCode),
                          ),
                          onTap: () {
                            AnalyticsService.instance.log(
                              AnalyticsEvents.profileLanguageClicked,
                              {
                                AnalyticsParams.sourceScreen: 'profile',
                                AnalyticsParams.destinationScreen:
                                    'language_selection',
                              },
                            );
                            Navigator.of(context).push<void>(
                              MaterialPageRoute<void>(
                                builder: (_) => LanguageSelectionScreen(
                                  onComplete: () => Navigator.of(context).pop(),
                                ),
                              ),
                            );
                          },
                        ),
                        ProfileSettingsTile(
                          isDark: isDark,
                          svgIcon: 'assets/svg/notifaction.svg',
                          title: l10n.notificationsReminders,
                          subtitle: l10n.dailyReminderAt(
                            profile.formattedReminderTime(context),
                          ),
                          onTap: () {
                            AnalyticsService.instance.log(
                              AnalyticsEvents.notificationsSettingsClicked,
                              {
                                AnalyticsParams.sourceScreen: 'profile',
                                AnalyticsParams.destinationScreen:
                                    'notifications_reminders',
                              },
                            );
                            Navigator.of(context).push<void>(
                              MaterialPageRoute<void>(
                                builder: (_) =>
                                    const NotificationsRemindersScreen(),
                              ),
                            );
                          },
                        ),
                        ProfileSettingsTile(
                          isDark: isDark,
                          svgIcon: 'assets/svg/theme.svg',
                          title: l10n.appAppearance,
                          subtitle: themeViewModel.modeLabel(l10n),
                          onTap: () {
                            AnalyticsService.instance.log(
                              AnalyticsEvents.appAppearanceClicked,
                              {
                                AnalyticsParams.sourceScreen: 'profile',
                                AnalyticsParams.currentThemeMode:
                                    themeViewModel.mode.storageValue,
                              },
                            );
                            showAppAppearanceSheet(context);
                          },
                        ),
                        ProfileSettingsTile(
                          isDark: isDark,
                          svgIcon: 'assets/svg/restore_purchase.svg',
                          title: l10n.restorePurchases,
                          onTap: () async {
                            AnalyticsService.instance.log(
                              AnalyticsEvents.restorePurchaseClicked,
                              {AnalyticsParams.sourceScreen: 'profile'},
                            );
                            final result = await context
                                .read<SubscriptionViewModel>()
                                .restorePurchases();
                            AnalyticsService.instance.log(
                              result.success
                                  ? AnalyticsEvents.restorePurchaseSucceeded
                                  : AnalyticsEvents.restorePurchaseFailed,
                              {AnalyticsParams.sourceScreen: 'profile'},
                            );
                            if (!context.mounted) return;
                            SnackbarHelper.showSuccess(
                              context,
                              result.success
                                  ? (result.message ?? l10n.restorePurchases)
                                  : (result.message ?? l10n.openingSoon),
                            );
                          },
                        ),
                      ],
                    ),
                    // SizedBox(height: AppSizes.h(20)),
                    // ProfileSectionHeader(title: 'PRO FEATURES'),
                    // ProfileSettingsGroup(
                    //   children: [
                    //     ProfileSettingsTile(
                    //       svgIcon: 'assets/svg/learn.svg',
                    //       title: 'Weekly Progress Report',
                    //       subtitle: profile.canViewWeeklyReport
                    //           ? 'View your learning summary'
                    //           : 'Pro feature',
                    //       onTap: () {
                    //         if (profile.canViewWeeklyReport) {
                    //           Navigator.of(context).push<void>(
                    //             MaterialPageRoute<void>(
                    //               builder: (_) =>
                    //                   const WeeklyProgressReportScreen(),
                    //             ),
                    //           );
                    //           return;
                    //         }
                    //         showProFeatureSheet(
                    //           context,
                    //           title: 'Weekly Progress Report',
                    //           message:
                    //               'Upgrade to Pro for weekly learning reports.',
                    //         );
                    //       },
                    //     ),
                    //     ProfileSettingsTile(
                    //       svgIcon: 'assets/svg/restore_purchase.svg',
                    //       title: profile.isPro
                    //           ? 'Streak Repair'
                    //           : 'Streak Freezes',
                    //       subtitle: profile.isPro
                    //           ? (profile.canRepairStreak
                    //               ? 'Restore streak once this month'
                    //               : 'Already used this month')
                    //           : '${profile.streakFreezesRemaining} remaining this week',
                    //       onTap: () async {
                    //         if (profile.isPro) {
                    //           final repaired = await context
                    //               .read<HomeViewModel>()
                    //               .repairStreak();
                    //           if (!context.mounted) return;
                    //           SnackbarHelper.showSuccess(
                    //             context,
                    //             repaired
                    //                 ? 'Streak restored.'
                    //                 : 'No streak available to repair.',
                    //           );
                    //           context.read<ProfileViewModel>().refresh();
                    //           return;
                    //         }
                    //         SnackbarHelper.showSuccess(
                    //           context,
                    //           'Streak freezes apply automatically when you miss a day.',
                    //         );
                    //       },
                    //     ),
                    //     ProfileSettingsTile(
                    //       svgIcon: 'assets/svg/theme.svg',
                    //       title: 'Offline Mode',
                    //       subtitle: profile.canUseOfflineMode
                    //           ? 'Enabled for Pro'
                    //           : 'Pro feature',
                    //       onTap: () {
                    //         if (profile.canUseOfflineMode) {
                    //           SnackbarHelper.showSuccess(
                    //             context,
                    //             'Offline mode is active. Bundled lessons work without internet.',
                    //           );
                    //           return;
                    //         }
                    //         showProFeatureSheet(
                    //           context,
                    //           title: 'Offline Mode',
                    //           message:
                    //               'Upgrade to Pro to keep learning without internet.',
                    //         );
                    //       },
                    //     ),
                    //   ],
                    // ),
                    SizedBox(height: AppSizes.h(20)),
                    ProfileSectionHeader(
                      title: l10n.supportLegal,
                      isDark: isDark,
                    ),
                    ProfileSettingsGroup(
                      children: [
                        ProfileSettingsTile(
                          isDark: isDark,
                          title: l10n.privacyPolicy,
                          svgIcon: null,
                          onTap: () => LegalUrls.openPrivacyPolicy(context),
                        ),
                        ProfileSettingsTile(
                          isDark: isDark,
                          title: l10n.termsOfUse,
                          svgIcon: null,
                          onTap: () => LegalUrls.openTermsOfUse(context),
                        ),
                        ProfileSettingsTile(
                          isDark: isDark,
                          title: l10n.contactSupport,
                          svgIcon: null,
                          onTap: () => LegalUrls.openContactSupport(context),
                        ),
                        ProfileSettingsTile(
                          isDark: isDark,
                          title: l10n.tutorialTitle,
                          subtitle: l10n.tutorialSubtitle,
                          svgIcon: null,
                          onTap: () =>
                              showAppTutorial(context, source: 'profile'),
                        ),
                        if (ConsentService.instance.privacyOptionsRequired)
                          ProfileSettingsTile(
                            isDark: isDark,
                            title: l10n.privacyOptions,
                            subtitle: l10n.privacyOptionsSub,
                            svgIcon: null,
                            onTap: () async {
                              await ConsentService.instance
                                  .showPrivacyOptions();
                              if (mounted) setState(() {});
                            },
                          ),
                        ProfileSettingsTile(
                          isDark: isDark,
                          title: l10n.moreApps,
                          subtitle: l10n.moreAppsSub,
                          svgIcon: null,
                          onTap: () => Navigator.of(context).push<void>(
                            MaterialPageRoute<void>(
                              builder: (_) => const MoreAppsScreen(),
                            ),
                          ),
                        ),
                        ProfileSettingsTile(
                          isDark: isDark,
                          title: l10n.rateApp,
                          svgIcon: null,
                          onTap: () => RateAppService.instance.requestReview(),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.h(20)),
                    ProfileSectionHeader(
                      title: l10n.accountActions,
                      isDark: isDark,
                    ),
                    ProfileSettingsGroup(
                      children: [
                        ProfileSettingsTile(
                          svgIcon: 'assets/svg/signout.svg',
                          title: l10n.signOutTitle,
                          subtitle: l10n.signOutSub,
                          onTap: () => showSignOutDialog(context, isDark),
                          isDark: isDark,
                        ),
                        ProfileSettingsTile(
                          svgIcon: 'assets/svg/delete.svg',
                          title: l10n.deleteAccount,
                          subtitle: l10n.deleteAccountSub,
                          isDestructive: true,
                          onTap: () {
                            AnalyticsService.instance.log(
                              AnalyticsEvents.deleteAccountClicked,
                              {
                                AnalyticsParams.sourceScreen: 'profile',
                                AnalyticsParams.destinationScreen:
                                    'delete_account_confirmation',
                              },
                            );
                            showDeleteAccountDialog(context, isDark);
                          },
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openLearningPreferences(BuildContext context) async {
    final l10n = context.l10n;
    final authRepository = context.read<AuthRepository>();
    final userRepository = context.read<UserRepository>();

    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (routeContext) => ChangeNotifierProvider(
          create: (_) => SetupViewModel(
            LocalStorage.instance,
            userRepository,
            authRepository,
          ),
          child: SetupFlowScreen(
            isRetake: true,
            onComplete: () {
              Navigator.of(routeContext).pop();
              if (!context.mounted) return;
              context.read<ProfileViewModel>().refresh();
              context.read<LearnViewModel>().refreshCounts();
              context.read<VocabularyViewModel>().reload();
              context.read<GrammarViewModel>().reload();
              context.read<ReadingViewModel>().reload();
              SnackbarHelper.showSuccess(context, l10n.setupSaved);
            },
          ),
        ),
      ),
    );
  }
}

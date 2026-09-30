import 'package:fluentta_ai/core/tutorial/tutorial_targets.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/analytics/analytics_events.dart';
import 'package:fluentta_ai/core/analytics/analytics_params.dart';
import 'package:fluentta_ai/core/analytics/analytics_service.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/network/network_status.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/data/models/learning_lesson_model.dart';
import 'package:fluentta_ai/views/chat/open_chat_practice_screen.dart';
import 'package:fluentta_ai/data/services/in_app_update_service.dart';
import 'package:fluentta_ai/data/services/push_notification_service.dart';
import 'package:fluentta_ai/viewmodels/english_basics_view_model.dart';
import 'package:fluentta_ai/viewmodels/home_view_model.dart';
import 'package:fluentta_ai/viewmodels/profile_view_model.dart';
import 'package:fluentta_ai/widgets/home/daily_goal_card.dart';
import 'package:fluentta_ai/widgets/common/appbar_widget.dart';
import 'package:fluentta_ai/widgets/home/notification_permission_dialog.dart';
import 'package:fluentta_ai/widgets/home/practice_conversing_card.dart';
import 'package:fluentta_ai/widgets/home/todays_lesson_card.dart';
import 'package:fluentta_ai/views/tutorial/tutorial_screen.dart';
import 'package:provider/provider.dart';

class HomeTabScreen extends StatefulWidget {
  const HomeTabScreen({super.key});

  @override
  State<HomeTabScreen> createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen> {
  bool _loggedViewed = false;
  bool _promptedNotifications = false;
  bool _checkedUpdate = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_runStartupPrompts());
    });
  }

  /// One modal at a time: notification permission, then the first-run
  /// tutorial, then the in-app update prompt.
  Future<void> _runStartupPrompts() async {
    await _maybePromptNotifications();
    if (!mounted) return;
    await _maybeShowTutorial();
    if (!mounted) return;
    await _maybeCheckInAppUpdate();
  }

  Future<void> _maybeShowTutorial() async {
    if (!mounted) return;
    final storage = context.read<LocalStorage>();
    if (storage.hasSeenTutorial) return;
    await showAppTutorial(context, source: 'home_first_run');
  }

  Future<void> _maybePromptNotifications() async {
    if (_promptedNotifications || !mounted) return;
    final storage = context.read<LocalStorage>();
    if (storage.hasShownNotificationPrompt) {
      if (storage.notificationsEnabled) {
        unawaited(
          PushNotificationService.instance.requestPermissionAndSyncToken(),
        );
      }
      return;
    }
    _promptedNotifications = true;

    final allowed = await showNotificationPermissionDialog(context);
    if (!mounted) return;
    await storage.setNotificationPromptShown();
    if (!mounted) return;
    if (allowed == true) {
      await storage.setNotificationsEnabled(true);
      await PushNotificationService.instance.requestPermissionAndSyncToken();
      if (!mounted) return;
      await context.read<ProfileViewModel>().bootstrapNotificationsOnAppOpen();
    } else {
      await storage.setNotificationsEnabled(false);
    }
  }

  Future<void> _maybeCheckInAppUpdate() async {
    if (_checkedUpdate || !mounted) return;
    _checkedUpdate = true;
    if (!mounted) return;
    await InAppUpdateService.instance.checkAndPrompt(context);
  }

  /// Maps the "Today's Lesson" (English Basics flow) status to the
  /// catalogue's today_lesson_state values.
  String _todayLessonState(EnglishBasicsViewModel basicsViewModel) {
    final lesson = basicsViewModel.todaysLesson;
    if (lesson == null) return 'unavailable';
    return switch (lesson.status) {
      LearningLessonStatus.completed => 'completed',
      LearningLessonStatus.inProgress => 'in_progress',
      LearningLessonStatus.notStarted => 'not_started',
      LearningLessonStatus.locked => 'unavailable',
    };
  }

  void _logHomeViewedOnce(
    HomeViewModel home,
    EnglishBasicsViewModel basicsViewModel,
  ) {
    if (_loggedViewed) return;
    _loggedViewed = true;
    AnalyticsService.instance.logScreenView('home');

    final localStorage = context.read<LocalStorage>();
    final homeState = localStorage.hasVisitedHome ? 'returning' : 'first_time';
    if (!localStorage.hasVisitedHome) {
      unawaited(localStorage.setHasVisitedHome());
    }

    AnalyticsService.instance.log(AnalyticsEvents.homeViewed, {
      // Simplification: HomeTabScreen lives inside MainShellScreen's
      // IndexedStack, which keeps every tab mounted for the app's lifetime —
      // there's no reliable per-return signal (onboarding vs bottom-nav vs
      // foreground) without lifting navigation state up. Since this guard
      // only fires once per app session, 'app_open' is the closest accurate
      // default.
      AnalyticsParams.entrySource: 'app_open',
      AnalyticsParams.homeState: homeState,
      AnalyticsParams.todayLessonState: _todayLessonState(basicsViewModel),
      AnalyticsParams.subscriptionTierAtEvent: home.isPro ? 'premium' : 'free',
    });
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final homeViewModel = context.watch<HomeViewModel>();
    final basicsViewModel = context.watch<EnglishBasicsViewModel>();

    _logHomeViewedOnce(homeViewModel, basicsViewModel);

    return Scaffold(
      appBar: AppBarWidget(xpIconSourceScreen: 'home'),
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
      
            // SizedBox(height: AppSizes.spaceLg),
            Text(
              l10n.readyToPractice,
              style: TextStyle(
                fontFamily: AppFonts.plusJakartaSans,
                fontSize: AppSizes.sp(28),
                fontWeight: FontWeight.w700,
                color:isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSizes.h(4)),
            Text(
              l10n.journeyContinues,
              style: TextStyle(
                fontFamily: AppFonts.plusJakartaSans,
                fontSize: AppSizes.sp(16),
                fontWeight: FontWeight.w400,
                color:isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              ),
            ),
            SizedBox(height: AppSizes.spaceLg),
             DailyGoalCard(isDark: isDark),
            SizedBox(height: AppSizes.spaceMd),
            PracticeConversingCard(
              key: TutorialTargets.aiChatCard,
              isDark: isDark,
              onStartChat: () async {
                AnalyticsService.instance.log(AnalyticsEvents.aiChatClicked, {
                  AnalyticsParams.sourceScreen: 'home',
                  AnalyticsParams.destinationScreen: 'ai_chat',
                  AnalyticsParams.entryPoint: 'practice_conversing_card',
                });
                final online = await NetworkStatus.isOnline();
                if (!context.mounted) return;
                if (!online) {
                  SnackbarHelper.showError(context, context.l10n.chatNeedsInternet);
                  return;
                }
                await Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) => const OpenChatPracticeScreen(),
                  ),
                );
              },
            ),
            const HomeBannerAd(),
            SizedBox(height: AppSizes.spaceMd),
            TodaysLessonCard(
              key: TutorialTargets.todaysLesson,
              isDark: isDark,
              onStartLesson: () async {
                final lesson = basicsViewModel.todaysLesson;
                AnalyticsService.instance.log(
                  AnalyticsEvents.todayLessonClicked,
                  {
                    AnalyticsParams.lessonId: lesson?.lessonId ?? 'unknown',
                    AnalyticsParams.lessonState: _todayLessonState(basicsViewModel),
                    AnalyticsParams.entryAction:
                        lesson?.status == LearningLessonStatus.inProgress
                            ? 'resume'
                            : 'start',
                    AnalyticsParams.sourceScreen: 'home',
                    // No registry screen id exists yet for the English Basics
                    // flow (it isn't a CEFR/RolePlay lesson) — using a
                    // descriptive placeholder id until one is added.
                    AnalyticsParams.destinationScreen: 'english_basics_intro',
                  },
                );
                await context.read<EnglishBasicsViewModel>().openLessonFlow(
                      context,
                    );
                if (context.mounted) {
                  context.read<HomeViewModel>().refresh();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

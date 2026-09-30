import 'package:flutter/widgets.dart';

/// Keys attached to real widgets so the tutorial can spotlight them.
/// Each key must be used by exactly one widget in the tree.
class TutorialTargets {
  TutorialTargets._();

  static final GlobalKey todaysLesson = GlobalKey(debugLabel: 'tut_lesson');
  static final GlobalKey aiChatCard = GlobalKey(debugLabel: 'tut_ai_chat');
  static final GlobalKey learnModules = GlobalKey(debugLabel: 'tut_modules');
  static final GlobalKey levelBar = GlobalKey(debugLabel: 'tut_levels');
  /// Drives the horizontal scenario list so the tutorial can pan through
  /// every card while explaining Role Play.
  static final ScrollController scenarioScroll = ScrollController();
  static final GlobalKey scenarios = GlobalKey(debugLabel: 'tut_scenarios');
  static final GlobalKey pronunciationCard =
      GlobalKey(debugLabel: 'tut_pronunciation');
  static final GlobalKey heartsBadge = GlobalKey(debugLabel: 'tut_hearts');
  static final GlobalKey navProfile = GlobalKey(debugLabel: 'tut_nav_profile');
}

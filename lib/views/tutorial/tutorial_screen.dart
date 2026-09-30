import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluentta_ai/core/analytics/analytics_events.dart';
import 'package:fluentta_ai/core/analytics/analytics_params.dart';
import 'package:fluentta_ai/core/analytics/analytics_service.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/haptics/haptic_service.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/core/tutorial/tutorial_targets.dart';
import 'package:fluentta_ai/l10n/app_localizations.dart';
import 'package:fluentta_ai/viewmodels/main_shell_view_model.dart';
import 'package:provider/provider.dart';

/// One coach mark: which tab to show, which real widget to spotlight, and
/// the copy that explains it.
class _TutorialStep {
  const _TutorialStep({
    required this.id,
    required this.tab,
    required this.target,
    required this.icon,
    required this.accent,
    required this.title,
    required this.body,
  });

  final String id;
  final MainTab tab;
  final GlobalKey target;
  final IconData icon;
  final Color accent;
  final String title;
  final String body;
}

List<_TutorialStep> _buildSteps(AppLocalizations l10n) {
  return [
    _TutorialStep(
      id: 'practice_english',
      tab: MainTab.home,
      target: TutorialTargets.todaysLesson,
      icon: Icons.school_rounded,
      accent: const Color(0xFF2F6BFF),
      title: l10n.tutorialPracticeTitle,
      body: l10n.tutorialPracticeBody,
    ),
    _TutorialStep(
      id: 'ai_tutor',
      tab: MainTab.home,
      target: TutorialTargets.aiChatCard,
      icon: Icons.chat_bubble_rounded,
      accent: const Color(0xFF7A4DF0),
      title: l10n.tutorialAiChatTitle,
      body: l10n.tutorialAiChatBody,
    ),
    _TutorialStep(
      id: 'learn_modules',
      tab: MainTab.learn,
      target: TutorialTargets.learnModules,
      icon: Icons.menu_book_rounded,
      accent: const Color(0xFF12A37F),
      title: l10n.tutorialLearnTitle,
      body: l10n.tutorialLearnBody,
    ),
    _TutorialStep(
      id: 'levels',
      tab: MainTab.learn,
      target: TutorialTargets.levelBar,
      icon: Icons.lock_open_rounded,
      accent: const Color(0xFFE59A12),
      title: l10n.tutorialLevelsTitle,
      body: l10n.tutorialLevelsBody,
    ),
    _TutorialStep(
      id: 'roleplay',
      tab: MainTab.speak,
      target: TutorialTargets.scenarios,
      icon: Icons.theater_comedy_rounded,
      accent: const Color(0xFF0E9FB8),
      title: l10n.tutorialScenariosTitle,
      body: l10n.tutorialScenariosBody,
    ),
    _TutorialStep(
      id: 'pronunciation',
      tab: MainTab.speak,
      target: TutorialTargets.pronunciationCard,
      icon: Icons.mic_rounded,
      accent: const Color(0xFFF08A1C),
      title: l10n.tutorialPronunciationTitle,
      body: l10n.tutorialPronunciationBody,
    ),
    _TutorialStep(
      id: 'hearts',
      tab: MainTab.speak,
      target: TutorialTargets.heartsBadge,
      icon: Icons.favorite_rounded,
      accent: const Color(0xFFE5394F),
      title: l10n.tutorialHeartsTitle,
      body: l10n.tutorialHeartsBody,
    ),
    _TutorialStep(
      id: 'profile',
      tab: MainTab.profile,
      target: TutorialTargets.navProfile,
      icon: Icons.person_rounded,
      accent: const Color(0xFF8C31EF),
      title: l10n.tutorialProfileTitle,
      body: l10n.tutorialProfileBody,
    ),
  ];
}

/// Runs the coach-mark tutorial over the real app screens. It switches tabs
/// itself, dims everything and cuts a spotlight around one widget at a time.
/// The overlay swallows all touches and the back button, so only the close
/// (X) and Next buttons respond.
///
/// Must be called from inside the main shell (Home / Profile).
Future<void> showAppTutorial(
  BuildContext context, {
  required String source,
}) async {
  final storage = context.read<LocalStorage>();
  final shell = context.read<MainShellViewModel>();
  final originalTab = shell.currentTab;

  await Navigator.of(context, rootNavigator: true).push<void>(
    PageRouteBuilder<void>(
      opaque: false,
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (_, _, _) => TutorialScreen(shell: shell, source: source),
      transitionsBuilder: (_, animation, _, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    ),
  );

  shell.selectTab(originalTab);
  await storage.setTutorialSeen();
}

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key, required this.shell, required this.source});

  final MainShellViewModel shell;
  final String source;

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen>
    with SingleTickerProviderStateMixin {
  int _index = 0;
  int _navToken = 0;
  Rect? _rect;
  Duration _elapsed = Duration.zero;
  late final Ticker _ticker;
  List<_TutorialStep>? _steps;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
    AnalyticsService.instance.log(AnalyticsEvents.tutorialStarted, {
      AnalyticsParams.sourceScreen: widget.source,
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _goTo(0));
  }

  @override
  void dispose() {
    _resetScenarios();
    _ticker.dispose();
    super.dispose();
  }

  /// Follows the target every frame so the spotlight glides between steps and
  /// stays on the widget if the layout shifts (e.g. an ad loads above it).
  void _onTick(Duration elapsed) {
    final steps = _steps;
    if (steps == null || !mounted) return;
    final target = _measure(steps[_index].target);
    final current = _rect;
    Rect? next;
    if (target == null) {
      next = null;
    } else if (current == null) {
      next = target;
    } else {
      // Frame-rate independent easing (~90ms time constant).
      final dt = (elapsed - _elapsed).inMicroseconds / 1e6;
      final t = 1 - math.exp(-dt / 0.09);
      next = Rect.lerp(current, target, t.clamp(0.0, 1.0));
    }
    setState(() {
      _elapsed = elapsed;
      _rect = next;
    });
  }

  Rect? _measure(GlobalKey key) {
    final object = key.currentContext?.findRenderObject();
    if (object is! RenderBox || !object.attached || !object.hasSize) {
      return null;
    }
    final size = MediaQuery.sizeOf(context);
    final origin = object.localToGlobal(Offset.zero);
    final padded = (origin & object.size).inflate(AppSizes.w(6));
    return padded.intersect(Offset.zero & size);
  }

  Future<void> _goTo(int index) async {
    final steps = _steps;
    if (steps == null || !mounted) return;
    final token = ++_navToken;
    final step = steps[index];

    setState(() => _index = index);
    widget.shell.selectTab(step.tab);
    AnalyticsService.instance.log(AnalyticsEvents.tutorialStepViewed, {
      AnalyticsParams.tutorialStep: index + 1,
      AnalyticsParams.tutorialStepName: step.id,
    });

    // The freshly selected tab needs a frame or two before the target exists.
    for (var attempt = 0; attempt < 10; attempt++) {
      await WidgetsBinding.instance.endOfFrame;
      if (!mounted || token != _navToken) return;
      if (_measure(step.target) != null) break;
    }

    final targetContext = step.target.currentContext;
    if (targetContext != null && targetContext.mounted) {
      await Scrollable.ensureVisible(
        targetContext,
        // Put the target at the top of the screen so the card fits below it
        // and never covers what is being explained.
        alignment: 0.02,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
    if (!mounted || token != _navToken) return;
    if (step.id == 'roleplay') {
      unawaited(_panScenarios(token));
    } else {
      _resetScenarios();
    }
  }

  /// The scenario list scrolls sideways, so slowly pan through every card
  /// (and back) while this step is on screen.
  Future<void> _panScenarios(int token) async {
    final controller = TutorialTargets.scenarioScroll;
    while (mounted && token == _navToken) {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      if (!mounted || token != _navToken || !controller.hasClients) return;
      final end = controller.position.maxScrollExtent;
      if (end <= 0) return;
      await controller.animateTo(
        end,
        duration: Duration(milliseconds: 900 + (end * 6).round()),
        curve: Curves.easeInOut,
      );
      if (!mounted || token != _navToken || !controller.hasClients) return;
      await Future<void>.delayed(const Duration(milliseconds: 600));
      if (!mounted || token != _navToken || !controller.hasClients) return;
      await controller.animateTo(
        0,
        duration: Duration(milliseconds: 700 + (end * 3).round()),
        curve: Curves.easeInOut,
      );
    }
  }

  void _resetScenarios() {
    final controller = TutorialTargets.scenarioScroll;
    if (controller.hasClients && controller.offset != 0) {
      controller.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _next() {
    final steps = _steps!;
    if (_index >= steps.length - 1) {
      AnalyticsService.instance.log(AnalyticsEvents.tutorialCompleted, {
        AnalyticsParams.sourceScreen: widget.source,
      });
      Navigator.of(context).pop();
      return;
    }
    _goTo(_index + 1);
  }

  void _close() {
    final steps = _steps!;
    AnalyticsService.instance.log(AnalyticsEvents.tutorialSkipped, {
      AnalyticsParams.sourceScreen: widget.source,
      AnalyticsParams.tutorialStep: _index + 1,
      AnalyticsParams.tutorialStepName: steps[_index].id,
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final steps = _steps = _buildSteps(l10n);
    final step = steps[_index];
    final isLast = _index == steps.length - 1;
    final media = MediaQuery.of(context);
    final rect = _rect;

    final card = _TutorialCard(
      key: ValueKey<String>(step.id),
      step: step,
      isDark: isDark,
      index: _index,
      count: steps.length,
      countLabel: l10n.tutorialStepCount(_index + 1, steps.length),
      buttonLabel: isLast ? l10n.tutorialDone : l10n.tutorialNext,
      isLast: isLast,
      onNext: _next,
    );

    Widget animatedCard = AnimatedSwitcher(
      duration: const Duration(milliseconds: 280),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.06),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      ),
      child: card,
    );

    return PopScope(
      canPop: false,
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Full-screen touch blocker + dimmed spotlight.
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {},
              onPanStart: (_) {},
              child: CustomPaint(
                painter: _SpotlightPainter(
                  rect: rect,
                  radius: AppSizes.w(18),
                  accent: step.accent,
                  pulse: (math.sin(_elapsed.inMilliseconds / 380) + 1) / 2,
                ),
                size: Size.infinite,
              ),
            ),
            Positioned.fill(
              child: CustomSingleChildLayout(
                delegate: _CardLayoutDelegate(
                  rect: rect,
                  gap: AppSizes.h(14),
                  margin: AppSizes.w(16),
                  topInset: media.padding.top + AppSizes.h(56),
                  bottomInset: media.padding.bottom + AppSizes.h(16),
                ),
                child: animatedCard,
              ),
            ),
            if (rect != null)
              Positioned(
                left: (rect.left - AppSizes.w(6))
                    .clamp(0.0, media.size.width - AppSizes.w(28)),
                top: (rect.top - AppSizes.w(10))
                    .clamp(0.0, media.size.height - AppSizes.w(28)),
                child: IgnorePointer(
                  child: Container(
                    width: AppSizes.w(26),
                    height: AppSizes.w(26),
                    decoration: BoxDecoration(
                      color: step.accent,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Icon(
                      Icons.info_outline_rounded,
                      color: Colors.white,
                      size: AppSizes.w(16),
                    ),
                  ),
                ),
              ),
            Positioned(
              top: media.padding.top + AppSizes.h(8),
              right: AppSizes.w(12),
              child: Semantics(
                button: true,
                label: l10n.tutorialClose,
                child: Material(
                  color: Colors.black.withValues(alpha: 0.45),
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: HapticService.wrap(_close),
                    child: Padding(
                      padding: EdgeInsets.all(AppSizes.w(8)),
                      child: Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: AppSizes.w(24),
                      ),
                    ),
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

/// Places the card just below the spotlight, or above it when there is no
/// room, or pinned to the bottom edge when the target is very tall. Uses the
/// card's real measured height so long translations never run off screen.
class _CardLayoutDelegate extends SingleChildLayoutDelegate {
  _CardLayoutDelegate({
    required this.rect,
    required this.gap,
    required this.margin,
    required this.topInset,
    required this.bottomInset,
  });

  final Rect? rect;
  final double gap;
  final double margin;
  final double topInset;
  final double bottomInset;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    final width = constraints.maxWidth - margin * 2;
    return BoxConstraints(
      minWidth: width,
      maxWidth: width,
      maxHeight: constraints.maxHeight - topInset - bottomInset,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final maxBottom = size.height - bottomInset;
    final pinned = maxBottom - childSize.height;
    final hole = rect;
    var y = pinned;
    if (hole != null) {
      final below = hole.bottom + gap;
      final above = hole.top - gap - childSize.height;
      if (below + childSize.height <= maxBottom) {
        y = below;
      } else if (above >= topInset) {
        y = above;
      }
    }
    return Offset(margin, y);
  }

  @override
  bool shouldRelayout(_CardLayoutDelegate old) =>
      old.rect != rect ||
      old.gap != gap ||
      old.margin != margin ||
      old.topInset != topInset ||
      old.bottomInset != bottomInset;
}

class _SpotlightPainter extends CustomPainter {
  _SpotlightPainter({
    required this.rect,
    required this.radius,
    required this.accent,
    required this.pulse,
  });

  final Rect? rect;
  final double radius;
  final Color accent;
  final double pulse;

  @override
  void paint(Canvas canvas, Size size) {
    final full = Offset.zero & size;
    final dim = Paint()..color = Colors.black.withValues(alpha: 0.78);
    final hole = rect;
    if (hole == null || hole.isEmpty) {
      canvas.drawRect(full, dim);
      return;
    }
    final rrect = RRect.fromRectAndRadius(hole, Radius.circular(radius));
    final path = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(full)
      ..addRRect(rrect);
    canvas.drawPath(path, dim);

    // A faint tint "under glass" so the highlighted widget reads as a preview,
    // not a live control.
    canvas.drawRRect(
      rrect,
      Paint()..color = accent.withValues(alpha: 0.12),
    );

    // Dashed ring: clearly an annotation, not a button outline.
    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..color = accent;
    final ringPath = Path()..addRRect(rrect);
    for (final metric in ringPath.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(metric.extractPath(distance, distance + 9), ring);
        distance += 15;
      }
    }
    canvas.drawRRect(
      rrect.inflate(3 + pulse * 6),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = accent.withValues(alpha: 0.4 * (1 - pulse)),
    );
  }

  @override
  bool shouldRepaint(_SpotlightPainter old) =>
      old.rect != rect || old.pulse != pulse || old.accent != accent;
}

class _TutorialCard extends StatelessWidget {
  const _TutorialCard({
    super.key,
    required this.step,
    required this.isDark,
    required this.index,
    required this.count,
    required this.countLabel,
    required this.buttonLabel,
    required this.isLast,
    required this.onNext,
  });

  final _TutorialStep step;
  final bool isDark;
  final int index;
  final int count;
  final String countLabel;
  final String buttonLabel;
  final bool isLast;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final surface = isDark ? const Color(0xFF241D33) : Colors.white;
    final titleColor = isDark ? Colors.white : const Color(0xFF1E1633);
    final bodyColor =
        isDark ? const Color(0xFFD9D2EA) : const Color(0xFF4B4260);
    final buttonRadius = BorderRadius.circular(AppSizes.w(12));

    return Container(
      padding: EdgeInsets.all(AppSizes.w(18)),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(AppSizes.w(22)),
        border: Border.all(color: step.accent.withValues(alpha: 0.6), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: AppSizes.w(38),
                height: AppSizes.w(38),
                decoration: BoxDecoration(
                  color: step.accent,
                  shape: BoxShape.circle,
                ),
                child: Icon(step.icon, color: Colors.white, size: AppSizes.w(20)),
              ),
              SizedBox(width: AppSizes.w(12)),
              Expanded(
                child: Text(
                  step.title,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(18),
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                    color: titleColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.h(10)),
          Text(
            step.body,
            style: TextStyle(
              fontFamily: AppFonts.plusJakartaSans,
              fontSize: AppSizes.sp(14),
              height: 1.45,
              color: bodyColor,
            ),
          ),
          SizedBox(height: AppSizes.h(14)),
          Row(
            children: [
              Text(
                countLabel,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(12),
                  fontWeight: FontWeight.w600,
                  color: bodyColor,
                ),
              ),
              SizedBox(width: AppSizes.w(10)),
              Expanded(
                child: Wrap(
                  spacing: AppSizes.w(4),
                  runSpacing: AppSizes.w(4),
                  children: [
                    for (var i = 0; i < count; i++)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: i == index ? AppSizes.w(18) : AppSizes.w(6),
                        height: AppSizes.w(6),
                        decoration: BoxDecoration(
                          color: i <= index
                              ? step.accent
                              : bodyColor.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.h(14)),
          // The one real button on this screen: full width, solid, with an
          // arrow so it can't be mistaken for the highlighted app widgets.
          SizedBox(
            width: double.infinity,
            child: Material(
              color: step.accent,
              borderRadius: buttonRadius,
              elevation: 3,
              shadowColor: step.accent.withValues(alpha: 0.5),
              child: InkWell(
                borderRadius: buttonRadius,
                onTap: HapticService.wrap(onNext),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSizes.h(14)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        buttonLabel,
                        style: TextStyle(
                          fontFamily: AppFonts.plusJakartaSans,
                          fontSize: AppSizes.sp(16),
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: AppSizes.w(8)),
                      Icon(
                        isLast
                            ? Icons.check_rounded
                            : Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: AppSizes.w(20),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

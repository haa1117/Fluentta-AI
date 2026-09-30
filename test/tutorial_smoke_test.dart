import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluentta_ai/core/tutorial/tutorial_targets.dart';
import 'package:fluentta_ai/l10n/app_localizations.dart';
import 'package:fluentta_ai/viewmodels/main_shell_view_model.dart';
import 'package:fluentta_ai/views/tutorial/tutorial_screen.dart';

/// A fake "app" with every spotlight target on one scrolling page.
class _FakeApp extends StatelessWidget {
  const _FakeApp({required this.locale, required this.shell});

  final String locale;
  final MainShellViewModel shell;

  @override
  Widget build(BuildContext context) {
    Widget box(GlobalKey key, double h, Color c) =>
        Container(key: key, height: h, margin: const EdgeInsets.all(12), color: c);
    return MaterialApp(
      locale: Locale(locale),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Stack(
        children: [
          Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  box(TutorialTargets.todaysLesson, 140, Colors.blue),
                  box(TutorialTargets.aiChatCard, 160, Colors.purple),
                  box(TutorialTargets.learnModules, 700, Colors.teal),
                  box(TutorialTargets.levelBar, 60, Colors.amber),
                  box(TutorialTargets.scenarios, 180, Colors.cyan),
                  box(TutorialTargets.pronunciationCard, 200, Colors.orange),
                  box(TutorialTargets.heartsBadge, 32, Colors.red),
                ],
              ),
            ),
            bottomNavigationBar: SizedBox(
              height: 60,
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                    key: TutorialTargets.navProfile,
                    width: 60,
                    height: 50,
                    color: Colors.deepPurple),
              ),
            ),
          ),
          Positioned.fill(child: TutorialScreen(shell: shell, source: 'test')),
        ],
      ),
    );
  }
}

void main() {
  for (final code in ['en', 'es', 'fr', 'ur']) {
    for (final size in [const Size(360, 640), const Size(412, 915)]) {
      testWidgets('tutorial walks all 8 steps ($code ${size.width})',
          (tester) async {
        tester.view.physicalSize = size * 2;
        tester.view.devicePixelRatio = 2;
        addTearDown(tester.view.reset);
        final shell = MainShellViewModel();
        await tester.pumpWidget(_FakeApp(locale: code, shell: shell));
        for (var i = 0; i < 8; i++) {
          await tester.pump(const Duration(milliseconds: 800));
          await tester.pump(const Duration(milliseconds: 800));
          expect(tester.takeException(), isNull);
          if (find.byType(InkWell).evaluate().isEmpty) { fail('no InkWell at step $i'); }
          await tester.tap(find.byType(InkWell).first);
          await tester.pump();
        }
      });
    }
  }
}

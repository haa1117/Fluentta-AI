import 'package:flutter/material.dart';
import 'package:fluentta_ai/data/services/pronunciation_assessment_service.dart';
import 'package:fluentta_ai/data/services/text_to_speech_service.dart';
import 'package:fluentta_ai/viewmodels/home_view_model.dart';
import 'package:fluentta_ai/viewmodels/pronunciation_view_model.dart';
import 'package:fluentta_ai/views/pronunciation/pronunciation_checking_screen.dart';
import 'package:fluentta_ai/views/pronunciation/pronunciation_complete_screen.dart';
import 'package:fluentta_ai/views/pronunciation/pronunciation_recording_screen.dart';
import 'package:fluentta_ai/views/pronunciation/pronunciation_result_screen.dart';
import 'package:fluentta_ai/views/pronunciation/pronunciation_screen.dart';
import 'package:provider/provider.dart';

/// Hosts the full pronunciation flow with a shared [PronunciationViewModel]
/// so every step in the nested navigator can access the same provider.
class PronunciationFlow extends StatelessWidget {
  const PronunciationFlow({super.key});

  static const String routeHome = '/';
  static const String routeRecording = '/recording';
  static const String routeChecking = '/checking';
  static const String routeResult = '/result';
  static const String routeComplete = '/complete';

  static void popFlow(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  static void popOrExitFlow(BuildContext context) {
    final nestedNav = Navigator.of(context);
    if (nestedNav.canPop()) {
      nestedNav.pop();
    } else {
      popFlow(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => PronunciationViewModel(
        ctx.read<HomeViewModel>(),
        ctx.read<TextToSpeechService>(),
        ctx.read<PronunciationAssessmentService>(),
      ),
      child: Navigator(
        initialRoute: routeHome,
        onGenerateRoute: (settings) {
          final page = switch (settings.name) {
            routeRecording => const PronunciationRecordingScreen(),
            routeChecking => const PronunciationCheckingScreen(),
            routeResult => const PronunciationResultScreen(),
            routeComplete => const PronunciationCompleteScreen(),
            _ => const PronunciationScreen(),
          };
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => page,
          );
        },
      ),
    );
  }
}

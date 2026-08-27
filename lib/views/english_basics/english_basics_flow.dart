import 'package:flutter/material.dart';
import 'package:fluentta_ai/data/models/english_basics_lesson_model.dart';
import 'package:fluentta_ai/data/repositories/english_basics_repository.dart';
import 'package:fluentta_ai/data/services/learning_stats_service.dart';
import 'package:fluentta_ai/data/services/progress_sync_service.dart';
import 'package:fluentta_ai/data/services/text_to_speech_service.dart';
import 'package:fluentta_ai/viewmodels/english_basics_flow_view_model.dart';
import 'package:fluentta_ai/views/english_basics/english_basics_complete_screen.dart';
import 'package:fluentta_ai/views/english_basics/english_basics_dialogue_screen.dart';
import 'package:fluentta_ai/views/english_basics/english_basics_intro_screen.dart';
import 'package:fluentta_ai/views/english_basics/english_basics_sentences_screen.dart';
import 'package:fluentta_ai/views/english_basics/english_basics_words_screen.dart';
import 'package:provider/provider.dart';

class EnglishBasicsFlow {
  EnglishBasicsFlow._();

  static Future<void> open({
    required BuildContext context,
    required String goalId,
    required EnglishBasicsLessonModel lesson,
    required EnglishBasicsRepository repository,
    required Future<void> Function() onFinished,
  }) async {
    final allLessons = await repository.buildLessons(goalId);
    final freshLesson = allLessons.firstWhere(
      (l) => l.lessonId == lesson.lessonId,
      orElse: () => lesson,
    );

    if (!context.mounted) return;

    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => ChangeNotifierProvider(
          create: (ctx) => EnglishBasicsFlowViewModel(
            goalId: goalId,
            lesson: freshLesson,
            repository: repository,
            allLessons: allLessons,
            textToSpeechService: ctx.read<TextToSpeechService>(),
            onFinished: () {},
            onStatsUpdated: () async {
              await ctx.read<LearningStatsService>().reconcileFromProgress();
              await ctx.read<ProgressSyncService>().syncStatsToFirestore();
            },
          ),
          child: const _EnglishBasicsFlowHost(),
        ),
      ),
    );

    await onFinished();
  }
}

class _EnglishBasicsFlowHost extends StatelessWidget {
  const _EnglishBasicsFlowHost();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<EnglishBasicsFlowViewModel>();

    return switch (viewModel.step) {
      EnglishBasicsStep.intro => const EnglishBasicsIntroScreen(),
      EnglishBasicsStep.words => const EnglishBasicsWordsScreen(),
      EnglishBasicsStep.sentences => const EnglishBasicsSentencesScreen(),
      EnglishBasicsStep.dialogue => const EnglishBasicsDialogueScreen(),
      EnglishBasicsStep.complete => const EnglishBasicsCompleteScreen(),
    };
  }
}

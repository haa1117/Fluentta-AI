import 'package:fluentta_ai/data/models/learning_lesson_model.dart';

enum EnglishBasicsStep {
  intro,
  words,
  sentences,
  dialogue,
  complete;

  int get stepIndex => switch (this) {
        EnglishBasicsStep.intro => 0,
        EnglishBasicsStep.words => 1,
        EnglishBasicsStep.sentences => 2,
        EnglishBasicsStep.dialogue => 3,
        EnglishBasicsStep.complete => 4,
      };

  static EnglishBasicsStep fromIndex(int value) {
    return EnglishBasicsStep.values[value.clamp(0, 4)];
  }
}

class EnglishBasicsIntroItem {
  const EnglishBasicsIntroItem({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  factory EnglishBasicsIntroItem.fromJson(Map<String, dynamic> json) {
    return EnglishBasicsIntroItem(
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
    );
  }
}

class EnglishBasicsWordModel {
  const EnglishBasicsWordModel({
    required this.word,
    required this.tag,
    required this.definition,
    required this.example,
  });

  final String word;
  final String tag;
  final String definition;
  final String example;

  factory EnglishBasicsWordModel.fromJson(Map<String, dynamic> json) {
    return EnglishBasicsWordModel(
      word: json['word'] as String,
      tag: json['tag'] as String,
      definition: json['definition'] as String,
      example: json['example'] as String,
    );
  }
}

class EnglishBasicsSentenceQuestion {
  const EnglishBasicsSentenceQuestion({
    required this.prompt,
    required this.options,
    required this.correctIndex,
  });

  final String prompt;
  final List<String> options;
  final int correctIndex;

  factory EnglishBasicsSentenceQuestion.fromJson(Map<String, dynamic> json) {
    return EnglishBasicsSentenceQuestion(
      prompt: json['prompt'] as String,
      options: (json['options'] as List<dynamic>).cast<String>(),
      correctIndex: json['correctIndex'] as int,
    );
  }
}

class EnglishBasicsDialogueLine {
  const EnglishBasicsDialogueLine({
    required this.speaker,
    required this.text,
    required this.isUser,
  });

  final String speaker;
  final String text;
  final bool isUser;

  factory EnglishBasicsDialogueLine.fromJson(Map<String, dynamic> json) {
    return EnglishBasicsDialogueLine(
      speaker: json['speaker'] as String,
      text: json['text'] as String,
      isUser: json['isUser'] as bool? ?? json['speaker'] == 'You',
    );
  }
}

class EnglishBasicsStepContent {
  const EnglishBasicsStepContent({
    required this.stepLabel,
    required this.title,
    required this.subtitle,
  });

  final String stepLabel;
  final String title;
  final String subtitle;
}

class EnglishBasicsLessonModel implements LearningLessonItem {
  const EnglishBasicsLessonModel({
    required this.lessonId,
    required this.number,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.introItems,
    required this.wordsStepLabel,
    required this.wordsTitle,
    required this.wordsSubtitle,
    required this.words,
    required this.sentencesStepLabel,
    required this.sentencesTitle,
    required this.sentencesSubtitle,
    required this.questions,
    required this.dialogueStepLabel,
    required this.dialogueTitle,
    required this.dialogueSubtitle,
    required this.dialogue,
    required this.completeItems,
    this.currentStep = EnglishBasicsStep.intro,
  });

  final String lessonId;
  final int number;
  final String title;
  final String subtitle;
  @override
  final LearningLessonStatus status;
  final List<EnglishBasicsIntroItem> introItems;
  final String wordsStepLabel;
  final String wordsTitle;
  final String wordsSubtitle;
  final List<EnglishBasicsWordModel> words;
  final String sentencesStepLabel;
  final String sentencesTitle;
  final String sentencesSubtitle;
  final List<EnglishBasicsSentenceQuestion> questions;
  final String dialogueStepLabel;
  final String dialogueTitle;
  final String dialogueSubtitle;
  final List<EnglishBasicsDialogueLine> dialogue;
  final List<EnglishBasicsIntroItem> completeItems;
  final EnglishBasicsStep currentStep;

  @override
  String get iconName => 'chat';

  @override
  String get displayTitle => title;

  @override
  String get progressLabel {
    return switch (status) {
      LearningLessonStatus.completed => 'Completed',
      LearningLessonStatus.inProgress => 'In progress',
      LearningLessonStatus.notStarted => 'Not started',
      LearningLessonStatus.locked => 'Locked',
    };
  }

  @override
  double get progressValue {
    if (status == LearningLessonStatus.completed) return 1;
    return currentStep.stepIndex / 4;
  }

  double get flowProgress => currentStep.stepIndex / 4;

  EnglishBasicsLessonModel copyWith({
    LearningLessonStatus? status,
    EnglishBasicsStep? currentStep,
  }) {
    return EnglishBasicsLessonModel(
      lessonId: lessonId,
      number: number,
      title: title,
      subtitle: subtitle,
      status: status ?? this.status,
      introItems: introItems,
      wordsStepLabel: wordsStepLabel,
      wordsTitle: wordsTitle,
      wordsSubtitle: wordsSubtitle,
      words: words,
      sentencesStepLabel: sentencesStepLabel,
      sentencesTitle: sentencesTitle,
      sentencesSubtitle: sentencesSubtitle,
      questions: questions,
      dialogueStepLabel: dialogueStepLabel,
      dialogueTitle: dialogueTitle,
      dialogueSubtitle: dialogueSubtitle,
      dialogue: dialogue,
      completeItems: completeItems,
      currentStep: currentStep ?? this.currentStep,
    );
  }

  factory EnglishBasicsLessonModel.fromJson({
    required Map<String, dynamic> json,
    required LearningLessonStatus status,
    EnglishBasicsStep currentStep = EnglishBasicsStep.intro,
  }) {
    final wordsStep = json['wordsStep'] as Map<String, dynamic>;
    final sentencesStep = json['sentencesStep'] as Map<String, dynamic>;
    final dialogueStep = json['dialogueStep'] as Map<String, dynamic>;

    return EnglishBasicsLessonModel(
      lessonId: json['id'] as String,
      number: json['number'] as int,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      status: status,
      introItems: (json['introItems'] as List<dynamic>)
          .map((e) => EnglishBasicsIntroItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      wordsStepLabel: wordsStep['stepLabel'] as String,
      wordsTitle: wordsStep['title'] as String,
      wordsSubtitle: wordsStep['subtitle'] as String,
      words: (wordsStep['words'] as List<dynamic>)
          .map((e) => EnglishBasicsWordModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      sentencesStepLabel: sentencesStep['stepLabel'] as String,
      sentencesTitle: sentencesStep['title'] as String,
      sentencesSubtitle: sentencesStep['subtitle'] as String,
      questions: (sentencesStep['questions'] as List<dynamic>)
          .map(
            (e) => EnglishBasicsSentenceQuestion.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
      dialogueStepLabel: dialogueStep['stepLabel'] as String,
      dialogueTitle: dialogueStep['title'] as String,
      dialogueSubtitle: dialogueStep['subtitle'] as String,
      dialogue: (dialogueStep['lines'] as List<dynamic>)
          .map(
            (e) => EnglishBasicsDialogueLine.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      completeItems: (json['completeItems'] as List<dynamic>)
          .map((e) => EnglishBasicsIntroItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentStep: currentStep,
    );
  }
}

class EnglishBasicsTrackModel {
  const EnglishBasicsTrackModel({
    required this.goalId,
    required this.pathTitle,
    required this.lessons,
  });

  final String goalId;
  final String pathTitle;
  final List<EnglishBasicsLessonModel> lessons;
}

import 'package:fluentta_ai/core/cefr/cefr_level.dart';
import 'package:fluentta_ai/core/cefr/lesson_type.dart';
import 'package:fluentta_ai/data/models/grammar_lesson_model.dart';
import 'package:fluentta_ai/data/models/learning_lesson_model.dart';
import 'package:fluentta_ai/data/models/reading_lesson_model.dart';
import 'package:fluentta_ai/data/models/vocabulary_lesson_model.dart';

class LessonManifestEntryDto {
  const LessonManifestEntryDto({
    required this.id,
    required this.cefrLevel,
    required this.type,
    required this.number,
    required this.title,
    required this.assetPath,
    required this.iconName,
  });

  final String id;
  final String cefrLevel;
  final String type;
  final int number;
  final String title;
  final String assetPath;
  final String iconName;

  factory LessonManifestEntryDto.fromJson(Map<String, dynamic> json) {
    return LessonManifestEntryDto(
      id: json['id'] as String,
      cefrLevel: json['cefrLevel'] as String,
      type: json['type'] as String,
      number: json['number'] as int,
      title: json['title'] as String,
      assetPath: json['assetPath'] as String,
      iconName: json['iconName'] as String? ?? 'grammar',
    );
  }
}

class VocabularyWordDto {
  const VocabularyWordDto({
    required this.word,
    required this.phonetic,
    required this.definition,
    required this.example,
    this.partOfSpeech,
  });

  final String word;
  final String phonetic;
  final String definition;
  final String example;
  final String? partOfSpeech;

  factory VocabularyWordDto.fromJson(Map<String, dynamic> json) {
    return VocabularyWordDto(
      word: json['word'] as String,
      phonetic: json['phonetic'] as String,
      definition: json['definition'] as String,
      example: json['example'] as String,
      partOfSpeech: json['partOfSpeech'] as String?,
    );
  }

  VocabularyWordModel toModel() {
    return VocabularyWordModel(
      word: word,
      phonetic: phonetic,
      meaning: definition,
      example: example,
      partOfSpeech: partOfSpeech,
    );
  }
}

class VocabularyLessonContentDto {
  const VocabularyLessonContentDto({
    required this.id,
    required this.cefrLevel,
    required this.number,
    required this.title,
    required this.iconName,
    required this.words,
  });

  final String id;
  final String cefrLevel;
  final int number;
  final String title;
  final String iconName;
  final List<VocabularyWordDto> words;

  factory VocabularyLessonContentDto.fromJson(Map<String, dynamic> json) {
    return VocabularyLessonContentDto(
      id: json['id'] as String,
      cefrLevel: json['cefrLevel'] as String,
      number: json['number'] as int,
      title: json['title'] as String,
      iconName: json['iconName'] as String? ?? 'chat',
      words: (json['words'] as List<dynamic>)
          .map((e) => VocabularyWordDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  VocabularyLessonModel toLessonModel({
    LearningLessonStatus status = LearningLessonStatus.locked,
    int wordsCompleted = 0,
  }) {
    return VocabularyLessonModel(
      lessonId: id,
      id: number,
      number: number,
      title: title,
      status: status,
      wordsCompleted: wordsCompleted,
      totalWords: words.length,
      iconName: status == LearningLessonStatus.completed ? 'check' : iconName,
      words: words.map((w) => w.toModel()).toList(),
    );
  }
}

class GrammarExampleDto {
  const GrammarExampleDto({
    required this.text,
    this.highlight,
  });

  final String text;
  final String? highlight;

  factory GrammarExampleDto.fromJson(Map<String, dynamic> json) {
    return GrammarExampleDto(
      text: json['text'] as String,
      highlight: json['highlight'] as String?,
    );
  }

  GrammarExampleModel toModel() {
    if (highlight != null && text.contains(highlight!)) {
      final parts = text.split(highlight!);
      return GrammarExampleModel(
        prefix: parts.first,
        highlight: highlight!,
        suffix: parts.length > 1 ? parts.sublist(1).join(highlight!) : '',
      );
    }
    return GrammarExampleModel(
      prefix: text,
      highlight: '',
      suffix: '',
    );
  }
}

class GrammarStepDto {
  const GrammarStepDto({
    required this.title,
    required this.description,
    required this.formula,
    required this.examples,
    required this.quickTip,
  });

  final String title;
  final String description;
  final String formula;
  final List<GrammarExampleDto> examples;
  final String quickTip;

  factory GrammarStepDto.fromJson(Map<String, dynamic> json) {
    return GrammarStepDto(
      title: json['title'] as String,
      description: json['description'] as String,
      formula: json['formula'] as String,
      examples: (json['examples'] as List<dynamic>)
          .map((e) => GrammarExampleDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      quickTip: json['quickTip'] as String,
    );
  }

  GrammarStepModel toModel() {
    return GrammarStepModel(
      title: title,
      description: description,
      formula: formula,
      examples: examples.map((e) => e.toModel()).toList(),
      quickTip: quickTip,
    );
  }
}

class GrammarLessonContentDto {
  const GrammarLessonContentDto({
    required this.id,
    required this.cefrLevel,
    required this.number,
    required this.title,
    required this.iconName,
    required this.steps,
    this.completionTitle,
    this.completionSummary,
  });

  final String id;
  final String cefrLevel;
  final int number;
  final String title;
  final String iconName;
  final List<GrammarStepDto> steps;
  final String? completionTitle;
  final String? completionSummary;

  factory GrammarLessonContentDto.fromJson(Map<String, dynamic> json) {
    final rawSteps = json['steps'] as List<dynamic>?;
    final steps = rawSteps != null && rawSteps.isNotEmpty
        ? rawSteps
            .map((e) => GrammarStepDto.fromJson(e as Map<String, dynamic>))
            .toList()
        : _stepsFromLegacyFields(json);

    return GrammarLessonContentDto(
      id: json['id'] as String,
      cefrLevel: json['cefrLevel'] as String,
      number: json['number'] as int,
      title: json['title'] as String,
      iconName: json['iconName'] as String? ?? 'grammar',
      steps: steps,
      completionTitle: json['completionTitle'] as String?,
      completionSummary: json['completionSummary'] as String?,
    );
  }

  static List<GrammarStepDto> _stepsFromLegacyFields(Map<String, dynamic> json) {
    final rule = json['rule'] as String? ?? '';
    final pattern = json['pattern'] as String? ?? '';
    final examples = (json['examples'] as List<dynamic>? ?? [])
        .map((e) => GrammarExampleDto.fromJson(e as Map<String, dynamic>))
        .toList();
    final practicePrompt = json['practicePrompt'] as String? ?? '';
    final practiceAnswer = json['practiceAnswer'] as String? ?? '';

    return [
      GrammarStepDto(
        title: rule,
        description: pattern,
        formula: pattern,
        examples: examples,
        quickTip: practicePrompt.isNotEmpty
            ? '$practicePrompt ($practiceAnswer)'
            : '',
      ),
    ];
  }

  GrammarLessonModel toLessonModel({
    LearningLessonStatus status = LearningLessonStatus.locked,
    int stepsCompleted = 0,
  }) {
    return GrammarLessonModel(
      lessonId: id,
      id: number,
      number: number,
      title: title,
      status: status,
      stepsCompleted: stepsCompleted,
      totalSteps: steps.length,
      iconName: status == LearningLessonStatus.completed ? 'check' : iconName,
      steps: steps.map((s) => s.toModel()).toList(),
      completionTitle: completionTitle ?? title,
      completionSummary: completionSummary ?? 'Great job!',
    );
  }
}

class ReadingPassageLineDto {
  const ReadingPassageLineDto({
    required this.speaker,
    required this.text,
    this.isUser = false,
  });

  final String speaker;
  final String text;
  final bool isUser;

  factory ReadingPassageLineDto.fromJson(Map<String, dynamic> json) {
    return ReadingPassageLineDto(
      speaker: json['speaker'] as String? ?? '',
      text: json['text'] as String,
      isUser: json['isUser'] as bool? ?? false,
    );
  }

  ReadingDialogueLineModel toModel() {
    return ReadingDialogueLineModel(
      speakerLabel: speaker,
      text: text,
      isUser: isUser,
    );
  }
}

class ReadingQuestionDto {
  const ReadingQuestionDto({
    required this.prompt,
    required this.options,
    required this.correctIndex,
  });

  final String prompt;
  final List<String> options;
  final int correctIndex;

  factory ReadingQuestionDto.fromJson(Map<String, dynamic> json) {
    return ReadingQuestionDto(
      prompt: json['prompt'] as String,
      options: (json['options'] as List<dynamic>).cast<String>(),
      correctIndex: json['correctIndex'] as int,
    );
  }

  ReadingQuestionModel toModel() {
    return ReadingQuestionModel(
      prompt: prompt,
      options: options,
      correctIndex: correctIndex,
    );
  }
}

class ReadingLessonContentDto {
  const ReadingLessonContentDto({
    required this.id,
    required this.cefrLevel,
    required this.number,
    required this.title,
    required this.iconName,
    required this.contentType,
    required this.passage,
    required this.questions,
    this.tip,
    this.dialoguePartCount = 5,
    this.completionTitle,
    this.completionSummary,
  });

  final String id;
  final String cefrLevel;
  final int number;
  final String title;
  final String iconName;
  final String contentType;
  final List<ReadingPassageLineDto> passage;
  final List<ReadingQuestionDto> questions;
  final String? tip;
  final int dialoguePartCount;
  final String? completionTitle;
  final String? completionSummary;

  factory ReadingLessonContentDto.fromJson(Map<String, dynamic> json) {
    return ReadingLessonContentDto(
      id: json['id'] as String,
      cefrLevel: json['cefrLevel'] as String,
      number: json['number'] as int,
      title: json['title'] as String,
      iconName: json['iconName'] as String? ?? 'chat',
      contentType: json['contentType'] as String? ?? 'text',
      passage: (json['passage'] as List<dynamic>)
          .map((e) => ReadingPassageLineDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      questions: (json['questions'] as List<dynamic>)
          .map((e) => ReadingQuestionDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      tip: json['tip'] as String?,
      dialoguePartCount: json['dialoguePartCount'] as int? ?? 5,
      completionTitle: json['completionTitle'] as String?,
      completionSummary: json['completionSummary'] as String?,
    );
  }

  String get _defaultTip {
    if (contentType == 'dialogue') {
      return "Try speaking the 'You' response out loud to practice your pronunciation!";
    }
    return 'Read the passage carefully before answering the questions.';
  }

  List<ReadingDialogueLineModel> _passageUnits() {
    if (contentType == 'dialogue') {
      return passage.map((line) => line.toModel()).toList();
    }
    return _textToDialogueUnits(passage);
  }

  static List<ReadingDialogueLineModel> _textToDialogueUnits(
    List<ReadingPassageLineDto> passage,
  ) {
    if (passage.isEmpty) return const [];

    final combined = passage.map((line) => line.text.trim()).join(' ');
    final units = _splitTextIntoUnits(combined);
    if (units.isEmpty) {
      return [ReadingDialogueLineModel(speakerLabel: '', text: combined, isUser: false)];
    }

    final dialogue = <ReadingDialogueLineModel>[
      const ReadingDialogueLineModel(
        speakerLabel: 'Friend',
        text: 'Can you tell me about it?',
        isUser: false,
      ),
    ];

    for (var index = 0; index < units.length; index++) {
      dialogue.add(
        ReadingDialogueLineModel(
          speakerLabel: 'You',
          text: units[index],
          isUser: true,
        ),
      );
      if (index < units.length - 1) {
        dialogue.add(
          const ReadingDialogueLineModel(
            speakerLabel: 'Friend',
            text: 'Go on.',
            isUser: false,
          ),
        );
      }
    }

    return dialogue;
  }

  static List<String> _splitTextIntoUnits(String text) {
    final sentences = text
        .split(RegExp(r'(?<=[.!?])\s+'))
        .map((sentence) => sentence.trim())
        .where((sentence) => sentence.isNotEmpty)
        .toList();

    if (sentences.length >= 2) return sentences;

    return text
        .split(RegExp(r',\s*'))
        .map((chunk) => chunk.trim())
        .where((chunk) => chunk.isNotEmpty)
        .toList();
  }

  static int _visibleUnitCount({
    required int part,
    required int totalUnits,
    required int partCount,
  }) {
    if (totalUnits == 0) return 0;
    if (part >= partCount) return totalUnits;

    final count = ((part * totalUnits) / partCount).ceil();
    return count.clamp(1, totalUnits);
  }

  List<ReadingDialogueLineModel> _linesForPart(
    List<ReadingDialogueLineModel> units,
    int part,
    int partCount,
  ) {
    if (units.isEmpty) return const [];

    final visibleCount = _visibleUnitCount(
      part: part,
      totalUnits: units.length,
      partCount: partCount,
    );
    return units.sublist(0, visibleCount);
  }

  List<ReadingPhaseModel> buildPhases() {
    final units = _passageUnits();
    final partCount = dialoguePartCount.clamp(1, 5);
    final readingTip = tip ?? _defaultTip;

    return [
      for (var part = 1; part <= partCount; part++)
        ReadingPhaseModel(
          phaseTitle: 'Dialogue Part $part',
          dialoguePartNumber: part,
          lines: _linesForPart(units, part, partCount),
          tip: readingTip,
          isTextPassage: false,
        ),
    ];
  }

  ReadingLessonModel toLessonModel({
    LearningLessonStatus status = LearningLessonStatus.locked,
    int phasesCompleted = 0,
  }) {
    final phases = buildPhases();
    return ReadingLessonModel(
      lessonId: id,
      id: number,
      number: number,
      title: title,
      status: status,
      phasesCompleted: phasesCompleted,
      totalPhases: phases.length,
      iconName: status == LearningLessonStatus.completed ? 'check' : iconName,
      phases: phases,
      questions: questions.map((q) => q.toModel()).toList(),
      completionTitle: completionTitle ?? '$title Learned',
      completionSummary: completionSummary ?? _completionSummary(),
    );
  }

  String _completionSummary() {
    if (contentType == 'dialogue') {
      return 'General ${title.toLowerCase()} conversation';
    }
    return title;
  }
}

String lessonIdFor({
  required CefrLevel level,
  required LessonType type,
  required int number,
}) {
  final num = number.toString().padLeft(2, '0');
  final typeCode = switch (type) {
    LessonType.vocabulary => 'vocab',
    LessonType.grammar => 'grammar',
    LessonType.reading => 'reading',
  };
  return '${level.name}_${typeCode}_$num';
}

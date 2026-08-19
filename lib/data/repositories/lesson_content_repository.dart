import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:fluentta_ai/core/cefr/cefr_level.dart';
import 'package:fluentta_ai/core/cefr/lesson_type.dart';
import 'package:fluentta_ai/data/models/grammar_lesson_model.dart';
import 'package:fluentta_ai/data/models/learning_lesson_model.dart';
import 'package:fluentta_ai/data/models/lesson_content_dto.dart';
import 'package:fluentta_ai/data/models/lesson_progress_model.dart';
import 'package:fluentta_ai/data/models/reading_lesson_model.dart';
import 'package:fluentta_ai/data/models/vocabulary_lesson_model.dart';
import 'package:fluentta_ai/core/cefr/lesson_unlock_logic.dart';

class LessonContentRepository {
  LessonContentRepository();

  List<LessonManifestEntryDto>? _manifest;
  final Map<String, dynamic> _contentCache = {};

  Future<void> initialize() async {
    if (_manifest != null) return;
    final raw = await rootBundle.loadString('assets/lessons/manifest.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    _manifest = (json['lessons'] as List<dynamic>)
        .map((e) => LessonManifestEntryDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<LessonManifestEntryDto>> getManifestEntries({
    CefrLevel? level,
    LessonType? type,
  }) async {
    await initialize();
    var entries = _manifest!;
    if (level != null) {
      entries = entries.where((e) => e.cefrLevel == level.code).toList();
    }
    if (type != null) {
      entries = entries.where((e) => e.type == type.id).toList();
    }
    entries.sort((a, b) => a.number.compareTo(b.number));
    return entries;
  }

  Future<Map<String, dynamic>> _loadJson(String assetPath) async {
    if (_contentCache.containsKey(assetPath)) {
      return _contentCache[assetPath] as Map<String, dynamic>;
    }
    final raw = await rootBundle.loadString(assetPath);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    _contentCache[assetPath] = json;
    return json;
  }

  Future<List<VocabularyLessonModel>> getVocabularyLessons(
    CefrLevel level, {
    Map<String, LessonProgressModel> progress = const {},
  }) async {
    final entries = await getManifestEntries(level: level, type: LessonType.vocabulary);
    final lessons = <VocabularyLessonModel>[];

    for (final entry in entries) {
      final json = await _loadJson(entry.assetPath);
      final dto = VocabularyLessonContentDto.fromJson(json);
      final hasContent = dto.words.isNotEmpty;
      final status = LessonUnlockLogic.statusForLesson(
        lessonNumber: entry.number,
        progressByLessonId: progress,
        lessonId: entry.id,
        hasContent: hasContent,
      );
      final saved = progress[entry.id];
      final wordsCompleted = saved?.status == LearningLessonStatus.completed
          ? dto.words.length
          : saved?.currentIndex ?? 0;

      lessons.add(
        dto.toLessonModel(
          status: status,
          wordsCompleted: wordsCompleted.clamp(0, dto.words.length),
        ),
      );
    }

    _applySequentialUnlock(lessons, progress, LessonType.vocabulary);
    return lessons;
  }

  Future<List<GrammarLessonModel>> getGrammarLessons(
    CefrLevel level, {
    Map<String, LessonProgressModel> progress = const {},
  }) async {
    final entries = await getManifestEntries(level: level, type: LessonType.grammar);
    final lessons = <GrammarLessonModel>[];

    for (final entry in entries) {
      final json = await _loadJson(entry.assetPath);
      final dto = GrammarLessonContentDto.fromJson(json);
      final hasContent = dto.steps.isNotEmpty;
      final status = LessonUnlockLogic.statusForLesson(
        lessonNumber: entry.number,
        progressByLessonId: progress,
        lessonId: entry.id,
        hasContent: hasContent,
      );
      final saved = progress[entry.id];
      final stepsCompleted = saved?.status == LearningLessonStatus.completed
          ? dto.steps.length
          : saved?.currentIndex ?? 0;

      lessons.add(
        dto.toLessonModel(
          status: status,
          stepsCompleted: stepsCompleted.clamp(0, dto.steps.length),
        ),
      );
    }

    _applySequentialUnlockGrammar(lessons, progress);
    return lessons;
  }

  Future<List<ReadingLessonModel>> getReadingLessons(
    CefrLevel level, {
    Map<String, LessonProgressModel> progress = const {},
  }) async {
    final entries = await getManifestEntries(level: level, type: LessonType.reading);
    final lessons = <ReadingLessonModel>[];

    for (final entry in entries) {
      final json = await _loadJson(entry.assetPath);
      final dto = ReadingLessonContentDto.fromJson(json);
      final phases = dto.buildPhases();
      final hasContent = phases.isNotEmpty;
      final status = LessonUnlockLogic.statusForLesson(
        lessonNumber: entry.number,
        progressByLessonId: progress,
        lessonId: entry.id,
        hasContent: hasContent,
      );
      final saved = progress[entry.id];
      final phasesCompleted = saved?.status == LearningLessonStatus.completed
          ? phases.length
          : saved?.currentIndex ?? 0;

      lessons.add(
        dto.toLessonModel(
          status: status,
          phasesCompleted: phasesCompleted.clamp(0, phases.length),
        ),
      );
    }

    _applySequentialUnlockReading(lessons, progress);
    return lessons;
  }

  void _applySequentialUnlock(
    List<VocabularyLessonModel> lessons,
    Map<String, LessonProgressModel> progress,
    LessonType type,
  ) {
    for (var i = 0; i < lessons.length; i++) {
      final lesson = lessons[i];
      if (progress.containsKey(lesson.lessonId)) continue;
      if (i == 0 && lesson.words.isNotEmpty) {
        lessons[i] = VocabularyLessonModel(
          lessonId: lesson.lessonId,
          id: lesson.id,
          number: lesson.number,
          title: lesson.title,
          status: LearningLessonStatus.notStarted,
          wordsCompleted: lesson.wordsCompleted,
          totalWords: lesson.totalWords,
          iconName: lesson.iconName,
          words: lesson.words,
        );
      } else if (i > 0 &&
          lessons[i - 1].status == LearningLessonStatus.completed &&
          lesson.words.isNotEmpty) {
        lessons[i] = VocabularyLessonModel(
          lessonId: lesson.lessonId,
          id: lesson.id,
          number: lesson.number,
          title: lesson.title,
          status: LearningLessonStatus.notStarted,
          wordsCompleted: 0,
          totalWords: lesson.totalWords,
          iconName: lesson.iconName == 'lock' ? 'chat' : lesson.iconName,
          words: lesson.words,
        );
      }
    }
  }

  void _applySequentialUnlockGrammar(
    List<GrammarLessonModel> lessons,
    Map<String, LessonProgressModel> progress,
  ) {
    for (var i = 0; i < lessons.length; i++) {
      final lesson = lessons[i];
      if (progress.containsKey(lesson.lessonId)) continue;
      if (i == 0 && lesson.steps.isNotEmpty) {
        lessons[i] = GrammarLessonModel(
          lessonId: lesson.lessonId,
          id: lesson.id,
          number: lesson.number,
          title: lesson.title,
          status: LearningLessonStatus.notStarted,
          stepsCompleted: lesson.stepsCompleted,
          totalSteps: lesson.totalSteps,
          iconName: lesson.iconName,
          steps: lesson.steps,
          completionTitle: lesson.completionTitle,
          completionSummary: lesson.completionSummary,
        );
      } else if (i > 0 &&
          lessons[i - 1].status == LearningLessonStatus.completed &&
          lesson.steps.isNotEmpty) {
        lessons[i] = GrammarLessonModel(
          lessonId: lesson.lessonId,
          id: lesson.id,
          number: lesson.number,
          title: lesson.title,
          status: LearningLessonStatus.notStarted,
          stepsCompleted: 0,
          totalSteps: lesson.totalSteps,
          iconName: lesson.iconName == 'lock' ? 'grammar' : lesson.iconName,
          steps: lesson.steps,
          completionTitle: lesson.completionTitle,
          completionSummary: lesson.completionSummary,
        );
      }
    }
  }

  void _applySequentialUnlockReading(
    List<ReadingLessonModel> lessons,
    Map<String, LessonProgressModel> progress,
  ) {
    for (var i = 0; i < lessons.length; i++) {
      final lesson = lessons[i];
      if (progress.containsKey(lesson.lessonId)) continue;
      if (i == 0 && lesson.phases.isNotEmpty) {
        lessons[i] = ReadingLessonModel(
          lessonId: lesson.lessonId,
          id: lesson.id,
          number: lesson.number,
          title: lesson.title,
          status: LearningLessonStatus.notStarted,
          phasesCompleted: lesson.phasesCompleted,
          totalPhases: lesson.totalPhases,
          iconName: lesson.iconName,
          phases: lesson.phases,
          questions: lesson.questions,
          completionTitle: lesson.completionTitle,
          completionSummary: lesson.completionSummary,
        );
      } else if (i > 0 &&
          lessons[i - 1].status == LearningLessonStatus.completed &&
          lesson.phases.isNotEmpty) {
        lessons[i] = ReadingLessonModel(
          lessonId: lesson.lessonId,
          id: lesson.id,
          number: lesson.number,
          title: lesson.title,
          status: LearningLessonStatus.notStarted,
          phasesCompleted: 0,
          totalPhases: lesson.totalPhases,
          iconName: lesson.iconName == 'lock' ? 'chat' : lesson.iconName,
          phases: lesson.phases,
          questions: lesson.questions,
          completionTitle: lesson.completionTitle,
          completionSummary: lesson.completionSummary,
        );
      }
    }
  }

  Future<List<String>> orderedLessonIds(CefrLevel level, LessonType type) async {
    final entries = await getManifestEntries(level: level, type: type);
    return entries.map((e) => e.id).toList();
  }
}

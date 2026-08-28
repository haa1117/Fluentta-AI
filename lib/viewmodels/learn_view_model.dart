import 'package:fluentta_ai/core/cefr/cefr_level.dart';
import 'package:fluentta_ai/core/cefr/cefr_level_progress.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/entitlements/user_entitlements.dart';
import 'package:fluentta_ai/core/xp/lesson_xp_rewards.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/data/models/learn_category_model.dart';
import 'package:fluentta_ai/data/models/learning_lesson_model.dart';
import 'package:fluentta_ai/data/repositories/lesson_content_repository.dart';
import 'package:fluentta_ai/data/repositories/progress_repository.dart';
import 'package:fluentta_ai/data/repositories/saved_words_repository.dart';
import 'package:fluentta_ai/data/repositories/spaced_repetition_repository.dart';
import 'package:fluentta_ai/viewmodels/grammar_view_model.dart';
import 'package:fluentta_ai/viewmodels/reading_view_model.dart';
import 'package:fluentta_ai/viewmodels/vocabulary_view_model.dart';
import 'package:fluentta_ai/views/grammar/grammar_screen.dart';
import 'package:fluentta_ai/views/reading/reading_screen.dart';
import 'package:fluentta_ai/views/saved_words/saved_words_screen.dart';
import 'package:fluentta_ai/views/vocabulary/vocabulary_screen.dart';
import 'package:provider/provider.dart';

class LearnViewModel extends ChangeNotifier {
  LearnViewModel(
    this._localStorage,
    this._localeViewModel,
    this._savedWordsRepository,
    this._srsRepository,
    this._contentRepository,
    this._progressRepository,
  ) {
    _localeViewModel.addListener(notifyListeners);
    _savedWordsRepository.addListener(_onDataChanged);
    _srsRepository.addListener(_onDataChanged);
    _bootstrap();
  }

  final LocalStorage _localStorage;
  final LocaleViewModel _localeViewModel;
  final SavedWordsRepository _savedWordsRepository;
  final SpacedRepetitionRepository _srsRepository;
  final LessonContentRepository _contentRepository;
  final ProgressRepository _progressRepository;

  int _dueReviewCount = 0;
  CefrLevel _selectedLevel = CefrLevel.a1;
  double _levelProgress = 0;

  int get dueReviewCount => _dueReviewCount;
  CefrLevel get selectedLevel => _selectedLevel;
  int get totalXp => _localStorage.xpEarned;
  int get savedWordsCount => _savedWordsRepository.count;

  List<LearnCategoryModel> get categories {
    final l10n = _localeViewModel.strings;
    return [
      LearnCategoryModel(
        id: 'vocabulary',
        title: l10n.vocabulary,
        subtitle: _dueReviewCount > 0
            ? l10n.vocabularySubDynamic(_dueReviewCount)
            : l10n.vocabularySub,
        svgIcon: AppAssets.vocabulary,
        xpPerLesson: LessonXpRewards.vocabularyLesson,
      ),
      LearnCategoryModel(
        id: 'grammar',
        title: l10n.grammar,
        subtitle: l10n.grammarSub,
        svgIcon: AppAssets.grammar,
        xpPerLesson: LessonXpRewards.grammarLesson,
      ),
      LearnCategoryModel(
        id: 'reading',
        title: l10n.reading,
        subtitle: l10n.readingSub,
        svgIcon: AppAssets.reading,
        xpPerLesson: LessonXpRewards.readingLesson,
      ),
      LearnCategoryModel(
        id: 'saved_words',
        title: l10n.savedWords,
        subtitle: _savedWordsRepository.count > 0
            ? l10n.savedWordsSubDynamic(_savedWordsRepository.count)
            : l10n.savedWordsSub,
        svgIcon: AppAssets.savedWords,
      ),
    ];
  }

  double get levelProgress => _levelProgress;

  int get levelProgressPercent => (levelProgress * 100).round();

  String get levelCode =>
      CefrLevelProgress.levelCodeLabel(_localeViewModel.strings, _selectedLevel);

  String get levelName =>
      CefrLevelProgress.levelNameLabel(_localeViewModel.strings, _selectedLevel);

  Future<void> _bootstrap() async {
    _selectedLevel = UserEntitlements.learnBrowseLevel(_localStorage);
    await _localStorage.setLearnBrowseCefrLevelCode(_selectedLevel.code);
    await refreshCounts();
    await _refreshLevelProgress();
  }

  Future<void> selectLevel(CefrLevel level) async {
    if (_selectedLevel == level) return;
    _selectedLevel = level;
    await _localStorage.setLearnBrowseCefrLevelCode(level.code);
    await _refreshLevelProgress();
    notifyListeners();
  }

  Future<void> _refreshLevelProgress() async {
    await _contentRepository.initialize();
    await _progressRepository.initialize();

    final entries = await _contentRepository.getManifestEntries(
      level: _selectedLevel,
    );
    if (entries.isEmpty) {
      _levelProgress = 0;
      return;
    }

    final progress = _progressRepository.allProgress;
    var completed = 0;
    for (final entry in entries) {
      if (progress[entry.id]?.status == LearningLessonStatus.completed) {
        completed++;
      }
    }
    _levelProgress = completed / entries.length;
  }

  Future<void> refreshCounts() async {
    await _savedWordsRepository.initialize();
    await _srsRepository.initialize();
    _dueReviewCount = await _srsRepository.dueCount();
    notifyListeners();
  }

  void _onDataChanged() {
    refreshCounts();
  }

  Future<void> openCategory(
    BuildContext context,
    LearnCategoryModel category,
  ) async {
    if (category.id == 'reading') {
      await context.read<ReadingViewModel>().reload();
      if (!context.mounted) return;
      Navigator.of(context).push<void>(
        MaterialPageRoute<void>(builder: (_) => const ReadingScreen()),
      );
      return;
    }
    if (category.id == 'grammar') {
      await context.read<GrammarViewModel>().reload();
      if (!context.mounted) return;
      Navigator.of(context).push<void>(
        MaterialPageRoute<void>(builder: (_) => const GrammarScreen()),
      );
      return;
    }
    if (category.id == 'vocabulary') {
      await context.read<VocabularyViewModel>().reload();
      if (!context.mounted) return;
      Navigator.of(context).push<void>(
        MaterialPageRoute<void>(builder: (_) => const VocabularyScreen()),
      );
      return;
    }
    if (category.id == 'saved_words') {
      Navigator.of(context).push<void>(
        MaterialPageRoute<void>(builder: (_) => const SavedWordsScreen()),
      );
      return;
    }
  }

  @override
  void dispose() {
    _localeViewModel.removeListener(notifyListeners);
    _savedWordsRepository.removeListener(_onDataChanged);
    _srsRepository.removeListener(_onDataChanged);
    super.dispose();
  }
}

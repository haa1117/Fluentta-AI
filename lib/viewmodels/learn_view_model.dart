import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/l10n/localized_content.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/data/models/learn_category_model.dart';
import 'package:fluentta_ai/data/repositories/saved_words_repository.dart';
import 'package:fluentta_ai/data/repositories/spaced_repetition_repository.dart';
import 'package:fluentta_ai/views/grammar/grammar_screen.dart';
import 'package:fluentta_ai/views/reading/reading_screen.dart';
import 'package:fluentta_ai/views/saved_words/saved_words_screen.dart';
import 'package:fluentta_ai/views/vocabulary/vocabulary_screen.dart';

class LearnViewModel extends ChangeNotifier {
  LearnViewModel(
    this._localStorage,
    this._localeViewModel,
    this._savedWordsRepository,
    this._srsRepository,
  ) {
    _localeViewModel.addListener(notifyListeners);
    _savedWordsRepository.addListener(_onDataChanged);
    _srsRepository.addListener(_onDataChanged);
    refreshCounts();
  }

  final LocalStorage _localStorage;
  final LocaleViewModel _localeViewModel;
  final SavedWordsRepository _savedWordsRepository;
  final SpacedRepetitionRepository _srsRepository;

  int _dueReviewCount = 0;

  int get dueReviewCount => _dueReviewCount;
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
      ),
      LearnCategoryModel(
        id: 'grammar',
        title: l10n.grammar,
        subtitle: l10n.grammarSub,
        svgIcon: AppAssets.grammar,
      ),
      LearnCategoryModel(
        id: 'reading',
        title: l10n.reading,
        subtitle: l10n.readingSub,
        svgIcon: AppAssets.reading,
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

  double get levelProgress => _localStorage.lessonProgress;

  int get levelProgressPercent => (levelProgress * 100).round();

  String get levelCode =>
      LocalizedContent.levelCode(_localeViewModel.strings, _localStorage.englishLevel);

  String get levelName {
    final l10n = _localeViewModel.strings;
    return switch (_localStorage.englishLevel) {
      'elementary' => l10n.levelElementary,
      'intermediate' => l10n.levelIntermediate,
      'advanced' => l10n.levelAdvanced,
      _ => l10n.levelBeginner,
    };
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

  void openCategory(BuildContext context, LearnCategoryModel category) {
    if (category.id == 'reading') {
      Navigator.of(context).push<void>(
        MaterialPageRoute<void>(builder: (_) => const ReadingScreen()),
      );
      return;
    }
    if (category.id == 'grammar') {
      Navigator.of(context).push<void>(
        MaterialPageRoute<void>(builder: (_) => const GrammarScreen()),
      );
      return;
    }
    if (category.id == 'vocabulary') {
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

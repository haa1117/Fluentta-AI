import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/data/models/learn_category_model.dart';
import 'package:fluentta_ai/views/grammar/grammar_screen.dart';
import 'package:fluentta_ai/views/vocabulary/vocabulary_screen.dart';

class LearnViewModel extends ChangeNotifier {
  LearnViewModel(this._localStorage);

  final LocalStorage _localStorage;

  static List<LearnCategoryModel> categories = [
    LearnCategoryModel(
      id: 'vocabulary',
      title: 'Vocabulary',
      subtitle: '5 words to review',
      svgIcon: AppAssets.vocabulary,
    ),
    LearnCategoryModel(
      id: 'grammar',
      title: 'Grammar',
      subtitle: 'Quick practice',
      svgIcon: AppAssets.grammar,
    ),
    LearnCategoryModel(
      id: 'reading',
      title: 'Reading',
      subtitle: 'Short passage',
      svgIcon: AppAssets.reading,
    ),
    LearnCategoryModel(
      id: 'saved_words',
      title: 'Saved Words',
      subtitle: '12 words to review',
      svgIcon: AppAssets.savedWords,
    ),
  ];

  double get levelProgress => _localStorage.lessonProgress;

  int get levelProgressPercent => (levelProgress * 100).round();

  String get levelCode {
    return switch (_localStorage.englishLevel) {
      'elementary' => 'A2',
      'intermediate' => 'B1',
      'advanced' => 'B2+',
      _ => 'A1',
    };
  }

  String get levelName {
    return switch (_localStorage.englishLevel) {
      'elementary' => 'Elementary',
      'intermediate' => 'Intermediate',
      'advanced' => 'Advanced',
      _ => 'Beginner',
    };
  }

  void openCategory(BuildContext context, LearnCategoryModel category) {
    if (category.id == 'grammar') {
      Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (_) => const GrammarScreen(),
        ),
      );
      return;
    }
    if (category.id == 'vocabulary') {
      Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (_) => const VocabularyScreen(),
        ),
      );
      return;
    }
    SnackbarHelper.showSuccess(context, 'Opening ${category.title}...');
  }
}

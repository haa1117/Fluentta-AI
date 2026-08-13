import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/data/models/subscription_models.dart';
import 'package:fluentta_ai/l10n/app_localizations.dart';
import 'package:fluentta_ai/viewmodels/home_view_model.dart';

class SubscriptionViewModel extends ChangeNotifier {
  SubscriptionViewModel(this._localStorage, this._homeViewModel);

  final LocalStorage _localStorage;
  final HomeViewModel _homeViewModel;

  SubscriptionSelection _selection = SubscriptionSelection.annual;

  SubscriptionSelection get selection => _selection;
  int get currentLives => _homeViewModel.lives;

  bool get isHeartsSelection => SubscriptionContent.isHeartsSelection(_selection);

  int get selectedHeartCount =>
      SubscriptionContent.heartsForSelection(_selection);

  void select(SubscriptionSelection value) {
    if (_selection == value) return;
    _selection = value;
    notifyListeners();
  }

  String goalLabel(AppLocalizations l10n) {
    return switch (_localStorage.englishGoal) {
      'travel' => l10n.goalTravel,
      'work' => l10n.goalWork,
      'exam' => l10n.goalExam,
      'everyday' => l10n.goalEveryday,
      _ => l10n.goalWork,
    };
  }

  String levelLabel(AppLocalizations l10n) {
    return switch (_localStorage.englishLevel) {
      'elementary' => l10n.levelElementary,
      'intermediate' => l10n.levelIntermediate,
      'advanced' => l10n.levelAdvanced,
      _ => l10n.levelBeginner,
    };
  }

  int get dailyMinutes => _localStorage.dailyGoalMinutes ?? 10;

  List<String> planFeatures(AppLocalizations l10n) {
    return [
      l10n.featureUnlimitedConversation,
      l10n.featureUnlimitedGrammar,
      l10n.featureAdvancedPronunciation,
      l10n.featurePersonalizedLessons,
      l10n.featureOfflineMode,
    ];
  }

  Future<int> purchaseSelectedHearts() async {
    final hearts = selectedHeartCount;
    if (hearts <= 0) return 0;
    await _homeViewModel.addHearts(hearts);
    notifyListeners();
    return hearts;
  }
}

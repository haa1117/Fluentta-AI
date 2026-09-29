import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/analytics/analytics_events.dart';
import 'package:fluentta_ai/core/analytics/analytics_params.dart';
import 'package:fluentta_ai/core/analytics/analytics_service.dart';
import 'package:fluentta_ai/core/analytics/analytics_user_properties.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/data/models/language_model.dart';
import 'package:fluentta_ai/data/repositories/auth_repository.dart';
import 'package:fluentta_ai/data/repositories/user_repository.dart';
import 'package:fluentta_ai/l10n/app_localizations.dart';

class LanguageViewModel extends ChangeNotifier {
  LanguageViewModel(
    this._localStorage,
    this._userRepository,
    this._authRepository,
    this._localeViewModel,
  ) {
    _selectedLanguageCode = _localStorage.selectedLanguage ?? 'en';
  }

  final LocalStorage _localStorage;
  final UserRepository _userRepository;
  final AuthRepository _authRepository;
  final LocaleViewModel _localeViewModel;

  String _selectedLanguageCode = 'en';
  String get selectedLanguageCode => _selectedLanguageCode;

  bool _isContinuing = false;
  bool get isContinuing => _isContinuing;

  List<LanguageModel> languages(AppLocalizations l10n) => [
        LanguageModel(
          code: 'en',
          name: l10n.languageEnglish,
          flagAsset: AppAssets.flagEnglish,
        ),
        LanguageModel(
          code: 'es',
          name: l10n.languageSpanish,
          flagAsset: AppAssets.flagSpanish,
        ),
        LanguageModel(
          code: 'fr',
          name: l10n.languageFrench,
          flagAsset: AppAssets.flagFrench,
        ),
        LanguageModel(
          code: 'ur',
          name: l10n.languageUrdu,
          flagAsset: AppAssets.flagUrdu,
        ),
      ];

  // No "recommended for you" feature exists in this screen — a flat list of
  // 4 languages is shown to everyone, so recommendation_state is always
  // 'unavailable' and selection_source is always 'other_languages'.
  void logViewed() {
    AnalyticsService.instance.log(AnalyticsEvents.languageSelectionViewed, {
      AnalyticsParams.recommendationState: 'unavailable',
      AnalyticsParams.recommendedLanguageCode: 'none',
      AnalyticsParams.availableLanguageCount: 4,
    });
  }

  void selectLanguage(String code) {
    _selectedLanguageCode = code;
    notifyListeners();
    AnalyticsService.instance.log(AnalyticsEvents.languageSelected, {
      AnalyticsParams.languageCode: code,
      AnalyticsParams.selectionSource: 'other_languages',
    });
  }

  Future<void> continueWithLanguage(VoidCallback onComplete) async {
    if (_isContinuing) return;

    final localeChanged =
        _localeViewModel.languageCode != _selectedLanguageCode;
    _isContinuing = true;
    notifyListeners();

    try {
      await _localeViewModel.setLocale(_selectedLanguageCode);
      await _syncToFirestoreIfLoggedIn();
      await AnalyticsUserProperties.sync(
        _localStorage,
        user: _authRepository.currentUser,
      );
      AnalyticsService.instance.log(
        AnalyticsEvents.languageSelectionCompleted,
        {
          AnalyticsParams.languageCode: _selectedLanguageCode,
          AnalyticsParams.selectionSource: 'other_languages',
          AnalyticsParams.recommendationMatch: false,
        },
      );
      if (localeChanged) {
        await WidgetsBinding.instance.endOfFrame;
        await Future<void>.delayed(const Duration(milliseconds: 1000));
      }
      onComplete();
      await Future<void>.delayed(const Duration(milliseconds: 400));
    } finally {
      _isContinuing = false;
      notifyListeners();
    }
  }

  Future<void> _syncToFirestoreIfLoggedIn() async {
    final uid = _authRepository.currentUser?.uid;
    if (uid == null) return;
    await _userRepository.updateLanguage(
      uid: uid,
      languageCode: _selectedLanguageCode,
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentta_ai/core/analytics/analytics_service.dart';
import 'package:fluentta_ai/core/cefr/cefr_level.dart';
import 'package:fluentta_ai/core/iap/iap_product_ids.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';

/// Sets GA4 user id and the catalogue user properties that this app
/// actually persists. Permission properties are omitted: the app does not
/// read OS notification or microphone status into a stored value.
class AnalyticsUserProperties {
  AnalyticsUserProperties._();

  static Future<void> sync(
    LocalStorage storage, {
    User? user,
    String? currentCefrLevel,
  }) async {
    final analytics = AnalyticsService.instance;
    await analytics.setUserId(user?.uid);

    await analytics.setUserProperty(
      'account_status',
      user == null ? 'anonymous' : 'registered',
    );

    final method = _authMethod(user);
    if (method != null) {
      await analytics.setUserProperty('auth_method', method);
    }

    final onboarding = !storage.isOnboardingComplete
        ? 'not_started'
        : storage.hasCompletedSetup
            ? 'completed'
            : 'in_progress';
    await analytics.setUserProperty('onboarding_status', onboarding);

    final language = storage.selectedLanguage;
    if (language != null && language.isNotEmpty) {
      await analytics.setUserProperty('app_language', language);
    }

    final goal = _learningGoal(storage.englishGoal);
    if (goal != null) {
      await analytics.setUserProperty('learning_goal', goal);
    }

    final level = _startingLevel(storage.englishLevel);
    if (level != null) {
      await analytics.setUserProperty('starting_level', level);
    }
    final cefr = currentCefrLevel?.toLowerCase() ??
        (storage.englishLevel == null
            ? null
            : CefrLevel.fromSetupId(storage.englishLevel).name);
    if (cefr != null) {
      await analytics.setUserProperty('current_cefr_level', cefr);
      await analytics.setUserProperty('highest_unlocked_cefr_level', cefr);
    }

    final minutes = storage.dailyGoalMinutes;
    if (minutes != null) {
      await analytics.setUserProperty('daily_goal_minutes', '$minutes');
    }

    final premium = storage.isPremium;
    await analytics.setUserProperty(
      'subscription_tier',
      premium ? 'premium' : 'free',
    );
    await analytics.setUserProperty(
      'premium_product_type',
      _productType(storage.premiumProductId, premium),
    );
    await analytics.setUserProperty(
      'heart_access_type',
      premium ? 'unlimited' : 'metered',
    );
    await analytics.setUserProperty(
      'heart_balance_band',
      premium ? 'unlimited' : _heartBand(storage.lives),
    );
    await analytics.setUserProperty(
      'preferred_response_audio_state',
      storage.chatSpeakRepliesEnabled ? 'unmuted' : 'muted',
    );
    await analytics.setUserProperty('xp_band', _xpBand(storage.xpEarned));
  }

  static String? _authMethod(User? user) {
    if (user == null) return null;
    final ids = user.providerData.map((provider) => provider.providerId);
    if (ids.contains('google.com')) return 'google';
    if (ids.contains('apple.com')) return 'apple';
    if (ids.contains('password')) return 'email';
    return null;
  }

  static String? _learningGoal(String? raw) {
    return switch (raw) {
      'travel' => 'travel',
      'work' => 'work',
      'exam' => 'exams',
      'everyday' => 'everyday_english',
      'confidence' => 'confidence',
      _ => null,
    };
  }

  static String? _startingLevel(String? raw) {
    return switch (raw) {
      'beginner' => 'beginner',
      'elementary' => 'elementary',
      'intermediate' => 'intermediate',
      'upper_intermediate' || 'advanced' || 'advanced_c1' || 'proficient_c2' =>
        'advanced',
      _ => null,
    };
  }

  static String _productType(String? productId, bool premium) {
    if (!premium || productId == null || productId.isEmpty) return 'none';
    if (productId == IapProductIds.weekly) return 'weekly';
    if (productId == IapProductIds.monthly) return 'monthly';
    if (productId == IapProductIds.annual) return 'annual';
    if (productId == IapProductIds.lifetime) return 'lifetime';
    return 'none';
  }

  static String _heartBand(int lives) {
    if (lives <= 0) return '0';
    if (lives <= 2) return '1_2';
    if (lives <= 5) return '3_5';
    if (lives <= 10) return '6_10';
    return '11_plus';
  }

  static String _xpBand(int xp) {
    if (xp <= 0) return '0';
    if (xp < 100) return '1_99';
    if (xp < 500) return '100_499';
    if (xp < 1000) return '500_999';
    if (xp < 2000) return '1000_1999';
    if (xp < 3000) return '2000_2999';
    if (xp < 4000) return '3000_3999';
    if (xp < 5000) return '4000_4999';
    if (xp < 6000) return '5000_5999';
    return '6000_plus';
  }
}

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:fluentta_ai/data/models/onboarding_remote_config.dart';

class OnboardingConfigRepository {
  OnboardingConfigRepository();

  static const String _collection = 'app_config';
  static const String _documentId = 'onboarding';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  OnboardingRemoteConfig _cached = OnboardingRemoteConfig.defaults();
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _subscription;

  OnboardingRemoteConfig get current => _cached;

  Future<OnboardingRemoteConfig> fetch() async {
    try {
      final snapshot =
          await _firestore.collection(_collection).doc(_documentId).get();
      _cached = OnboardingRemoteConfig.fromFirestore(snapshot.data());
      return _cached;
    } catch (error, stack) {
      debugPrint('OnboardingConfigRepository.fetch failed: $error\n$stack');
      return _cached;
    }
  }

  void startListening(void Function(OnboardingRemoteConfig config) onChanged) {
    _subscription?.cancel();
    _subscription = _firestore
        .collection(_collection)
        .doc(_documentId)
        .snapshots()
        .listen(
      (snapshot) {
        _cached = OnboardingRemoteConfig.fromFirestore(snapshot.data());
        onChanged(_cached);
      },
      onError: (Object error) {
        debugPrint('OnboardingConfigRepository.listen failed: $error');
      },
    );
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
  }
}

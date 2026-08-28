import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:fluentta_ai/data/models/ads_remote_config.dart';

class AdsConfigRepository {
  AdsConfigRepository();

  static const String _collection = 'app_config';
  static const String _documentId = 'ads';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AdsRemoteConfig _cached = AdsRemoteConfig.defaults();
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _subscription;

  AdsRemoteConfig get current => _cached;

  Future<AdsRemoteConfig> fetch() async {
    try {
      final snapshot =
          await _firestore.collection(_collection).doc(_documentId).get();
      _cached = AdsRemoteConfig.fromFirestore(snapshot.data());
      return _cached;
    } catch (error, stack) {
      if (kDebugMode) {
        debugPrint('AdsConfigRepository.fetch failed: $error\n$stack');
      }
      return _cached;
    }
  }

  Stream<AdsRemoteConfig> watch() {
    return _firestore
        .collection(_collection)
        .doc(_documentId)
        .snapshots()
        .map((snapshot) {
      _cached = AdsRemoteConfig.fromFirestore(snapshot.data());
      return _cached;
    });
  }

  void startListening(void Function(AdsRemoteConfig config) onChanged) {
    _subscription?.cancel();
    _subscription = _firestore
        .collection(_collection)
        .doc(_documentId)
        .snapshots()
        .listen(
      (snapshot) {
        _cached = AdsRemoteConfig.fromFirestore(snapshot.data());
        onChanged(_cached);
      },
      onError: (Object error) {
        if (kDebugMode) {
          debugPrint('AdsConfigRepository.listen failed: $error');
        }
      },
    );
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
  }
}

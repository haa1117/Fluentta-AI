import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class RoleplayContentSyncRepository {
  RoleplayContentSyncRepository({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Connectivity _connectivity;

  static const _collection = 'roleplay_content';

  Future<bool> get _isOnline async {
    final result = await _connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  Future<Map<String, dynamic>?> fetchPath({
    required String scenarioId,
    required String practiceKey,
  }) async {
    if (!await _isOnline) return null;

    try {
      final docId = '${scenarioId}_$practiceKey';
      final snapshot = await _firestore.collection(_collection).doc(docId).get();
      if (!snapshot.exists) return null;
      final data = snapshot.data();
      if (data == null || data['lessons'] == null) return null;
      return Map<String, dynamic>.from(data);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('RoleplayContentSyncRepository.fetchPath failed: $e');
      }
      return null;
    }
  }
}

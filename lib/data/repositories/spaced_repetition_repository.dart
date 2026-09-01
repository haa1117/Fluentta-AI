import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/data/models/srs_record.dart';

class SpacedRepetitionRepository extends ChangeNotifier {
  SpacedRepetitionRepository(this._localStorage);

  final LocalStorage _localStorage;
  static const _storageKey = 'srs_words_v1';

  final Map<String, SrsRecord> _cache = {};
  bool _loaded = false;

  Future<void> initialize() async {
    if (_loaded) return;
    final raw = _localStorage.getString(_storageKey);
    if (raw != null && raw.isNotEmpty) {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      _cache.addAll(
        json.map(
          (key, value) => MapEntry(
            key,
            SrsRecord.fromJson(value as Map<String, dynamic>),
          ),
        ),
      );
    }
    _loaded = true;
  }

  Future<List<SrsRecord>> getDueReviews({DateTime? onDate}) async {
    await initialize();
    final date = onDate ?? DateTime.now();
    return _cache.values.where((r) => r.isDueOn(date)).toList()
      ..sort((a, b) => a.nextReviewDate.compareTo(b.nextReviewDate));
  }

  Future<int> dueCount({DateTime? onDate}) async {
    final due = await getDueReviews(onDate: onDate);
    return due.length;
  }

  Future<SrsRecord?> getRecord(String wordId) async {
    await initialize();
    return _cache[wordId];
  }

  Future<void> introduceWord(String wordId, {DateTime? onDate}) async {
    await initialize();
    if (_cache.containsKey(wordId)) return;
    _cache[wordId] = SrsRecord.initial(wordId, onDate ?? DateTime.now());
    await _persist();
    notifyListeners();
  }

  Future<void> introduceWords(Iterable<String> wordIds, {DateTime? onDate}) async {
    await initialize();
    var changed = false;
    for (final wordId in wordIds) {
      if (_cache.containsKey(wordId)) continue;
      _cache[wordId] = SrsRecord.initial(wordId, onDate ?? DateTime.now());
      changed = true;
    }
    if (changed) {
      await _persist();
      notifyListeners();
    }
  }

  Future<void> recordReview(
    String wordId,
    SrsRating rating, {
    DateTime? onDate,
  }) async {
    await initialize();
    final today = onDate ?? DateTime.now();
    final existing = _cache[wordId] ?? SrsRecord.initial(wordId, today);
    _cache[wordId] = existing.applyRating(rating, today);
    await _persist();
    notifyListeners();
  }

  Future<void> _persist() async {
    final json = _cache.map((key, value) => MapEntry(key, value.toJson()));
    await _localStorage.setString(_storageKey, jsonEncode(json));
  }
}

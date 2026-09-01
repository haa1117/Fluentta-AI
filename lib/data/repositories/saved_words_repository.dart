import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/data/models/vocabulary_word_entry.dart';

class SavedWordsRepository extends ChangeNotifier {
  SavedWordsRepository(this._localStorage);

  final LocalStorage _localStorage;
  static const _storageKey = 'saved_words_v1';

  final Map<String, VocabularyWordEntry> _cache = {};
  bool _loaded = false;

  Future<void> initialize() async {
    if (_loaded) return;
    final raw = _localStorage.getString(_storageKey);
    if (raw != null && raw.isNotEmpty) {
      final json = jsonDecode(raw) as List<dynamic>;
      for (final item in json) {
        final entry =
            VocabularyWordEntry.fromJson(item as Map<String, dynamic>);
        _cache[entry.id] = entry;
      }
    }
    _loaded = true;
  }

  int get count => _cache.length;

  Future<List<VocabularyWordEntry>> getAll() async {
    await initialize();
    final list = _cache.values.toList()
      ..sort((a, b) => a.word.compareTo(b.word));
    return list;
  }

  Future<bool> isSaved(String wordId) async {
    await initialize();
    return _cache.containsKey(wordId);
  }

  Future<void> save(VocabularyWordEntry entry) async {
    await initialize();
    _cache[entry.id] = entry;
    await _persist();
    notifyListeners();
  }

  Future<void> remove(String wordId) async {
    await initialize();
    _cache.remove(wordId);
    await _persist();
    notifyListeners();
  }

  Future<bool> toggle(VocabularyWordEntry entry) async {
    await initialize();
    if (_cache.containsKey(entry.id)) {
      await remove(entry.id);
      return false;
    }
    await save(entry);
    return true;
  }

  Future<void> _persist() async {
    final json = _cache.values.map((e) => e.toJson()).toList();
    await _localStorage.setString(_storageKey, jsonEncode(json));
  }
}

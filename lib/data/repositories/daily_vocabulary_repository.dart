import 'dart:convert';
import 'dart:math';

import 'package:fluentta_ai/core/cefr/cefr_level.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/data/models/vocabulary_word_entry.dart';
import 'package:fluentta_ai/data/repositories/lesson_content_repository.dart';

class DailyVocabularyRepository {
  DailyVocabularyRepository(
    this._localStorage,
    this._lessonContentRepository,
  );

  final LocalStorage _localStorage;
  final LessonContentRepository _lessonContentRepository;

  static const _storageKey = 'daily_vocab_v1';
  static const dailyWordCount = 5;

  Future<List<VocabularyWordEntry>> getTodaysWords(CefrLevel level) async {
    final todayKey = _dateKey(DateTime.now());
    final pool = await _lessonContentRepository.getAllVocabularyWordEntries(
      maxLevel: level,
    );
    if (pool.isEmpty) return const [];

    final stored = _readStoredSet();
    if (stored != null &&
        stored.date == todayKey &&
        stored.wordIds.length == dailyWordCount) {
      return _resolveWords(pool, stored.wordIds);
    }

    final picked = _pickDailyWords(pool, todayKey, level);
    await _persist(
      _StoredDailySet(
        date: todayKey,
        wordIds: picked.map((w) => w.id).toList(),
        studiedIds: stored?.date == todayKey ? stored!.studiedIds : {},
        completed: stored?.date == todayKey ? stored!.completed : false,
      ),
    );
    return picked;
  }

  Future<bool> isTodayComplete() async {
    final stored = _readStoredSet();
    if (stored == null) return false;
    return stored.date == _dateKey(DateTime.now()) && stored.completed;
  }

  Future<void> markTodayComplete() async {
    final stored = _readStoredSet();
    if (stored == null) return;
    await _persist(stored.copyWith(completed: true));
  }

  Future<Set<String>> getTodaysWordIds(CefrLevel level) async {
    final words = await getTodaysWords(level);
    return words.map((w) => w.id).toSet();
  }

  Future<void> recordWordStudied(String wordId) async {
    final todayKey = _dateKey(DateTime.now());
    final stored = _readStoredSet();
    if (stored == null || stored.date != todayKey) return;
    if (!stored.wordIds.contains(wordId)) return;

    final studied = {...stored.studiedIds, wordId};
    final completed = stored.wordIds.every(studied.contains);
    await _persist(
      stored.copyWith(studiedIds: studied, completed: completed),
    );
  }

  Future<void> _persist(_StoredDailySet stored) async {
    await _localStorage.setString(
      _storageKey,
      jsonEncode({
        'date': stored.date,
        'wordIds': stored.wordIds,
        'studiedIds': stored.studiedIds.toList(),
        'completed': stored.completed,
      }),
    );
  }

  _StoredDailySet? _readStoredSet() {
    final raw = _localStorage.getString(_storageKey);
    if (raw == null || raw.isEmpty) return null;
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return _StoredDailySet(
      date: json['date'] as String,
      wordIds: (json['wordIds'] as List<dynamic>).cast<String>(),
      studiedIds: (json['studiedIds'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toSet(),
      completed: json['completed'] as bool? ?? false,
    );
  }

  List<VocabularyWordEntry> _pickDailyWords(
    List<VocabularyWordEntry> pool,
    String dateKey,
    CefrLevel level,
  ) {
    final sorted = pool.toList()..sort((a, b) => a.id.compareTo(b.id));
    final random = Random(_seedFor(dateKey, level));
    final shuffled = List<VocabularyWordEntry>.from(sorted)..shuffle(random);
    return shuffled.take(dailyWordCount).toList();
  }

  List<VocabularyWordEntry> _resolveWords(
    List<VocabularyWordEntry> pool,
    List<String> wordIds,
  ) {
    final byId = {for (final w in pool) w.id: w};
    return wordIds
        .map((id) => byId[id])
        .whereType<VocabularyWordEntry>()
        .toList();
  }

  int _seedFor(String dateKey, CefrLevel level) {
    return Object.hash(dateKey, level.code).abs();
  }

  String _dateKey(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}

class _StoredDailySet {
  const _StoredDailySet({
    required this.date,
    required this.wordIds,
    required this.studiedIds,
    required this.completed,
  });

  final String date;
  final List<String> wordIds;
  final Set<String> studiedIds;
  final bool completed;

  _StoredDailySet copyWith({
    Set<String>? studiedIds,
    bool? completed,
  }) {
    return _StoredDailySet(
      date: date,
      wordIds: wordIds,
      studiedIds: studiedIds ?? this.studiedIds,
      completed: completed ?? this.completed,
    );
  }
}

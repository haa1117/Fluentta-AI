enum SrsRating { again, good, easy }

class SrsRecord {
  const SrsRecord({
    required this.wordId,
    required this.intervalDays,
    required this.repetitions,
    required this.nextReviewDate,
    this.lastReviewedDate,
  });

  final String wordId;
  final int intervalDays;
  final int repetitions;
  final String nextReviewDate;
  final String? lastReviewedDate;

  factory SrsRecord.initial(String wordId, DateTime today) {
    final dateKey = _dateKey(today.add(const Duration(days: 1)));
    return SrsRecord(
      wordId: wordId,
      intervalDays: 1,
      repetitions: 0,
      nextReviewDate: dateKey,
    );
  }

  factory SrsRecord.fromJson(Map<String, dynamic> json) {
    return SrsRecord(
      wordId: json['wordId'] as String,
      intervalDays: json['intervalDays'] as int? ?? 1,
      repetitions: json['repetitions'] as int? ?? 0,
      nextReviewDate: json['nextReviewDate'] as String,
      lastReviewedDate: json['lastReviewedDate'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'wordId': wordId,
      'intervalDays': intervalDays,
      'repetitions': repetitions,
      'nextReviewDate': nextReviewDate,
      if (lastReviewedDate != null) 'lastReviewedDate': lastReviewedDate,
    };
  }

  bool isDueOn(DateTime date) {
    return nextReviewDate.compareTo(_dateKey(date)) <= 0;
  }

  SrsRecord applyRating(SrsRating rating, DateTime today) {
    final todayKey = _dateKey(today);

    switch (rating) {
      case SrsRating.again:
        return SrsRecord(
          wordId: wordId,
          intervalDays: 1,
          repetitions: 0,
          nextReviewDate: _dateKey(today.add(const Duration(days: 1))),
          lastReviewedDate: todayKey,
        );
      case SrsRating.good:
        final nextInterval = switch (repetitions) {
          0 => 1,
          1 => 3,
          2 => 7,
          3 => 14,
          _ => (intervalDays * 2).clamp(14, 30),
        };
        return SrsRecord(
          wordId: wordId,
          intervalDays: nextInterval,
          repetitions: repetitions + 1,
          nextReviewDate: _dateKey(today.add(Duration(days: nextInterval))),
          lastReviewedDate: todayKey,
        );
      case SrsRating.easy:
        final nextInterval = switch (repetitions) {
          0 => 3,
          1 => 7,
          _ => (intervalDays * 3).clamp(7, 45),
        };
        return SrsRecord(
          wordId: wordId,
          intervalDays: nextInterval,
          repetitions: repetitions + 1,
          nextReviewDate: _dateKey(today.add(Duration(days: nextInterval))),
          lastReviewedDate: todayKey,
        );
    }
  }

  static String _dateKey(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}

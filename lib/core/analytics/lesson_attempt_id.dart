import 'dart:math';

/// Generates a UUID-v4-shaped id for `lesson_attempt_id`. Not cryptographically
/// unique, just collision-resistant enough for analytics correlation — avoids
/// adding the `uuid` package for a single generated string.
String generateLessonAttemptId() {
  final random = Random();
  String hex(int length) => List.generate(
        length,
        (_) => random.nextInt(16).toRadixString(16),
      ).join();

  return '${hex(8)}-${hex(4)}-4${hex(3)}-'
      '${(8 + random.nextInt(4)).toRadixString(16)}${hex(3)}-${hex(12)}';
}

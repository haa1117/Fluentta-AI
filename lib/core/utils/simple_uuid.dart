import 'dart:math';

/// Generates a UUID-v4-shaped string using [Random], for analytics
/// correlation ids (e.g. `conversion_journey_id`) where cryptographic
/// randomness isn't required and adding the `uuid` package isn't justified.
String generateUuidV4() {
  final random = Random();
  final bytes = List<int>.generate(16, (_) => random.nextInt(256));

  bytes[6] = (bytes[6] & 0x0f) | 0x40;
  bytes[8] = (bytes[8] & 0x3f) | 0x80;

  String hex(int start, int end) => bytes
      .sublist(start, end)
      .map((b) => b.toRadixString(16).padLeft(2, '0'))
      .join();

  return '${hex(0, 4)}-${hex(4, 6)}-${hex(6, 8)}-${hex(8, 10)}-${hex(10, 16)}';
}

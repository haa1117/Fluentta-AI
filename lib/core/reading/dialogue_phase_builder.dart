import 'package:fluentta_ai/data/models/reading_lesson_model.dart';

/// Splits dialogue lines into progressive parts (e.g. Part 1–5), same as reading lessons.
class DialoguePhaseBuilder {
  DialoguePhaseBuilder._();

  static const int defaultPartCount = 5;

  static const String defaultDialogueTip =
      "Try speaking the 'You' response out loud to practice your pronunciation!";

  static int visibleUnitCount({
    required int part,
    required int totalUnits,
    required int partCount,
  }) {
    if (totalUnits == 0) return 0;
    if (part >= partCount) return totalUnits;

    final count = ((part * totalUnits) / partCount).ceil();
    return count.clamp(1, totalUnits);
  }

  static List<ReadingDialogueLineModel> linesForPart(
    List<ReadingDialogueLineModel> units,
    int part,
    int partCount,
  ) {
    if (units.isEmpty) return const [];

    final visibleCount = visibleUnitCount(
      part: part,
      totalUnits: units.length,
      partCount: partCount,
    );
    return units.sublist(0, visibleCount);
  }

  static List<ReadingPhaseModel> buildDialoguePhases(
    List<ReadingDialogueLineModel> units, {
    String? tip,
    int dialoguePartCount = defaultPartCount,
  }) {
    final partCount = dialoguePartCount.clamp(1, 5);
    final readingTip = tip ?? defaultDialogueTip;

    return [
      for (var part = 1; part <= partCount; part++)
        ReadingPhaseModel(
          phaseTitle: 'Dialogue Part $part',
          dialoguePartNumber: part,
          lines: linesForPart(units, part, partCount),
          tip: readingTip,
          isTextPassage: false,
        ),
    ];
  }
}

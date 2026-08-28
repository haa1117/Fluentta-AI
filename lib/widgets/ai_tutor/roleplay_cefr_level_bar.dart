import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/cefr/cefr_level.dart';
import 'package:fluentta_ai/widgets/common/cefr_level_bar.dart';

/// Role Play level tabs — uses the shared [CefrLevelBar] widget.
class RoleplayCefrLevelBar extends StatelessWidget {
  const RoleplayCefrLevelBar({
    super.key,
    required this.totalXp,
    required this.selectedLevel,
    required this.onLevelSelected,
  });

  final int totalXp;
  final CefrLevel selectedLevel;
  final ValueChanged<CefrLevel> onLevelSelected;

  @override
  Widget build(BuildContext context) {
    return CefrLevelBar(
      totalXp: totalXp,
      selectedLevel: selectedLevel,
      onLevelSelected: onLevelSelected,
    );
  }
}

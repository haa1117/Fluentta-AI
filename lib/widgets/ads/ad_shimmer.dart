import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';

class AdShimmer extends StatefulWidget {
  const AdShimmer({
    super.key,
    required this.height,
  });

  final double height;

  @override
  State<AdShimmer> createState() => _AdShimmerState();
}

class _AdShimmerState extends State<AdShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? const Color(0xFF2A2435) : AppColors.adPlaceholder;
    final highlight = isDark ? const Color(0xFF3D3548) : const Color(0xFFEEEEF2);

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSizes.adRadius),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Container(
            width: double.infinity,
            height: widget.height,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.adBorder),
              gradient: LinearGradient(
                begin: Alignment(-1.0 - _controller.value * 2, 0),
                end: Alignment(1.0 - _controller.value * 2, 0),
                colors: [base, highlight, base],
              ),
            ),
          );
        },
      ),
    );
  }
}

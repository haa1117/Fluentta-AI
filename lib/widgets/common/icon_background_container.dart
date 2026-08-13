import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class IconBackgroundContainerWidget extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;
  const IconBackgroundContainerWidget({super.key, required this.child,  this.width=60,  this.height=60});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: Color(0xffF3E8FF),
          shape: BoxShape.circle
      ),
      child: child,
    );
  }
}

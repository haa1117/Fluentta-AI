import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class FooterWidget extends StatelessWidget {
  final Widget child;
  const FooterWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return   Container(
      decoration: BoxDecoration(
        color: Colors.white,

        boxShadow: [
          BoxShadow(
            color: Color(0x0D000000),
            offset: Offset(0, -2),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSizes.horizontalPadding,
          AppSizes.spaceLg,
          AppSizes.horizontalPadding,
          AppSizes.spaceLg,
        ),
        child:child,
      ),
    );
  }
}

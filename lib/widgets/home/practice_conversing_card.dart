import 'package:fluentta_ai/widgets/common/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';

class PracticeConversingCard extends StatelessWidget {
  const PracticeConversingCard({
    super.key,
    required this.onStartChat,
  });

  final VoidCallback onStartChat;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.w(16)),
      decoration: BoxDecoration(
        color: AppColors.homeCardLavender,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: AppSizes.w(120),
                height: AppSizes.h(130),
                child: Image.asset(
                 'assets/images/start_chat.png',
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(width: AppSizes.w(15)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Practice Conversing',
                      style: TextStyle(
                        fontFamily: AppFonts.plusJakartaSans,
                        fontSize: AppSizes.sp(20),
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: AppSizes.spaceSm),
                    Text(
                      'Talk with your AI tutor by voice or text and get instant corrections',
                      style: TextStyle(
                        fontFamily: AppFonts.plusJakartaSans,
                        fontSize: AppSizes.sp(12),
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // SizedBox(height: AppSizes.sp(1)),
          Row(
            children: [

              SizedBox(
                width: AppSizes.sp(15),
              ),
              Image.asset("assets/images/chat_mic.png",
              scale: AppSizes.sp(3),
              
              ),
              // _CircleActionButton(icon: Icons.mic_none_rounded),
              // SizedBox(width: AppSizes.w(8)),
              // _CircleActionButton(icon: Icons.chat_bubble_outline_rounded),
              const Spacer(),
              GestureDetector(
                onTap: onStartChat,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.w(16),
                    vertical: AppSizes.h(12),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
                    gradient: AppColors.primaryGradient ,
                    color:  AppColors.primaryColor
                    // boxShadow: isActive
                    //     ? [
                    //         BoxShadow(
                    //           color: AppColors.primaryGradientStart.withValues(alpha: 0.35),
                    //           blurRadius: 16,
                    //           offset: Offset(0, AppSizes.h(8)),
                    //         ),
                    //       ]
                    //     : null,
                  ),

                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Start AI Chat',
                        style: TextStyle(
                          fontFamily: AppFonts.plusJakartaSans,
                          fontSize: AppSizes.sp(13),
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                      SizedBox(width: AppSizes.w(6)),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: AppColors.white,
                        size: AppSizes.sp(16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CircleActionButton extends StatelessWidget {
  const _CircleActionButton({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.w(40),
      height: AppSizes.w(40),
      decoration: const BoxDecoration(
        color: AppColors.white,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: AppColors.primaryColor,
        size: AppSizes.iconSmall,
      ),
    );
  }
}

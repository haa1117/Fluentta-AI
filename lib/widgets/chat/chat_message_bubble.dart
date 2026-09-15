import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/data/models/tutor_chat_models.dart';
import 'package:fluentta_ai/widgets/chat/chat_correction_card.dart';

/// A single turn in the open-chat transcript. Renders the AI avatar + bubble
/// on the left, the learner's bubble on the right, and an optional inline
/// correction card beneath an AI reply.
class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.correctionLabel,
    required this.yourSentenceLabel,
    required this.correctSentenceLabel,
    required this.tipPrefix,
    this.originalUserText,
    this.isSpeaking = false,
    this.onSpeak,
    this.playLabel = 'Play',
    this.playingLabel = 'Playing',
  });

  final OpenChatMessage message;
  final String correctionLabel;
  final String yourSentenceLabel;
  final String correctSentenceLabel;
  final String tipPrefix;

  /// The learner sentence this AI turn is correcting, used by the inline card.
  final String? originalUserText;

  /// True while this bubble's text is being read aloud.
  final bool isSpeaking;

  /// Tap handler for the play/stop speaker button. Null hides the button
  /// (e.g. on the learner's own messages).
  final VoidCallback? onSpeak;
  final String playLabel;
  final String playingLabel;

  static const Color _ink = Color(0xFF1D192C);
  static const Color _userInk = Color(0xFFEDE0FF);

  @override
  Widget build(BuildContext context) {
    return message.isUser ? _buildUser(context) : _buildAi(context);
  }

  Widget _buildUser(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            constraints: BoxConstraints(maxWidth: AppSizes.w(294)),
            padding: EdgeInsets.all(AppSizes.w(16)),
            decoration: BoxDecoration(
              color: AppColors.primaryBlueColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppSizes.w(16)),
                bottomLeft: Radius.circular(AppSizes.w(16)),
                bottomRight: Radius.circular(AppSizes.w(16)),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.10),
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              message.text,
              style: TextStyle(
                fontFamily: AppFonts.plusJakartaSans,
                fontSize: AppSizes.sp(16),
                height: 1.4,
                color: _userInk,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAi(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasCorrection = message.correctedText != null &&
        message.correctedText!.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _avatar(isDark),
            SizedBox(width: AppSizes.w(12)),
            Flexible(
              child: Container(
                constraints: BoxConstraints(maxWidth: AppSizes.w(300)),
                padding: EdgeInsets.all(AppSizes.w(16)),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.surfaceBgDarkColor
                      : AppColors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(AppSizes.w(16)),
                    bottomLeft: Radius.circular(AppSizes.w(16)),
                    bottomRight: Radius.circular(AppSizes.w(16)),
                  ),
                  border: Border.all(
                    color: isDark
                        ? AppColors.borderDarkColor
                        : AppColors.borderLight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 1,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Text(
                  message.text,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(16),
                    height: 1.4,
                    color: isDark ? AppColors.textPrimaryDark : _ink,
                  ),
                ),
              ),
            ),
          ],
        ),
        if (onSpeak != null) ...[
          SizedBox(height: AppSizes.h(6)),
          _speakButton(isDark),
        ],
        if (hasCorrection) ...[
          SizedBox(height: AppSizes.h(16)),
          ChatCorrectionCard(
            label: correctionLabel,
            yourSentenceLabel: yourSentenceLabel,
            correctSentenceLabel: correctSentenceLabel,
            tipPrefix: tipPrefix,
            originalSentence:
                (originalUserText ?? message.text).trim(),
            correctedSentence: message.correctedText!.trim(),
            tip: message.explanation,
          ),
        ],
      ],
    );
  }

  Widget _speakButton(bool isDark) {
    return Padding(
      padding: EdgeInsets.only(left: AppSizes.w(52)),
      child: GestureDetector(
        onTap: onSpeak,
        behavior: HitTestBehavior.opaque,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSpeaking ? Icons.stop_circle_rounded : Icons.volume_up_rounded,
              size: AppSizes.sp(18),
              color: isSpeaking
                  ? AppColors.primaryColor
                  : (isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondary),
            ),
            SizedBox(width: AppSizes.w(4)),
            Text(
              isSpeaking ? playingLabel : playLabel,
              style: TextStyle(
                fontFamily: AppFonts.plusJakartaSans,
                fontSize: AppSizes.sp(11),
                fontWeight: FontWeight.w600,
                color: isSpeaking
                    ? AppColors.primaryColor
                    : (isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _avatar(bool isDark) {
    return Container(
      width: AppSizes.w(40),
      height: AppSizes.w(40),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark
            ? AppColors.brandDarkSoftColor
            : AppColors.brandLightSoftColor,
      ),
      alignment: Alignment.center,
      child: ClipOval(
        child: Image.asset(
          AppAssets.aiTutor,
          width: AppSizes.w(36),
          height: AppSizes.w(36),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

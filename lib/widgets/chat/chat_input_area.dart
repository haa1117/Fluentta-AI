import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/viewmodels/open_chat_view_model.dart';

/// Small "1 heart per AI response" hint shown beneath both input surfaces.
class ChatHeartFooter extends StatelessWidget {
  const ChatHeartFooter({super.key, required this.label, this.pill = false});

  final String label;
  final bool pill;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final row = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.favorite_rounded,
          size: AppSizes.sp(16),
          color: AppColors.heartRed,
        ),
        SizedBox(width: AppSizes.w(4)),
        Text(
          label,
          style: TextStyle(
            fontFamily: AppFonts.plusJakartaSans,
            fontSize: AppSizes.sp(12),
            fontWeight: FontWeight.w500,
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondary,
          ),
        ),
      ],
    );
    if (!pill) return row;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.w(12),
        vertical: AppSizes.h(6),
      ),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackground(context),
        borderRadius: BorderRadius.circular(AppSizes.w(1000)),
      ),
      child: row,
    );
  }
}

/// Text composer: rounded input pill + circular send button, with the heart
/// hint underneath.
class ChatTextInputBar extends StatelessWidget {
  const ChatTextInputBar({
    super.key,
    required this.controller,
    required this.hintText,
    required this.footerLabel,
    required this.enabled,
    required this.onSend,
  });

  final TextEditingController controller;
  final String hintText;
  final String footerLabel;
  final bool enabled;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.surfaceBgDarkColor
                      : AppColors.chipBackgroundColor,
                  borderRadius: BorderRadius.circular(AppSizes.w(999)),
                  border: Border.all(
                    color: isDark
                        ? AppColors.borderDarkColor
                        : const Color(0x80CCC3D8),
                  ),
                ),
                child: TextField(
                  controller: controller,
                  enabled: enabled,
                  minLines: 1,
                  maxLines: 4,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => onSend(),
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(16),
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: hintText,
                    hintStyle: TextStyle(
                      fontFamily: AppFonts.plusJakartaSans,
                      fontSize: AppSizes.sp(16),
                      color: (isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.profileSubtitleColor)
                          .withValues(alpha: 0.6),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppSizes.w(20),
                      vertical: AppSizes.h(12),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: AppSizes.w(12)),
            GestureDetector(
              onTap: enabled ? onSend : null,
              child: Container(
                width: AppSizes.w(48),
                height: AppSizes.w(48),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBlueColor.withValues(alpha: 0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.send_rounded,
                  size: AppSizes.sp(20),
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSizes.h(10)),
        ChatHeartFooter(label: footerLabel),
      ],
    );
  }
}

/// Push-to-talk panel. Hold the mic to record; slide left past the "Cancel"
/// hint to discard, slide right past "Lock" to keep recording hands-free, and
/// release (or tap when locked) to send.
class ChatVoiceInputPanel extends StatefulWidget {
  const ChatVoiceInputPanel({
    super.key,
    required this.state,
    required this.holdToSpeakLabel,
    required this.listeningLabel,
    required this.releaseHintLabel,
    required this.tapHintLabel,
    required this.cancelLabel,
    required this.lockLabel,
    required this.footerLabel,
    required this.onBegin,
    required this.onCancel,
    required this.onLock,
    required this.onFinish,
  });

  final VoiceCaptureState state;
  final String holdToSpeakLabel;
  final String listeningLabel;
  final String releaseHintLabel;
  final String tapHintLabel;
  final String cancelLabel;
  final String lockLabel;
  final String footerLabel;
  final VoidCallback onBegin;
  final VoidCallback onCancel;
  final VoidCallback onLock;
  final VoidCallback onFinish;

  @override
  State<ChatVoiceInputPanel> createState() => _ChatVoiceInputPanelState();
}

class _ChatVoiceInputPanelState extends State<ChatVoiceInputPanel> {
  static const double _cancelThreshold = -80;
  static const double _lockThreshold = 80;

  /// A press shorter than this is almost always an accidental tap, not a
  /// deliberate "hold to speak" — treat it as a cancel instead of trying to
  /// transcribe a fraction-of-a-second clip (which tends to come back as
  /// hallucinated garbage text and gets sent as a real message).
  static const Duration _minHoldDuration = Duration(milliseconds: 350);

  final GlobalKey _micKey = GlobalKey();

  double _dragDx = 0;
  bool _cancelArmed = false;
  bool _pressing = false;
  Offset _startPos = Offset.zero;
  DateTime? _downAt;

  bool _hitMic(Offset globalPos) {
    final renderObject = _micKey.currentContext?.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) return false;
    final origin = renderObject.localToGlobal(Offset.zero);
    return (origin & renderObject.size).inflate(16).contains(globalPos);
  }

  void _onPointerDown(PointerDownEvent event) {
    if (widget.state == VoiceCaptureState.locked) {
      _pressing = _hitMic(event.position);
      return;
    }
    if (widget.state != VoiceCaptureState.idle) return;
    if (!_hitMic(event.position)) return;
    // Push-to-talk: start the instant the finger lands, no long-press delay.
    _pressing = true;
    _startPos = event.position;
    _downAt = DateTime.now();
    _dragDx = 0;
    _cancelArmed = false;
    widget.onBegin();
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (!_pressing || widget.state == VoiceCaptureState.locked) return;
    final dx = event.position.dx - _startPos.dx;
    setState(() {
      _dragDx = dx;
      _cancelArmed = dx <= _cancelThreshold;
    });
    if (dx >= _lockThreshold) {
      _pressing = false;
      _dragDx = 0;
      _cancelArmed = false;
      widget.onLock();
    }
  }

  void _onPointerUp(PointerUpEvent event) {
    if (!_pressing) return;
    _pressing = false;
    if (widget.state == VoiceCaptureState.locked) {
      widget.onFinish();
      return;
    }
    final downAt = _downAt;
    final tooShort = downAt != null &&
        DateTime.now().difference(downAt) < _minHoldDuration;
    if (_cancelArmed || tooShort) {
      widget.onCancel();
    } else {
      widget.onFinish();
    }
    setState(() {
      _dragDx = 0;
      _cancelArmed = false;
    });
  }

  void _onPointerCancel(PointerCancelEvent event) {
    if (!_pressing) return;
    _pressing = false;
    if (widget.state != VoiceCaptureState.locked) {
      widget.onCancel();
    }
    setState(() {
      _dragDx = 0;
      _cancelArmed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Listener(
      onPointerDown: _onPointerDown,
      onPointerMove: _onPointerMove,
      onPointerUp: _onPointerUp,
      onPointerCancel: _onPointerCancel,
      child: Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        AppSizes.w(20),
        AppSizes.h(18),
        AppSizes.w(20),
        AppSizes.h(16),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [
                  AppColors.darkScaffoldBackgroundColor,
                  AppColors.brandDarkSoftColor,
                ]
              : const [Color(0xFFFCF7FF), Color(0xFFD6C5F9)],
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.w(24))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 2,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        alignment: Alignment.topCenter,
        child: switch (widget.state) {
          VoiceCaptureState.idle => _buildIdle(isDark),
          VoiceCaptureState.recording => _buildRecording(isDark),
          VoiceCaptureState.locked => _buildLocked(isDark),
        },
      ),
      ),
    );
  }

  /// Every state shares the same skeleton — a status label, then a
  /// fixed-height mic slot, then a hint/footer row — so the mic button stays
  /// anchored at the same on-screen position across idle → recording →
  /// locked instead of visibly jumping down when the label above it changes.
  static double get _micSlotHeight => AppSizes.w(76);

  Widget _buildIdle(bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.holdToSpeakLabel,
          style: _labelStyle(color: AppColors.primaryColor, bold: true),
        ),
        SizedBox(height: AppSizes.h(12)),
        SizedBox(
          height: _micSlotHeight,
          child: Center(
            child: _MicButton(key: _micKey, size: AppSizes.w(76), pulsing: false),
          ),
        ),
        SizedBox(height: AppSizes.h(10)),
        ChatHeartFooter(label: widget.footerLabel, pill: true),
      ],
    );
  }

  Widget _buildRecording(bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.listeningLabel,
          style: _labelStyle(color: AppColors.primaryColor, bold: true),
        ),
        SizedBox(height: AppSizes.h(12)),
        SizedBox(
          height: _micSlotHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SlideHint(
                icon: Icons.keyboard_double_arrow_left_rounded,
                label: widget.cancelLabel,
                leading: true,
                highlighted: _cancelArmed,
              ),
              Transform.translate(
                offset: Offset(_dragDx.clamp(-48.0, 48.0), 0),
                child: _MicButton(
                  key: _micKey,
                  size: AppSizes.w(58),
                  pulsing: true,
                  danger: _cancelArmed,
                ),
              ),
              _SlideHint(
                icon: Icons.keyboard_double_arrow_right_rounded,
                label: widget.lockLabel,
                leading: false,
                highlighted: _dragDx >= _lockThreshold,
              ),
            ],
          ),
        ),
        SizedBox(height: AppSizes.h(12)),
        Text(
          widget.releaseHintLabel,
          style: _labelStyle(
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildLocked(bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.listeningLabel,
          style: _labelStyle(color: AppColors.primaryColor, bold: true),
        ),
        SizedBox(height: AppSizes.h(12)),
        SizedBox(
          height: _micSlotHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // A locked recording can no longer be discarded by "releasing"
              // — that gesture is gone once hands-free. Give an explicit way
              // to bail out instead of forcing the learner to send it.
              GestureDetector(
                onTap: widget.onCancel,
                child: Container(
                  width: AppSizes.w(44),
                  height: AppSizes.w(44),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark
                        ? AppColors.brandDarkSoftColor
                        : AppColors.homeCardLavender,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.delete_outline_rounded,
                    size: AppSizes.sp(20),
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondary,
                  ),
                ),
              ),
              SizedBox(width: AppSizes.w(24)),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    key: _micKey,
                    width: AppSizes.w(58),
                    height: AppSizes.w(58),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF9834F0),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.graphic_eq_rounded,
                      size: AppSizes.sp(26),
                      color: AppColors.white,
                    ),
                  ),
                  // Locked badge — makes it visually clear this is now a
                  // hands-free "tap to send" state, not still a press-hold.
                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: Container(
                      width: AppSizes.w(20),
                      height: AppSizes.w(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark
                            ? AppColors.darkScaffoldBackgroundColor
                            : AppColors.white,
                        border: Border.all(
                          color: isDark
                              ? AppColors.brandDarkSoftColor
                              : AppColors.homeCardLavender,
                          width: 2,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.lock_rounded,
                        size: AppSizes.sp(11),
                        color: const Color(0xFF9834F0),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: AppSizes.h(12)),
        Text(
          widget.tapHintLabel,
          style: _labelStyle(
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  TextStyle _labelStyle({required Color color, bool bold = false}) {
    return TextStyle(
      fontFamily: AppFonts.plusJakartaSans,
      fontSize: AppSizes.sp(bold ? 14 : 12),
      fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
      letterSpacing: bold ? 0.14 : 0,
      color: color,
    );
  }
}

class _MicButton extends StatelessWidget {
  const _MicButton({
    super.key,
    required this.size,
    required this.pulsing,
    this.danger = false,
  });

  final double size;
  final bool pulsing;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: danger
            ? const LinearGradient(
                colors: [Color(0xFFF43F5E), Color(0xFFDC2626)],
              )
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryGradientStart,
                  AppColors.primaryGradientEnd,
                ],
              ),
        boxShadow: [
          BoxShadow(
            color: (danger ? AppColors.redColor : AppColors.primaryColor)
                .withValues(alpha: pulsing ? 0.45 : 0.3),
            blurRadius: pulsing ? 28 : 18,
            spreadRadius: pulsing ? 4 : 0,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.mic_rounded,
        size: size * 0.42,
        color: AppColors.white,
      ),
    );
  }
}

class _SlideHint extends StatelessWidget {
  const _SlideHint({
    required this.icon,
    required this.label,
    required this.leading,
    required this.highlighted,
  });

  final IconData icon;
  final String label;
  final bool leading;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = highlighted
        ? AppColors.primaryColor
        : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary);
    final iconWidget = Icon(icon, size: AppSizes.sp(18), color: color);
    final textWidget = Text(
      label,
      style: TextStyle(
        fontFamily: AppFonts.plusJakartaSans,
        fontSize: AppSizes.sp(12),
        fontWeight: FontWeight.w500,
        color: color,
      ),
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: leading
          ? [iconWidget, SizedBox(width: AppSizes.w(4)), textWidget]
          : [textWidget, SizedBox(width: AppSizes.w(4)), iconWidget],
    );
  }
}

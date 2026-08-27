import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/viewmodels/home_view_model.dart';
import 'package:fluentta_ai/widgets/chat/out_of_hearts_dialog.dart';
import 'package:fluentta_ai/widgets/common/appbar_widget.dart';
import 'package:provider/provider.dart';

class OpenChatPracticeScreen extends StatefulWidget {
  const OpenChatPracticeScreen({super.key});

  @override
  State<OpenChatPracticeScreen> createState() => _OpenChatPracticeScreenState();
}

class _OpenChatPracticeScreenState extends State<OpenChatPracticeScreen> {
  bool _textMode = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final lives = context.read<HomeViewModel>().lives;
      if (lives <= 0 && mounted) {
        showOutOfHeartsDialog(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: AppBarWidget(
        title: l10n.openChatPracticeTitle,
        showBackButton: true,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSizes.horizontalPadding,
              AppSizes.spaceMd,
              AppSizes.horizontalPadding,
              0,
            ),
            child: Container(
              padding: EdgeInsets.all(AppSizes.w(4)),
              decoration: BoxDecoration(
                color: AppColors.homeCardLavender,
                borderRadius: BorderRadius.circular(AppSizes.w(12)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _ModeTab(
                      label: l10n.textMode,
                      isSelected: _textMode,
                      onTap: () => setState(() => _textMode = true),
                    ),
                  ),
                  Expanded(
                    child: _ModeTab(
                      label: l10n.textMode,
                      isSelected: !_textMode,
                      onTap: () => setState(() => _textMode = false),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(AppSizes.horizontalPadding),
              children: [
                SizedBox(height: AppSizes.h(16)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipOval(
                      child: Image.asset(
                        AppAssets.aiTutor,
                        width: AppSizes.w(36),
                        height: AppSizes.w(36),
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: AppSizes.w(10)),
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.all(AppSizes.w(14)),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(AppSizes.w(16)),
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: Text(
                          l10n.chatGreeting,
                          style: TextStyle(
                            fontFamily: AppFonts.plusJakartaSans,
                            fontSize: AppSizes.sp(14),
                            color: AppColors.textPrimary,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSizes.horizontalPadding,
              0,
              AppSizes.horizontalPadding,
              AppSizes.spaceLg,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: l10n.textMode,
                      filled: true,
                      fillColor: AppColors.white,
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppSizes.buttonRadius),
                        borderSide:
                            const BorderSide(color: AppColors.borderLight),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppSizes.buttonRadius),
                        borderSide:
                            const BorderSide(color: AppColors.borderLight),
                      ),
                    ),
                    onTap: () {
                      if (context.read<HomeViewModel>().lives <= 0) {
                        showOutOfHeartsDialog(context);
                      }
                    },
                  ),
                ),
                SizedBox(width: AppSizes.w(8)),
                IconButton(
                  onPressed: () async {
                    final home = context.read<HomeViewModel>();
                    if (!home.hasUnlimitedHearts && home.lives <= 0) {
                      showOutOfHeartsDialog(context);
                      return;
                    }
                    final charged = await home.useHeart();
                    if (!context.mounted) return;
                    if (!charged) {
                      showOutOfHeartsDialog(context);
                      return;
                    }
                    SnackbarHelper.showSuccess(context, l10n.openingSoon);
                  },
                  icon: Icon(
                    Icons.send_rounded,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeTab extends StatelessWidget {
  const _ModeTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: AppSizes.h(10)),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSizes.w(10)),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: AppFonts.plusJakartaSans,
            fontSize: AppSizes.sp(13),
            fontWeight: FontWeight.w600,
            color: isSelected
                ? AppColors.primaryColor
                : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

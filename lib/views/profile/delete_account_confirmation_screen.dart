import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/core/utils/auth_exception_handler.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/viewmodels/auth_view_model.dart';
import 'package:fluentta_ai/views/profile/account_deleted_screen.dart';
import 'package:fluentta_ai/widgets/auth/auth_text_field.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class DeleteAccountConfirmationScreen extends StatefulWidget {
  const DeleteAccountConfirmationScreen({super.key});

  @override
  State<DeleteAccountConfirmationScreen> createState() =>
      _DeleteAccountConfirmationScreenState();
}

class _DeleteAccountConfirmationScreenState
    extends State<DeleteAccountConfirmationScreen> {
  bool _confirmed = false;
  bool _isDeleting = false;
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  bool get _requiresPassword =>
      context.read<AuthViewModel>().canChangePassword;

  bool get _canDelete {
    if (!_confirmed || _isDeleting) return false;
    if (_requiresPassword && _passwordController.text.trim().isEmpty) {
      return false;
    }
    return true;
  }

  Future<void> _deleteAccount() async {
    if (!_canDelete) return;
    setState(() => _isDeleting = true);
    try {
      await context.read<AuthViewModel>().deleteAccount(
            currentPassword: _requiresPassword
                ? _passwordController.text
                : null,
          );
      if (!mounted) return;
      await Navigator.of(context).pushReplacement<void, void>(
        MaterialPageRoute<void>(builder: (_) => const AccountDeletedScreen()),
      );
    } catch (error) {
      if (!mounted) return;
      setState(() => _isDeleting = false);
      SnackbarHelper.showError(
        context,
        AuthExceptionHandler.getMessage(error, context.l10n),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final requiresPassword = context.watch<AuthViewModel>().canChangePassword;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
          child: Column(
            children: [
              SizedBox(height: AppSizes.h(24)),
              Image.asset(
                AppAssets.deleteAccountDialogImage,
                height: AppSizes.h(150),
                fit: BoxFit.contain,
              ),
              SizedBox(height: AppSizes.h(20)),
              Text(
                l10n.deleteAccountConfirmation,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(23),
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  height: 1.25,
                ),
              ),
              SizedBox(height: AppSizes.h(30)),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(AppSizes.w(16)),
                decoration: BoxDecoration(
                  color:Color(0xffF3E8FF),
                  borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                  border: Border(
                    left: BorderSide(
                      color: AppColors.redColor,
                      width: AppSizes.w(4),
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                      AppAssets.warningIcon,
                          color: AppColors.heartRed,
                          width: AppSizes.sp(20),
                          height: AppSizes.sp(20),
                        ),
                        SizedBox(width: AppSizes.w(18)),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.warning,
                                style: TextStyle(
                                  fontFamily: AppFonts.plusJakartaSans,
                                  fontSize: AppSizes.sp(16),
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.redColor,
                                ),
                              ),
                              SizedBox(height: AppSizes.h(8)),
                              Text(
                                l10n.deleteWarningMessage,
                                style: TextStyle(
                                  fontFamily: AppFonts.plusJakartaSans,
                                  fontSize: AppSizes.sp(14),
                                  fontWeight: FontWeight.w400,
                                  height: 1.45,
                                  color: Color(0xffDC2626),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),


                  ],
                ),
              ),
              SizedBox(height: AppSizes.h(25)),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(AppSizes.w(16)),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: AppSizes.w(24),
                      height: AppSizes.w(24),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _confirmed = !_confirmed;
                          });
                        },
                        borderRadius: BorderRadius.circular(3),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: AppColors.borderLight,
                              width: 2
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: _confirmed
                              ?  Center(
                            child: SvgPicture.asset(
                              'assets/svg/delete_check_icon.svg',
                              width: 12,
                              height: 12,
                            ),
                          )
                              : const SizedBox.shrink(),
                        ),
                      ),
                    ),
//                     SizedBox(
//                       width: AppSizes.w(24),
//                       height: AppSizes.w(24),
//                       child: InkWell(
//                         onFocusChange:(value) =>
//                             setState(() => _confirmed = value ?? false) ,
//                         child: Container(
//                          decoration: BoxDecoration(
// color: Colors.transparent,
//                            border: Border.all(
//                              color: AppColors.borderLight
//                            ),
//
//                            shape: BoxShape.rectangle,
//                            borderRadius: BorderRadius.circular(3)
//                          ),
//
// child: _confirmed ? Center(
//   child: Icon(
//     Icons.check
//   ),
// ):SizedBox.shrink(),
//                         ),
//                       ),
//                     ),
                    SizedBox(width: AppSizes.w(12)),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _confirmed = !_confirmed),
                        child: Text(
                          l10n.understandPermanent,
                          style: TextStyle(
                            fontFamily: AppFonts.plusJakartaSans,
                            fontSize: AppSizes.sp(15),
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (requiresPassword) ...[
                SizedBox(height: AppSizes.h(20)),
                AuthTextField(
                  isDark: isDark,

                  label: l10n.currentPassword,
                  hint: l10n.enterCurrentPassword,
                  controller: _passwordController,
                  obscureText: true,
                  showVisibilityToggle: true,
                  isShowPrefixIcon: false,
                ),
              ],
              SizedBox(height: AppSizes.h(24)),
              SizedBox(
                width: double.infinity,
                height: AppSizes.buttonHeight,
                child: ElevatedButton(
                  onPressed: _canDelete ? _deleteAccount : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.redColor,
                    disabledBackgroundColor:
                        AppColors.heartRed.withValues(alpha: 0.35),
                    foregroundColor: AppColors.white,
                    disabledForegroundColor: AppColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
                    ),
                  ),
                  child: _isDeleting
                      ? SizedBox(
                          width: AppSizes.w(22),
                          height: AppSizes.w(22),
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.white,
                          ),
                        )
                      : Text(
                          l10n.deleteAccountBtn,
                          style: TextStyle(
                            fontFamily: AppFonts.plusJakartaSans,
                            fontSize: AppSizes.sp(16),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
              SizedBox(height: AppSizes.h(12)),
              TextButton(
                onPressed: _isDeleting
                    ? null
                    : () => Navigator.of(context).pop(),
                child: Text(
                  l10n.cancelBtn,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(16),
                    fontWeight: FontWeight.w700,
                    color: Color(0xff665D72),
                  ),
                ),
              ),
              SizedBox(height: AppSizes.h(24)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  l10n.deleteMarketingNote,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(12),
                    fontWeight: FontWeight.w500,
                    color: Color(0xff7E7386),
                    height: 1.4,
                  ),
                ),
              ),
              SizedBox(height: AppSizes.h(24)),
            ],
          ),
        ),
      ),
    );
  }
}

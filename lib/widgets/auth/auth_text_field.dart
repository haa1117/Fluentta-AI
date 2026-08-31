import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';

class AuthTextField extends StatefulWidget {
  const AuthTextField({
    super.key,
    required this.label,
    required this.hint,
    this.prefixIcon = Icons.edit_outlined,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.showVisibilityToggle = false,
    this.isShowPrefixIcon = false,
    this.readOnly = false,
    this.enabled = true, required this.isDark,
  });

  final String label;
  final String hint;
  final IconData prefixIcon;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final bool showVisibilityToggle;
  final bool isShowPrefixIcon;
  final bool readOnly;
  final bool enabled;
  final bool isDark;


  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {

  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontFamily: AppFonts.plusJakartaSans,
            fontSize: AppSizes.sp(14),
            fontWeight: FontWeight.w600,
            color:widget.isDark? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppSizes.h(8)),
        TextField(
          controller: widget.controller,
          obscureText: _obscure,
          keyboardType: widget.keyboardType,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          style: TextStyle(
            fontFamily: AppFonts.plusJakartaSans,
            fontSize: AppSizes.sp(14),
            fontWeight: FontWeight.w400,
            color:widget.isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(
              fontFamily: AppFonts.plusJakartaSans,
              fontSize: AppSizes.sp(14),
              color:widget.isDark ? AppColors.iconColorDark: AppColors.borderLight,
            ),
            prefixIcon:widget.isShowPrefixIcon ? Icon(
              widget.prefixIcon,
              color:widget.isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              size: AppSizes.iconSmall,
            ):null,
            suffixIcon: widget.showVisibilityToggle
                ? IconButton(
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color:widget.isDark ? AppColors.iconColorDark: AppColors.borderLight,
                      size: AppSizes.iconSmall,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  )
                : null,
            filled: true,
            fillColor:widget.isDark ?AppColors.authCardBackgroundDark : AppColors.white,
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSizes.w(16),
              vertical: AppSizes.h(14),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.w(12)),
              borderSide:  BorderSide(color:widget.isDark ? AppColors.borderDarkColor : AppColors.borderLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.w(12)),
              borderSide: const BorderSide(
                color: AppColors.primaryColor,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

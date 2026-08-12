import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/viewmodels/profile_view_model.dart';
import 'package:fluentta_ai/widgets/common/appbar_widget.dart';
import 'package:fluentta_ai/widgets/common/primary_button.dart';
import 'package:provider/provider.dart';

class ReminderTimeScreen extends StatefulWidget {
  const ReminderTimeScreen({super.key});

  @override
  State<ReminderTimeScreen> createState() => _ReminderTimeScreenState();
}

class _ReminderTimeScreenState extends State<ReminderTimeScreen> {
  FixedExtentScrollController? _hourController;
  FixedExtentScrollController? _minuteController;
  FixedExtentScrollController? _periodController;
  int _selectedHour = 8;
  int _selectedMinute = 0;
  bool _isPm = true;
  bool _initialized = false;

  void _initializeFromProfile() {
    if (_initialized) return;
    final profile = context.read<ProfileViewModel>();
    final time = profile.reminderTime;
    _selectedHour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    _selectedMinute = time.minute;
    _isPm = time.period == DayPeriod.pm;

    _hourController = FixedExtentScrollController(initialItem: _selectedHour - 1);
    _minuteController =
        FixedExtentScrollController(initialItem: _selectedMinute ~/ 5);
    _periodController = FixedExtentScrollController(initialItem: _isPm ? 1 : 0);
    _initialized = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeFromProfile();
  }

  @override
  void dispose() {
    _hourController?.dispose();
    _minuteController?.dispose();
    _periodController?.dispose();
    super.dispose();
  }

  TimeOfDay _buildTime() {
    var hour = _selectedHour % 12;
    if (_isPm) hour += 12;
    if (!_isPm && _selectedHour == 12) hour = 0;
    if (_isPm && _selectedHour == 12) hour = 12;
    return TimeOfDay(hour: hour, minute: _selectedMinute);
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;

    if (!_initialized) {
      return const Scaffold(
        backgroundColor: AppColors.scaffoldBackgroundColor,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: AppBarWidget(
        title: l10n.reminderTimeTitle,
        showBackButton: true,
        showActionButton: false,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
        child: Column(
          children: [
            SizedBox(height: AppSizes.h(16)),
            Image.asset(
              AppAssets.reminderTimeBird,
              height: AppSizes.h(150),
              fit: BoxFit.contain,
            ),
            SizedBox(height: AppSizes.h(10)),
            Text(
              l10n.reminderTimeTitle,
              style: TextStyle(
                fontFamily: AppFonts.plusJakartaSans,
                fontSize: AppSizes.sp(24),
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSizes.h(8)),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: AppSizes.spaceLg),
              child: Text(
                l10n.chooseReminderTime,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(15),
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            SizedBox(height: AppSizes.h(24)),
            Container(
              height: AppSizes.h(280),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppSizes.w(20)),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: AppSizes.h(44),
                    margin: EdgeInsets.symmetric(horizontal: AppSizes.w(16)),
                    decoration: BoxDecoration(
                      color: Color(0xfff6eefd), 
                      borderRadius: BorderRadius.circular(AppSizes.w(12)),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _WheelPicker(
                        controller: _hourController!,
                        itemCount: 12,
                        labelBuilder: (i) =>
                            (i + 1).toString().padLeft(2, '0'),
                        onSelected: (i) => setState(() => _selectedHour = i + 1),
                      ),
                      Text(
                        ' : ',
                        style: TextStyle(
                          fontFamily: AppFonts.plusJakartaSans,
                          fontSize: AppSizes.sp(22),
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      _WheelPicker(
                        controller: _minuteController!,
                        itemCount: 12,
                        labelBuilder: (i) =>
                            (i * 5).toString().padLeft(2, '0'),
                        onSelected: (i) =>
                            setState(() => _selectedMinute = i * 5),
                      ),
                      SizedBox(width: AppSizes.w(8)),
                      _WheelPicker(
                        controller: _periodController!,
                        itemCount: 2,
                        labelBuilder: (i) => i == 0 ? 'AM' : 'PM',
                        onSelected: (i) => setState(() => _isPm = i == 1),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            PrimaryButton(
              text: l10n.saveReminder,
              onPressed: () async {
                await context
                    .read<ProfileViewModel>()
                    .setReminderTime(_buildTime());
                if (context.mounted) Navigator.of(context).pop();
              },
            ),
            SizedBox(height: AppSizes.h(12)),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  l10n.cancelBtn,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(15),
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            SizedBox(height: AppSizes.h(24)),
          ],
        ),
      ),
    );
  }
}

class _WheelPicker extends StatelessWidget {
  const _WheelPicker({
    required this.controller,
    required this.itemCount,
    required this.labelBuilder,
    required this.onSelected,
  });

  final FixedExtentScrollController controller;
  final int itemCount;
  final String Function(int index) labelBuilder;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSizes.w(56),
      height: AppSizes.h(260),
      child: CupertinoPicker(
        scrollController: controller,
        itemExtent: AppSizes.h(44),
        magnification: 1.1,
        squeeze: 1.1,
        useMagnifier: true,
        onSelectedItemChanged: onSelected,
        selectionOverlay: const SizedBox.shrink(),
        children: List.generate(
          itemCount,
          (index) => Center(
            child: Text(
              labelBuilder(index),
              style: TextStyle(
                fontFamily: AppFonts.plusJakartaSans,
                fontSize: AppSizes.sp(28),
                fontWeight: FontWeight.w700,
                color: AppColors.primaryColor,

              ),
            ),
          ),
        ),
      ),
    );
  }
}

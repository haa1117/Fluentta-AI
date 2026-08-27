import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/viewmodels/profile_view_model.dart';
import 'package:fluentta_ai/viewmodels/main_shell_view_model.dart';
import 'package:fluentta_ai/views/home/home_tab_screen.dart';
import 'package:fluentta_ai/views/learn/learn_tab_screen.dart';
import 'package:fluentta_ai/views/profile/profile_tab_screen.dart';
import 'package:fluentta_ai/views/speak/speak_tab_screen.dart';
import 'package:fluentta_ai/widgets/common/app_bottom_nav_bar.dart';
import 'package:fluentta_ai/widgets/common/exit_app_dialog.dart';
import 'package:provider/provider.dart';

class MainShellScreen extends StatelessWidget {
  const MainShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MainShellViewModel()),
      ],
      child: const _MainShellBody(),
    );
  }
}

class _MainShellBody extends StatefulWidget {
  const _MainShellBody();

  @override
  State<_MainShellBody> createState() => _MainShellBodyState();
}

class _MainShellBodyState extends State<_MainShellBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ProfileViewModel>().bootstrapNotificationsOnAppOpen();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = context.watch<MainShellViewModel>().currentIndex;
    final shellViewModel = context.read<MainShellViewModel>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        if (shellViewModel.currentTab != MainTab.home) {
          shellViewModel.selectTab(MainTab.home);
          return;
        }

        showExitAppDialog(context);
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackgroundColor,
        body: IndexedStack(
          index: currentIndex,
          children: const [
            HomeTabScreen(),
            LearnTabScreen(),
            SpeakTabScreen(),
            ProfileTabScreen(),
          ],
        ),
        bottomNavigationBar: const AppBottomNavBar(),
      ),
    );
  }
}

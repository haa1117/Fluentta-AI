import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/viewmodels/home_view_model.dart';
import 'package:fluentta_ai/viewmodels/main_shell_view_model.dart';
import 'package:fluentta_ai/views/home/home_tab_screen.dart';
import 'package:fluentta_ai/views/learn/learn_tab_screen.dart';
import 'package:fluentta_ai/views/profile/profile_tab_screen.dart';
import 'package:fluentta_ai/views/speak/speak_tab_screen.dart';
import 'package:fluentta_ai/widgets/common/app_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class MainShellScreen extends StatelessWidget {
  const MainShellScreen({super.key, required this.localStorage});

  final LocalStorage localStorage;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MainShellViewModel()),
        ChangeNotifierProvider(
          create: (_) => HomeViewModel(localStorage),
        ),
      ],
      child: const _MainShellBody(),
    );
  }
}

class _MainShellBody extends StatelessWidget {
  const _MainShellBody();

  @override
  Widget build(BuildContext context) {
    final currentIndex = context.watch<MainShellViewModel>().currentIndex;

    return Scaffold(
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
    );
  }
}

import 'package:flutter/material.dart';

enum MainTab { home, learn, speak, profile }

class MainShellViewModel extends ChangeNotifier {
  MainTab _currentTab = MainTab.home;

  MainTab get currentTab => _currentTab;
  int get currentIndex => _currentTab.index;

  void selectTab(MainTab tab) {
    if (_currentTab == tab) return;
    _currentTab = tab;
    notifyListeners();
  }

  void selectIndex(int index) {
    selectTab(MainTab.values[index]);
  }
}

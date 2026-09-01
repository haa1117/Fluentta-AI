import 'package:flutter/material.dart';

class SetupOptionModel {
  const SetupOptionModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.svgIcon,
  });

  final String id;
  final String title;
  final String subtitle;
  final String svgIcon;
}

class SetupOptions {
  SetupOptions._();

  static const List<SetupOptionModel> englishGoals = [
    SetupOptionModel(
      id: 'travel',
      title: 'Travel',
      subtitle: 'Easy Local Conversation',
      svgIcon: 'assets/svg/flight.svg',
    ),
    SetupOptionModel(
      id: 'work',
      title: 'Work',
      subtitle: 'Master Workplace English',
      svgIcon: 'assets/svg/WORK.svg',
    ),
    SetupOptionModel(
      id: 'exam',
      title: 'Exam',
      subtitle: 'IELTS, TOEFL & Interviews',
      svgIcon: 'assets/svg/EXAM.svg',
    ),
    SetupOptionModel(
      id: 'everyday',
      title: 'Everyday English',
      subtitle: 'Practice natural conversation',
      svgIcon: 'assets/svg/flight.svg',
    ),
    // SetupOptionModel(
    //   id: 'travel',
    //   title: 'Travel',
    //   subtitle: 'Easy Local Conversation',
    //   svgIcon: 'assets/svg/flight.svg',
    // ),
  ];

  static const List<SetupOptionModel> englishLevels = [
    SetupOptionModel(
      id: 'beginner',
      title: 'Beginner',
      subtitle: 'A1 · New to English Basics',
      svgIcon: 'assets/svg/beginner.svg',
    ),
    SetupOptionModel(
      id: 'elementary',
      title: 'Elementary',
      subtitle: 'A2 · Can use simple words',
      svgIcon: 'assets/svg/elementary.svg',
    ),
    SetupOptionModel(
      id: 'intermediate',
      title: 'Intermediate',
      subtitle: 'B1 · Can hold simple conversation',
      svgIcon:'assets/svg/intermediatate.svg',
    ),
    SetupOptionModel(
      id: 'upper_intermediate',
      title: 'Upper-Intermediate',
      subtitle: 'B2 · Can interact with fluency',
      svgIcon: 'assets/svg/rocket.svg',
    ),
    SetupOptionModel(
      id: 'advanced_c1',
      title: 'Advanced',
      subtitle: 'C1 · Can express ideas fluently',
      svgIcon: 'assets/svg/rocket.svg',
    ),
    SetupOptionModel(
      id: 'proficient_c2',
      title: 'Proficient',
      subtitle: 'C2 · Near-native mastery',
      svgIcon: 'assets/svg/rocket.svg',
    ),
  ];

  static const List<SetupOptionModel> dailyGoals = [
    SetupOptionModel(
      id: '5',
      title: '5 minutes',
      subtitle: 'Perfect for busy days',
      svgIcon: 'assets/svg/time.svg',
    ),
    SetupOptionModel(
      id: '10',
      title: '10 Minutes',
      subtitle: 'Best for consistent progress',
      svgIcon: 'assets/svg/time.svg',
    ),
    SetupOptionModel(
      id: '15',
      title: '15 minutes',
      subtitle: 'Learn more with focused practice',
      svgIcon: 'assets/svg/time.svg',
    ),
    SetupOptionModel(
      id: '20',
      title: '20 minutes',
      subtitle: 'For faster improvement',
      svgIcon: 'assets/svg/time.svg',
    ),
  ];
}

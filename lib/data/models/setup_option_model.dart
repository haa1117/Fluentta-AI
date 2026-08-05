import 'package:flutter/material.dart';

class SetupOptionModel {
  const SetupOptionModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
}

class SetupOptions {
  SetupOptions._();

  static const List<SetupOptionModel> englishGoals = [
    SetupOptionModel(
      id: 'travel',
      title: 'Travel',
      subtitle: 'Easy Local Conversation',
      icon: Icons.flight_outlined,
    ),
    SetupOptionModel(
      id: 'work',
      title: 'Work',
      subtitle: 'Master Workplace English',
      icon: Icons.work_outline,
    ),
    SetupOptionModel(
      id: 'exam',
      title: 'Exam',
      subtitle: 'IELTS, TOEFL & Interviews',
      icon: Icons.description_outlined,
    ),
    SetupOptionModel(
      id: 'everyday',
      title: 'Everyday English',
      subtitle: 'Practice natural conversation',
      icon: Icons.chat_bubble_outline,
    ),
  ];

  static const List<SetupOptionModel> englishLevels = [
    SetupOptionModel(
      id: 'beginner',
      title: 'Beginner',
      subtitle: 'A1 · New to English Basics',
      icon: Icons.auto_awesome_outlined,
    ),
    SetupOptionModel(
      id: 'elementary',
      title: 'Elementary',
      subtitle: 'A2 · Can use simple words',
      icon: Icons.bar_chart_rounded,
    ),
    SetupOptionModel(
      id: 'intermediate',
      title: 'Intermediate',
      subtitle: 'B1 · Can hold simple conversation',
      icon: Icons.forum_outlined,
    ),
    SetupOptionModel(
      id: 'advanced',
      title: 'Advanced',
      subtitle: 'B2+ · Comfortable in most situations',
      icon: Icons.rocket_launch_outlined,
    ),
  ];

  static const List<SetupOptionModel> dailyGoals = [
    SetupOptionModel(
      id: '5',
      title: '5 minutes',
      subtitle: 'Perfect for busy days',
      icon: Icons.access_time,
    ),
    SetupOptionModel(
      id: '10',
      title: '10 Minutes',
      subtitle: 'Best for consistent progress',
      icon: Icons.access_time,
    ),
    SetupOptionModel(
      id: '15',
      title: '15 minutes',
      subtitle: 'Learn more with focused practice',
      icon: Icons.access_time,
    ),
    SetupOptionModel(
      id: '20',
      title: '20 minutes',
      subtitle: 'For faster improvement',
      icon: Icons.access_time,
    ),
  ];
}

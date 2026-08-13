import 'package:flutter/material.dart';

class RoleplayScenarioModel {
  const RoleplayScenarioModel({
    required this.id,
    required this.title,
    required this.icon,
    this.imagePath,
    this.progress = 0,
  });

  final String id;
  final String title;
  final IconData icon;
  final String? imagePath;
  final double progress;

  int get progressPercent => (progress * 100).round();
}

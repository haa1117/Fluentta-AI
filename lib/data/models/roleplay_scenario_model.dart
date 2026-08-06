import 'package:flutter/material.dart';

class RoleplayScenarioModel {
  const RoleplayScenarioModel({
    required this.id,
    required this.title,
    required this.icon,
    this.imagePath,
  });

  final String id;
  final String title;
  final IconData icon;
  final String? imagePath;
}

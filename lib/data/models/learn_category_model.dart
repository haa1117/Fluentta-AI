import 'package:flutter/material.dart';

class LearnCategoryModel {
  const LearnCategoryModel({
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

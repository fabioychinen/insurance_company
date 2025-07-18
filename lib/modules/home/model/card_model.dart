import 'package:flutter/material.dart';

class InsuranceCardModel {
  final String title;
  final IconData icon;
  final Color? color;
  final String? route;

  InsuranceCardModel({
    required this.title,
    required this.icon,
    this.color,
    this.route,
  });
}
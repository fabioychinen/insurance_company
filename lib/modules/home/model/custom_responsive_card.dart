import 'package:flutter/material.dart';
import '../../../shared/themes/app_theme.dart';

class CustomResponsiveCard extends StatelessWidget {
  final Widget child;

  const CustomResponsiveCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;
        return Container(
          margin: isWide ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.grey[700]!, width: 1.2),
          ),
          child: child,
        );
      },
    );
  }
}
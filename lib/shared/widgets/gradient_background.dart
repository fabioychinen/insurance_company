import 'package:flutter/material.dart';
import 'package:insurance_company/shared/themes/app_theme.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  final Widget? footer;
  final Widget? header;

  const GradientBackground({
    super.key,
    required this.child,
    this.footer,
    this.header,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        _buildBackground(height),
        if (header != null) _buildHeader(),
        _buildCenterContent(),
        if (footer != null) _buildFooter(),
      ],
    );
  }

  Widget _buildBackground(double height) {
    return Column(
      children: [
        Container(
          height: height * 0.47,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryGreen, AppColors.primaryYellow],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: AppColors.primaryDark,
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Positioned(
      top: 60,
      left: 0,
      right: 0,
      child: header!,
    );
  }

  Widget _buildCenterContent() {
    return Align(
      alignment: const Alignment(0, -0.18),
      child: child,
    );
  }

  Widget _buildFooter() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 40,
      child: footer!,
    );
  }
}
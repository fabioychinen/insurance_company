import 'package:flutter/material.dart';
import '../../../app/core/constants/app_strings.dart';
import '../../../shared/themes/app_theme.dart';
import 'insurance_webview.dart';

class InsuranceCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const InsuranceCard({
    super.key,
    required this.title,
    required this.icon,
  });

  void _handleTap(BuildContext context) {
    if (title == AppStrings.car) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WebViewPage(
            url: 'https://www.portoseguro.com.br/seguro-auto',
            title: 'Seguro Automóvel',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleTap(context),
      child: Container(
        constraints: const BoxConstraints(
          minWidth: 100,
          maxWidth: 140,
          minHeight: 90,
        ),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey[700]!, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardDark.withValues(alpha: 1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [AppColors.primaryGreen, AppColors.primaryYellow],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(Rect.fromLTWH(0, 0, 40, 40)),
              child: Icon(
                icon,
                color: Colors.white,
                size: 36,
              ),
            ),
            const SizedBox(height: 10),
            Flexible(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  shadows: [
                    Shadow(
                      blurRadius: 2,
                      color: Colors.black26,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

import '../../../app/core/constants/app_strings.dart';
import '../../../shared/themes/app_theme.dart';
import '../view/home_page.dart';

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
          builder: (_) => const WebViewPage(
            url: 'https://jsonplaceholder.typicode.com/',
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
          gradient: const LinearGradient(
            colors: [AppColors.primaryGreen, AppColors.primaryYellow],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, 
              color: Colors.white,
              size: 32),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  shadows: [
                    Shadow(
                      blurRadius: 2,
                      color: Colors.black45,
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
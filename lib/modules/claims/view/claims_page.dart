import 'package:flutter/material.dart';
import '../../../app/core/constants/app_strings.dart';

class ClaimsPage extends StatelessWidget {
  const ClaimsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.drawerClaims),
      ),
      body: const Center(
        child: Text(
          'Claims Page',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
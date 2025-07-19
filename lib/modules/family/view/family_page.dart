import 'package:flutter/material.dart';
import '../../../app/core/constants/app_strings.dart';

class FamilyPage extends StatelessWidget {
  const FamilyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.drawerFamily),
      ),
      body: const Center(
        child: Text(
          'Family Page',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
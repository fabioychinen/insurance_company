import 'package:flutter/material.dart';
import '../../../app/core/constants/app_strings.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.drawerSettings),
      ),
      body: const Center(
        child: Text(
          'Settings Page',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
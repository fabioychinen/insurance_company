import 'package:flutter/material.dart';
import '../../../app/core/constants/app_strings.dart';

class AssetsPage extends StatelessWidget {
  const AssetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.drawerAssets),
      ),
      body: const Center(
        child: Text(
          'Assets Page',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
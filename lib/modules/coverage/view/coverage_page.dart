import 'package:flutter/material.dart';
import '../../../app/core/constants/app_strings.dart';

class CoveragePage extends StatelessWidget {
  const CoveragePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.drawerCoverage),
      ),
      body: const Center(
        child: Text(
          'Coverage Page',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
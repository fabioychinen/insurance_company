import 'package:flutter/material.dart';
import '../../../app/core/constants/app_strings.dart';

class ContractsPage extends StatelessWidget {
  const ContractsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.drawerContracts),
      ),
      body: const Center(
        child: Text(
          'Contracts Page',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
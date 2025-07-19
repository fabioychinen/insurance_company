import 'package:flutter/material.dart';
import '../../../app/core/constants/app_strings.dart';

class PaymentsPage extends StatelessWidget {
  const PaymentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.drawerPayments),
      ),
      body: const Center(
        child: Text(
          'Payments Page',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

import '../../../app/core/constants/app_strings.dart';

class ValidateInvoicePage extends StatelessWidget {
  const ValidateInvoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.drawerValidateInvoice),
      ),
      body: const Center(
        child: Text(AppStrings.drawerValidateInvoice),
      ),
    );
  }
}
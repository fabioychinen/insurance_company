import 'package:flutter/material.dart';
import '../../../app/core/constants/app_strings.dart';

class ImportantPhonesPage extends StatelessWidget {
  const ImportantPhonesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.drawerImportantPhones),
      ),
      body: const Center(
        child: Text(
          'Important Phones Page',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
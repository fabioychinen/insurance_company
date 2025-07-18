import 'package:flutter/material.dart';
import '../../../shared/widgets/custom_drawer.dart';
import '../../../app/core/constants/app_strings.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  final String userName = "Usuário";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${AppStrings.greeting}, $userName")),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(),
            const SizedBox(height: 12),
            _buildInsuranceOptions(),
            const SizedBox(height: 24),
            _buildFamilySection(),
            const SizedBox(height: 24),
            _buildContractsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      AppStrings.quoteAndHire,
      style: TextStyle(fontSize: 18),
    );
  }

  Widget _buildInsuranceOptions() {
    const insuranceCards = [
      InsuranceCard(title: AppStrings.car, icon: Icons.directions_car),
      InsuranceCard(title: AppStrings.residence, icon: Icons.home),
      InsuranceCard(title: AppStrings.life, icon: Icons.favorite),
      InsuranceCard(title: AppStrings.accidents, icon: Icons.health_and_safety),
    ];

    return const Wrap(
      spacing: 16,
      runSpacing: 16,
      children: insuranceCards,
    );
  }

  Widget _buildFamilySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(AppStrings.family),
        ElevatedButton(
          onPressed: () {},
          child: const Text(AppStrings.addMember),
        ),
      ],
    );
  }

  Widget _buildContractsSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.contracted),
        Text(AppStrings.noInsurance),
      ],
    );
  }
}

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
      child: SizedBox(
        width: 150,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Icon(icon, size: 48),
                const SizedBox(height: 8),
                Text(title),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WebViewPage extends StatelessWidget {
  final String url;

  const WebViewPage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.webViewTitle)),
      body: Center(child: Text("${AppStrings.openWebView}$url")),
    );
  }
}
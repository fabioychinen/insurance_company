import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/widgets/custom_drawer.dart';
import '../../../app/core/constants/app_strings.dart';
import '../../family/view/family_page.dart';
import '../viewmodel/home_bloc.dart';
import '../viewmodel/home_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final userName = (state.userName).isNotEmpty
            ? state.userName
            : AppStrings.defaultUserName;

        return Scaffold(
          appBar: AppBar(
            title: Text('${AppStrings.greeting}, $userName'),
          ),
          drawer: const CustomDrawer(),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 900;
              final isTablet = constraints.maxWidth > 700 && constraints.maxWidth <= 900;

              final maxWidth = isWide ? 1100 : isTablet ? 800 : double.infinity;
              final scale = isWide ? 1.3 : isTablet ? 1.15 : 1.0;

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxWidth.toDouble()),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTitle(scale),
                          const SizedBox(height: 12),
                          _buildInsuranceOptions(context, isWide, isTablet, scale),
                          const SizedBox(height: 24),
                          _buildFamilySection(context, scale),
                          const SizedBox(height: 24),
                          _buildContractsSection(scale),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTitle(double scale) {
    return Text(
      AppStrings.quoteAndHire,
      style: TextStyle(fontSize: 18 * scale, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildInsuranceOptions(BuildContext context, bool isWide, bool isTablet, double scale) {
    const insuranceCards = [
      InsuranceCard(title: AppStrings.car, icon: Icons.directions_car),
      InsuranceCard(title: AppStrings.residence, icon: Icons.home),
      InsuranceCard(title: AppStrings.life, icon: Icons.favorite),
      InsuranceCard(title: AppStrings.accidents, icon: Icons.health_and_safety),
    ];

    if (isWide) {
      // Desktop grande: Grid
      return GridView.count(
        crossAxisCount: 4,
        childAspectRatio: 1.2,
        shrinkWrap: true,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        physics: const NeverScrollableScrollPhysics(),
        children: insuranceCards
            .map((card) => Center(child: SizedBox(width: 210, child: card)))
            .toList(),
      );
    }
    if (isTablet) {
      // Tablet: Grid com 2 colunas
      return GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        shrinkWrap: true,
        mainAxisSpacing: 18,
        crossAxisSpacing: 18,
        physics: const NeverScrollableScrollPhysics(),
        children: insuranceCards
            .map((card) => Center(child: SizedBox(width: 180, child: card)))
            .toList(),
      );
    }
    // Mobile: Wrap
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: insuranceCards
          .map((card) => SizedBox(width: 150, child: card))
          .toList(),
    );
  }

  Widget _buildFamilySection(BuildContext context, double scale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.family,
          style: TextStyle(fontSize: 16 * scale, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const FamilyPage(),
              ),
            );
          },
          child: Text(AppStrings.addMember, style: TextStyle(fontSize: 15 * scale)),
        ),
      ],
    );
  }

  Widget _buildContractsSection(double scale) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final contracts = state.contractedInsurances;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.contracted,
              style: TextStyle(fontSize: 16 * scale, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 6),
            contracts.isEmpty
                ? Text(AppStrings.noInsurance, style: TextStyle(fontSize: 14 * scale))
                : Column(
                    children: contracts
                        .map<Widget>(
                          (contract) => ListTile(
                            title: Text(
                              contract is Map && contract['title'] != null
                                  ? contract['title'].toString()
                                  : contract.toString(),
                              style: TextStyle(fontSize: 14 * scale),
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ],
        );
      },
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
    final isWide = MediaQuery.of(context).size.width > 900;
    final scale = isWide ? 1.3 : MediaQuery.of(context).size.width > 700 ? 1.15 : 1.0;

    return GestureDetector(
      onTap: () => _handleTap(context),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16.0 * scale),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48 * scale),
              SizedBox(height: 8 * scale),
              Text(title, style: TextStyle(fontSize: 16 * scale)),
            ],
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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/core/constants/app_images.dart';
import '../../../shared/themes/app_theme.dart';
import '../../../shared/widgets/custom_drawer.dart';
import '../../../app/core/constants/app_strings.dart';
import '../../family/view/family_page.dart';
import '../model/card_model.dart';
import '../model/custom_responsive_card.dart';
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
          backgroundColor: AppColors.primaryDark,
          drawer: const CustomDrawer(),
          appBar: AppBar(
            backgroundColor: AppColors.primaryDark,
            elevation: 0,
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            title: Image.asset(
              AppImages.logo,
              height: 80,
              fit: BoxFit.contain,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
          body: Column(
            children: [
              _buildUserHeader(context, userName),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 22),
                      _buildSectionTitle(AppStrings.quoteAndHire),
                      const SizedBox(height: 10),
                      _buildInsuranceOptions(context),
                      const SizedBox(height: 28),
                      _buildSectionTitle(AppStrings.family),
                      _buildFamilySection(context),
                      const SizedBox(height: 28),
                      _buildSectionTitle(AppStrings.contracted),
                      _buildContractsSection(),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUserHeader(BuildContext context, String userName) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryGreen, AppColors.primaryYellow],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: AppColors.primaryDark, size: 30),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                AppStrings.welcome,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  letterSpacing: 0.2,
                ),
              ),
              Text(
                userName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 6),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildInsuranceOptions(BuildContext context) {
    final cards = [
      InsuranceCard(title: AppStrings.car, icon: Icons.directions_car),
      InsuranceCard(title: AppStrings.residence, icon: Icons.home),
      InsuranceCard(title: AppStrings.life, icon: Icons.favorite),
      InsuranceCard(title: AppStrings.accidents, icon: Icons.health_and_safety),
      InsuranceCard(title: AppStrings.heritage, icon: Icons.apartment),
      InsuranceCard(title: AppStrings.company, icon: Icons.business),
    ];

    final isWide = MediaQuery.of(context).size.width > 900;

    if (isWide) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: cards
              .map((card) => Padding(
                    padding: const EdgeInsets.only(right: 24),
                    child: SizedBox(width: 140, height: 90, child: card),
                  ))
              .toList(),
        ),
      );
    }

    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: cards.length,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) =>
            SizedBox(width: 110, child: cards[index]),
      ),
    );
  }

  Widget _buildFamilySection(BuildContext context) {
    return CustomResponsiveCard(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const FamilyPage(),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Column(
            children: const [
              Icon(Icons.add_circle_outline, color: Colors.white, size: 38),
              SizedBox(height: 6),
              Text(
                'Adicione aqui membros da sua família\ne compartilhe os seguros com eles.',
                style: TextStyle(color: Colors.white60, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContractsSection() {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final contracts = state.contractedInsurances;
        return CustomResponsiveCard(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: contracts.isEmpty
                ? Column(
                    children: const [
                      Icon(Icons.sentiment_dissatisfied,
                          color: Colors.white, size: 34),
                      SizedBox(height: 8),
                      Text(
                        'Você ainda não possui seguros contratados.',
                        style: TextStyle(color: Colors.white54, fontSize: 15),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                : Column(
                    children: contracts
                        .map<Widget>(
                          (contract) => ListTile(
                            title: Text(
                              contract is Map && contract['title'] != null
                                  ? contract['title'].toString()
                                  : contract.toString(),
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ),
        );
      },
    );
  }
}
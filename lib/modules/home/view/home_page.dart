import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/core/bloc/post_bloc.dart';
import '../../../app/core/constants/app_images.dart';
import '../../../app/core/models/post_model.dart';
import '../../../shared/themes/app_theme.dart';
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
      InsuranceCard(title: 'Patrimônio', icon: Icons.apartment),
      InsuranceCard(title: 'Empresa', icon: Icons.business),
    ];

    final double width = MediaQuery.of(context).size.width;

    if (width > 1000) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1050),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cards.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                mainAxisExtent: 110,
                crossAxisSpacing: 24,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) => cards[index],
            ),
          ),
        ),
      );
    } else if (width > 700) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cards.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisExtent: 110,
                crossAxisSpacing: 18,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) => cards[index],
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: cards.length,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) => SizedBox(width: 110, child: cards[index]),
      ),
    );
  }

  Widget _buildFamilySection(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(18),
      ),
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
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: contracts.isEmpty
                ? Column(
                    children: const [
                      Icon(Icons.sentiment_dissatisfied, color: Colors.white, size: 34),
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

class InsuranceCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const InsuranceCard({
    super.key,
    required this.title,
    required this.icon,
  });

  Future<void> _handleTap(BuildContext context) async {
    if (title == AppStrings.car) {
      final postBloc = context.read<PostBloc>();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Carregando dados...')),
      );

      try {
        await postBloc.fetchPosts();
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WebViewPage(
              url: 'https://jsonplaceholder.typicode.com/posts',
              posts: postBloc.state is PostLoaded 
                  ? (postBloc.state as PostLoaded).posts
                  : [],
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleTap(context),
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey[700]!, width: 1.2),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primaryGreen, size: 40),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class WebViewPage extends StatelessWidget {
  final String url;
  final List<Post> posts;

  const WebViewPage({
    super.key,
    required this.url,
    this.posts = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.webViewTitle)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return ListTile(
                  title: Text(post.title),
                  subtitle: Text(post.body),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('URL: $url'),
          ),
        ],
      ),
    );
  }
}
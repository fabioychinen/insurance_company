import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurance_company/shared/themes/app_theme.dart';
import '../../../app/core/constants/app_strings.dart';
import '../../app/core/constants/app_images.dart';
import '../../app/core/services/firebase_repository_impl.dart';
import '../../app/routes/app_routes.dart';
import '../../modules/home/viewmodel/home_bloc.dart';
import '../../modules/home/viewmodel/home_state.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;
    final iconSize = isWide ? 28.0 : 22.0;
    final fontSize = isWide ? 18.0 : 15.0;

    return Drawer(
      width: isWide ? 320 : null,
      backgroundColor: AppColors.primaryDark,
      child: Column(
        children: [
          _buildHeader(context, fontSize),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: [
                ..._drawerItems(context, iconSize, fontSize),
                const Divider(color: Colors.white24, height: 28),
                _buildLogoutTile(context, iconSize, fontSize),
              ],
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double fontSize) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final userName = state.userName.isNotEmpty
            ? state.userName
            : AppStrings.drawerUserName;
        final userEmail = state.userEmail.isNotEmpty
            ? state.userEmail
            : AppStrings.drawerUserEmail;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 18),
          decoration: const BoxDecoration(
            color: AppColors.primaryDark,
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: AppColors.primaryDark, size: 34),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.greeting,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 9),
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      userName.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                      ),
                    ),
                    Text(
                      userEmail,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _drawerItems(BuildContext context, double iconSize, double fontSize) {
    return [
      _buildDrawerItem(context, Icons.home, AppStrings.drawerHome, AppRoutes.home, iconSize, fontSize),
      _buildDrawerItem(context, Icons.assignment, AppStrings.drawerContracts, AppRoutes.contracts, iconSize, fontSize),
      _buildDrawerItem(context, Icons.car_crash, AppStrings.drawerClaims, AppRoutes.claims, iconSize, fontSize),
      _buildDrawerItem(context, Icons.family_restroom, AppStrings.drawerFamily, AppRoutes.family, iconSize, fontSize),
      _buildDrawerItem(context, Icons.home_work, AppStrings.drawerAssets, AppRoutes.assets, iconSize, fontSize),
      _buildDrawerItem(context, Icons.payment, AppStrings.drawerPayments, AppRoutes.payments, iconSize, fontSize),
      _buildDrawerItem(context, Icons.verified_user, AppStrings.drawerCoverage, AppRoutes.coverage, iconSize, fontSize),
      _buildDrawerItem(context, Icons.qr_code, AppStrings.drawerValidateInvoice, AppRoutes.validateInvoice, iconSize, fontSize),
      _buildDrawerItem(context, Icons.phone, AppStrings.drawerImportantPhones, AppRoutes.importantPhones, iconSize, fontSize),
      _buildDrawerItem(context, Icons.settings, AppStrings.drawerSettings, AppRoutes.settings, iconSize, fontSize),
    ];
  }

  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String title,
    String route,
    double iconSize,
    double fontSize,
  ) {
    return ListTile(
      leading: Icon(icon, size: iconSize, color: AppColors.primaryGreen),
      title: Text(title, style: TextStyle(fontSize: fontSize, color: Colors.white)),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(route);
      },
    );
  }

  Widget _buildLogoutTile(BuildContext context, double iconSize, double fontSize) {
    return ListTile(
      leading: Icon(Icons.exit_to_app, size: iconSize, color: AppColors.primaryGreen),
      title: Text(
        AppStrings.drawerLogout,
        style: TextStyle(fontSize: fontSize, color: Colors.white),
      ),
      onTap: () async {
        await FirebaseRepositoryImpl().logout();
        if (!context.mounted) return;
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.of(context).pushReplacementNamed(AppRoutes.login);
      },
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryGreen, AppColors.primaryYellow],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(
        children: [
          ClipRRect(
            child: Image.asset(
              AppImages.logo,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Seguro digital',
                  style: TextStyle(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Tenha proteção e praticidade na palma da mão.',
                  style: TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 11,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
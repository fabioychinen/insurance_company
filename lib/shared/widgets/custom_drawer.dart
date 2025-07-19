import 'package:flutter/material.dart';
import '../../../app/core/constants/app_strings.dart';
import '../../app/routes/app_routes.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final userName = AppStrings.drawerUserName;
    final userEmail = AppStrings.drawerUserEmail;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(userName),
            accountEmail: Text(userEmail),
            currentAccountPicture: const CircleAvatar(
              child: Icon(Icons.person, size: 40),
            ),
          ),
          _buildDrawerItem(context, Icons.home, AppStrings.drawerHome, AppRoutes.home),
          _buildDrawerItem(context, Icons.assignment, AppStrings.drawerContracts, AppRoutes.contracts),
          _buildDrawerItem(context, Icons.car_crash, AppStrings.drawerClaims, AppRoutes.claims),
          _buildDrawerItem(context, Icons.family_restroom, AppStrings.drawerFamily, AppRoutes.family),
          _buildDrawerItem(context, Icons.home_work, AppStrings.drawerAssets, AppRoutes.assets),
          _buildDrawerItem(context, Icons.payment, AppStrings.drawerPayments, AppRoutes.payments),
          _buildDrawerItem(context, Icons.verified_user, AppStrings.drawerCoverage, AppRoutes.coverage),
          _buildDrawerItem(context, Icons.qr_code, AppStrings.drawerValidateInvoice, AppRoutes.validateInvoice),
          _buildDrawerItem(context, Icons.phone, AppStrings.drawerImportantPhones, AppRoutes.importantPhones),
          _buildDrawerItem(context, Icons.settings, AppStrings.drawerSettings, AppRoutes.settings),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text(AppStrings.drawerLogout),
            onTap: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String title, String route) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(route);
      },
    );
  }
}
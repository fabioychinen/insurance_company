import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/core/constants/app_strings.dart';
import '../../app/core/services/firebase_repository_impl.dart';
import '../../app/routes/app_routes.dart';
import '../../modules/home/viewmodel/home_bloc.dart';
import '../../modules/home/viewmodel/home_state.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 800;
        final iconSize = isWide ? 32.0 : 24.0;
        final fontSize = isWide ? 20.0 : 16.0;

        return Drawer(
          width: isWide ? 320 : null, 
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  final userName = (state.userName.isNotEmpty)
                    ? state.userName
                    : AppStrings.drawerUserName;
                  final userEmail = (state.userEmail.isNotEmpty)
                    ? state.userEmail
                    : AppStrings.drawerUserEmail;

                  return UserAccountsDrawerHeader(
                    accountName: Text(userName, style: TextStyle(fontSize: fontSize)),
                    accountEmail: Text(userEmail, style: TextStyle(fontSize: fontSize - 2)),
                    currentAccountPicture: CircleAvatar(
                      radius: iconSize,
                      child: Icon(Icons.person, size: iconSize + 8),
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    margin: EdgeInsets.zero,
                  );
                },
              ),
              ..._drawerItems(context, iconSize, fontSize),
              const Divider(),
              ListTile(
                // leading: Icon(Icons.exit_to_app, size: iconSize),
                title: Text(AppStrings.drawerLogout, style: TextStyle(fontSize: fontSize)),
                onTap: () async {
                  await FirebaseRepositoryImpl().logout();
                  if (!context.mounted) return; 
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.of(context).pushReplacementNamed(AppRoutes.login);
                },
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

  Widget _buildDrawerItem(BuildContext context, IconData icon, String title, String route, double iconSize, double fontSize) {
    return ListTile(
      leading: Icon(icon, size: iconSize),
      title: Text(title, style: TextStyle(fontSize: fontSize)),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(route);
      },
    );
  }
}
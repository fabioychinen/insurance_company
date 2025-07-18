import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final userName = "Usuário Exemplo";
    final userEmail = "exemplo@email.com";

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
          _buildDrawerItem(context, Icons.home, "Home / Seguros", "/home"),
          _buildDrawerItem(context, Icons.assignment, "Minhas Contratações", "/contratacoes"),
          _buildDrawerItem(context, Icons.car_crash, "Meus Sinistros", "/sinistros"),
          _buildDrawerItem(context, Icons.family_restroom, "Minha Família", "/familia"),
          _buildDrawerItem(context, Icons.home_work, "Meus Bens", "/bens"),
          _buildDrawerItem(context, Icons.payment, "Pagamentos", "/pagamentos"),
          _buildDrawerItem(context, Icons.verified_user, "Coberturas", "/coberturas"),
          _buildDrawerItem(context, Icons.qr_code, "Validar Boleto", "/boleto"),
          _buildDrawerItem(context, Icons.phone, "Telefones Importantes", "/telefones"),
          _buildDrawerItem(context, Icons.settings, "Configurações", "/configuracoes"),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text("Sair"),
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
      },
    );
  }
}
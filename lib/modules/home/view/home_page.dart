import 'package:flutter/material.dart';
import '../../../shared/widgets/custom_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userName = "Usuário";

    return Scaffold(
      appBar: AppBar(title: Text("Olá, $userName")),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Cotar e Contratar", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: const [
                InsuranceCard(title: "Automóvel", icon: Icons.directions_car),
                InsuranceCard(title: "Residência", icon: Icons.home),
                InsuranceCard(title: "Vida", icon: Icons.favorite),
                InsuranceCard(title: "Acidentes", icon: Icons.health_and_safety),
              ],
            ),
            const SizedBox(height: 24),
            const Text("Minha Família"),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Adicionar Membro"),
            ),
            const SizedBox(height: 24),
            const Text("Contratados"),
            const Text("Você ainda não contratou nenhum seguro."),
          ],
        ),
      ),
    );
  }
}

class InsuranceCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const InsuranceCard({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (title == "Automóvel") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const WebViewPage(
                url: 'https://jsonplaceholder.typicode.com/',
              ),
            ),
          );
        }
      },
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
      appBar: AppBar(title: const Text("WebView")),
      body: Center(
        child: Text("Abriria aqui: $url"),
      ),
    );
  }
}
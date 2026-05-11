import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppView extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const AppView({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      appBar: _appBarWidget(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        indicatorColor: Colors.transparent,
        onDestinationSelected: navigationShell.goBranch,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Ana Sayfa'),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Kasa',
          ),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
        ], // Seçilen sekmeye göre işlemler yapılabilir
      ),
    );
  }

  AppBar _appBarWidget() {
    return AppBar(
      title: const Text('Değerli Madenler ve Kasa Sistemi'),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            // Ayarlar sayfasına yönlendirme işlemi
          },
        ),
      ],
    );
  }
}

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
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: WidgetStateTextStyle.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return TextStyle(color: Theme.of(context).colorScheme.primary);
            }
            return TextStyle(color: Theme.of(context).colorScheme.tertiary);
          }),
        ),
        child: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          indicatorColor: Colors.transparent,
          onDestinationSelected: navigationShell.goBranch,
          destinations: [
            _menuItem(
              context,
              index: 0,
              currentIndex: navigationShell.currentIndex,
              label: 'Ana Sayfa',
              icon: Icons.home,
            ),
            _menuItem(
              context,
              index: 1,
              currentIndex: navigationShell.currentIndex,
              label: 'Kasa',
              icon: Icons.account_balance_wallet,
            ),
            _menuItem(
              context,
              index: 2,
              currentIndex: navigationShell.currentIndex,
              label: 'Profil',
              icon: Icons.person,
            ),
          ], // Seçilen sekmeye göre işlemler yapılabilir
        ),
      ),
    );
  }

  Widget _menuItem(
    BuildContext context, {
    required int index,
    required int currentIndex,
    required String label,
    required IconData icon,
  }) {
    return NavigationDestination(
      icon: Icon(
        icon,
        color: currentIndex == index
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.tertiary,
      ),
      label: label,
    );
  }

  AppBar _appBarWidget() {
    return AppBar(
      title: const Text('Değerli Madenler ve Kasa Sistemi'),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.settings,
            color: Color.fromARGB(255, 218, 197, 16),
          ),
          onPressed: () {
            // Ayarlar sayfasına yönlendirme işlemi
          },
        ),
      ],
    );
  }
}

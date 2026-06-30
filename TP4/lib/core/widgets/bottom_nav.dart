import 'package:flutter/material.dart';

import '../../app/app_routes.dart';
import '../../app/app_state.dart';

class PortoBottomNav extends StatelessWidget {
  const PortoBottomNav({super.key, required this.active, required this.nav});

  final AppScreen active;
  final AppNavigator nav;

  @override
  Widget build(BuildContext context) {
    final currentIndex = switch (active) {
      AppScreen.search || AppScreen.results => 1,
      AppScreen.favorites => 2,
      AppScreen.profile => 3,
      _ => 0,
    };

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        final target = switch (index) {
          0 => AppScreen.home,
          1 => AppScreen.search,
          2 => AppScreen.favorites,
          _ => AppScreen.profile,
        };
        nav(target);
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Início',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          activeIcon: Icon(Icons.favorite),
          label: 'Favoritos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
    );
  }
}

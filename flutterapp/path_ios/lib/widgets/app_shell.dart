import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  int _indexForLocation(String location) {
    if (location == '/home' || location == '/' || location.startsWith('/home')) return 0;
    if (location.startsWith('/resources')) return 1;
    if (location.startsWith('/my-resources')) return 2;
    if (location.startsWith('/my-paths') || location.startsWith('/createpath') || location.startsWith('/learningpath')) return 3;
    if (location.startsWith('/account')) return 4;
    return 0;
  }

  void _goForIndex(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/resources');
        break;
      case 2:
        context.go('/my-resources');
        break;
      case 3:
        context.go('/my-paths');
        break;
      case 4:
        context.go('/account/user-info');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final idx = _indexForLocation(location);

    return Scaffold(
      body: SafeArea(child: child),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: idx,
        onTap: (i) => _goForIndex(context, i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), activeIcon: Icon(Icons.explore), label: 'Resources'),
          BottomNavigationBarItem(icon: Icon(Icons.collections_bookmark_outlined), activeIcon: Icon(Icons.collections_bookmark), label: 'My'),
          BottomNavigationBarItem(icon: Icon(Icons.route_outlined), activeIcon: Icon(Icons.route), label: 'Paths'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}

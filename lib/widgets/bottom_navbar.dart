import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:base42_events_mobile/nav.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({super.key, required this.child});

  final Widget child;

  static const _routes = [AppRoutes.events, AppRoutes.home, AppRoutes.profile];

  int _calculateCurrentIndex(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;
    final index = _routes.indexOf(location);
    return index == -1 ? 0 : index;
  }

  void _onItemTap(BuildContext context, int index) {
    context.go(_routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        unselectedItemColor: Theme.of(context).colorScheme.primary,
        selectedItemColor: Colors.white,
        currentIndex: _calculateCurrentIndex(context),
        onTap: (index) => _onItemTap(context, index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

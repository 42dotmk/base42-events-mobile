import 'package:base42_events_mobile/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:base42_events_mobile/nav.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({super.key, required this.child});

  final Widget child;

  static const List<_NavItem> _items = [
    _NavItem(route: AppRoutes.home, icon: Icons.home_outlined, label: 'Home'),
    _NavItem(
      route: AppRoutes.events,
      icon: Icons.calendar_month_outlined,
      label: 'Events',
    ),
    _NavItem(
      route: AppRoutes.book,
      icon: Icons.add_rounded,
      label: 'Book',
      isCenter: true,
    ),
    _NavItem(icon: Icons.coffee_outlined, label: 'Cafe'),
    _NavItem(
      route: AppRoutes.profile,
      icon: Icons.person_outline_rounded,
      label: 'Profile',
    ),
  ];

  int _calculateCurrentIndex(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;

    if (location == AppRoutes.home) return 0;
    if (location == AppRoutes.events || location.startsWith('/event/')) {
      return 1;
    }
    if (location == AppRoutes.book) return 2;
    if (location == AppRoutes.profile) return 4;

    return 0;
  }

  void _onItemTap(BuildContext context, _NavItem item) {
    if (item.route != null) {
      context.go(item.route!);
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${item.label} is coming soon')));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final brand = Theme.of(context).extension<BrandTheme>();
    final activeColor = brand?.neonYellow ?? colorScheme.secondary;
    final inactiveColor = Colors.white.withValues(alpha: 0.35);
    final currentIndex = _calculateCurrentIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          height: 84,
          decoration: BoxDecoration(
            color: const Color(0xFF091018).withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(0),
          ),
          child: Row(
            children: _items.map((item) {
              final isCenter = item.isCenter;
              final isActive = _items.indexOf(item) == currentIndex;

              if (isCenter) {
                return Expanded(
                  child: Center(
                    child: Transform.translate(
                      offset: const Offset(0, -16),
                      child: GestureDetector(
                        onTap: () => _onItemTap(context, item),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 54,
                              height: 54,
                              decoration: BoxDecoration(
                                color: activeColor,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: activeColor.withValues(alpha: 0.35),
                                    blurRadius: 18,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Icon(
                                item.icon,
                                color: const Color(0xFF0B1020),
                                size: 30,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.label,
                              style: context.textStyles.labelSmall?.medium
                                  .withColor(activeColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }

              return Expanded(
                child: InkWell(
                  onTap: () => _onItemTap(context, item),
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (isActive)
                          Positioned(
                            top: 0,
                            child: Container(
                              width: 28,
                              height: 2,
                              decoration: BoxDecoration(
                                color: activeColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              item.icon,
                              size: isActive ? 24 : 22,
                              color: isActive ? activeColor : inactiveColor,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              item.label,
                              style: context.textStyles.labelSmall?.withColor(
                                isActive ? activeColor : inactiveColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final String? route;
  final IconData icon;
  final String label;
  final bool isCenter;

  const _NavItem({
    this.route,
    required this.icon,
    required this.label,
    this.isCenter = false,
  });
}

// import 'package:flutter/material.dart';
import 'package:base42_events_mobile/screens/home_screen.dart';
import 'package:base42_events_mobile/screens/profile_screen.dart';
import 'package:base42_events_mobile/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:base42_events_mobile/screens/event_list_screen.dart';
import 'package:base42_events_mobile/screens/event_details_screen.dart';
import 'package:base42_events_mobile/models/event.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.home,
    navigatorKey: _rootNavigatorKey,
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return BottomNavigationBarWidget(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoutes.home,
            name: 'home',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: HomeScreen()),
          ),
          GoRoute(
            path: AppRoutes.events,
            name: 'events',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: EventListScreen()),
          ),
          GoRoute(
            path: AppRoutes.eventDetails,
            name: 'eventDetails',
            pageBuilder: (context, state) {
              final event = state.extra as Event;
              return NoTransitionPage(child: EventDetailsScreen(event: event));
            },
          ),
          GoRoute(
            path: AppRoutes.profile,
            name: 'profile',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ProfileScreen()),
          ),
        ],
      ),
    ],
  );
}

class AppRoutes {
  static const String home = '/';
  static const String events = '/events';
  static const String profile = '/profile';
  static const String eventDetails = '/event/:id';
}

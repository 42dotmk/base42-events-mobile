import 'package:base42_events_mobile/models/event.dart';
import 'package:base42_events_mobile/providers/auth_provider.dart';
import 'package:base42_events_mobile/screens/event_details_screen.dart';
import 'package:base42_events_mobile/screens/event_list_screen.dart';
import 'package:base42_events_mobile/screens/home_screen.dart';
import 'package:base42_events_mobile/screens/profile_screen.dart';
import 'package:base42_events_mobile/screens/settings_screen.dart';
import 'package:base42_events_mobile/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  final AuthProvider authProvider;

  AppRouter(this.authProvider);

  late final GoRouter router = GoRouter(
    initialLocation: AppRoutes.home,
    navigatorKey: _rootNavigatorKey,
    refreshListenable: authProvider,
    redirect: (context, state) {
      // TODO: Handle redirection for non-authenticated users for auth routes
      // (e.g., redirect to login if not accessing an auth route like attended events or profile)
      final isAuthenticated = authProvider.isAuthenticated;
      final isLoading = authProvider.isLoading;

      if (isLoading) {
        return null;
      }

      // if (!isAuthenticated) {
      //   return AppRoutes.login;
      // }

      //  if (isAuthenticated) {
      //     return AppRoutes.home;
      //   }

      return null;
    },
    routes: [
      ShellRoute(
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
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}

class AppRoutes {
  static const String home = '/';
  static const String events = '/events';
  static const String profile = '/profile';
  static const String eventDetails = '/event/:id';
  static const String settings = '/settings';
}

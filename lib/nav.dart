import 'package:base42_events_mobile/models/event.dart';
import 'package:base42_events_mobile/providers/auth_provider.dart';
import 'package:base42_events_mobile/screens/edit_profile_screen.dart';
import 'package:base42_events_mobile/screens/about_screen.dart';
import 'package:base42_events_mobile/screens/book_screen.dart';
import 'package:base42_events_mobile/screens/event_details_screen.dart';
import 'package:base42_events_mobile/screens/event_list_screen.dart';
import 'package:base42_events_mobile/screens/home_screen.dart';
import 'package:base42_events_mobile/screens/logged_out_screen.dart';
import 'package:base42_events_mobile/screens/profile_screen.dart';
import 'package:base42_events_mobile/screens/project_details_screen.dart';
import 'package:base42_events_mobile/screens/projects_screen.dart';
import 'package:base42_events_mobile/screens/rules_screen.dart';
import 'package:base42_events_mobile/screens/settings_screen.dart';
import 'package:base42_events_mobile/screens/shop_screen.dart';
import 'package:base42_events_mobile/models/project_repo.dart';
import 'package:base42_events_mobile/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  final AuthProvider authProvider;

  AppRouter(this.authProvider);

  late final GoRouter router = GoRouter(
    initialLocation: AppRoutes.auth,
    navigatorKey: _rootNavigatorKey,
    refreshListenable: authProvider,
    redirect: (context, state) {
      final isLoading = authProvider.isLoading;
      final isAuthenticated = authProvider.isAuthenticated;
      final isOnAuthGate = state.matchedLocation == AppRoutes.auth;

      if (isLoading) {
        return null;
      }

      if (!isAuthenticated && !isOnAuthGate) {
        return AppRoutes.auth;
      }

      if (isAuthenticated && isOnAuthGate) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.auth,
        name: 'auth',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const LoggedOutScreen(),
      ),
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
            path: AppRoutes.book,
            name: 'book',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: BookScreen()),
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
          GoRoute(
            path: AppRoutes.projects,
            name: 'projects',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ProjectsScreen()),
          ),
          GoRoute(
            path: AppRoutes.shop,
            name: 'shop',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ShopScreen()),
          ),
          GoRoute(
            path: AppRoutes.projectDetails,
            name: 'projectDetails',
            pageBuilder: (context, state) {
              final project = state.extra;

              if (project is! ProjectRepo) {
                return const NoTransitionPage(
                  child: Scaffold(
                    body: Center(
                      child: Text('Project details are unavailable.'),
                    ),
                  ),
                );
              }

              return NoTransitionPage(
                child: ProjectDetailsScreen(project: project),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        name: 'editProfile',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.about,
        name: 'about',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AboutScreen(),
      ),
      GoRoute(
        path: AppRoutes.rules,
        name: 'rules',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const RulesScreen(),
      ),
    ],
  );
}

class AppRoutes {
  static const String auth = '/auth';
  static const String editProfile = '/edit-profile';
  static const String home = '/';
  static const String events = '/events';
  static const String book = '/book';
  static const String profile = '/profile';
  static const String projects = '/projects';
  static const String shop = '/shop';
  static const String projectDetails = '/projects/:owner/:repo';
  static const String eventDetails = '/event/:id';
  static const String settings = '/settings';
  static const String about = '/about';
  static const String rules = '/about/rules';

  static String projectDetailsPath(String owner, String repo) =>
      '/projects/$owner/$repo';
}

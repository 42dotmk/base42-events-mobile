// import 'package:flutter/material.dart';
import 'package:base42_events_mobile/screens/login_screen.dart';
import 'package:base42_events_mobile/screens/signup_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:base42_events_mobile/screens/event_list_screen.dart';
import 'package:base42_events_mobile/screens/event_details_screen.dart';
import 'package:base42_events_mobile/models/event.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.login,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
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
        path: AppRoutes.login,
        name: 'login',
        pageBuilder: (context, state) => const NoTransitionPage(child: Login()),
      ),
      GoRoute(
        path: AppRoutes.signup,
        name: 'signup',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: Signup()),
      ),
    ],
  );
}

class AppRoutes {
  static const String home = '/';
  static const String eventDetails = '/event/:id';
  static const String signup = '/signup';
  static const String login = '/login';
}

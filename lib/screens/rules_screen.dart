import 'package:base42_events_mobile/nav.dart';
import 'package:base42_events_mobile/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RulesScreen extends StatelessWidget {
  const RulesScreen({super.key});

  void _complete(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutes.about);
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScreen(
      onComplete: () => _complete(context),
      showSkip: false,
      doneButtonLabel: 'Done',
    );
  }
}

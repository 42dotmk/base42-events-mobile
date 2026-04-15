import 'package:base42_events_mobile/providers/auth_provider.dart';
import 'package:base42_events_mobile/providers/booking_draft_provider.dart';
import 'package:base42_events_mobile/providers/settings_provider.dart';
import 'package:base42_events_mobile/screens/onboarding_screen.dart';
import 'package:base42_events_mobile/services/secure_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme.dart';
import 'nav.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => BookingDraftProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppRouter _appRouter;
  bool? _onboardingDone;

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter(context.read<AuthProvider>());
    SecureStorageService().isOnboardingComplete().then((done) {
      setState(() => _onboardingDone = done);
    });
  }

  Future<void> _completeOnboarding() async {
    await SecureStorageService().markOnboardingComplete();
    setState(() => _onboardingDone = true);
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<SettingsProvider>().themeMode;

    // Still reading storage — show a plain dark splash
    if (_onboardingDone == null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: themeMode,
        home: const _SplashScreen(),
      );
    }

    // First launch — show onboarding
    if (!_onboardingDone!) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: themeMode,
        home: OnboardingScreen(onComplete: _completeOnboarding),
      );
    }

    // Normal app
    return MaterialApp.router(
      title: 'EventFlow',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      routerConfig: _appRouter.router,
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandTheme>();
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: brand?.backdropGradient),
      ),
    );
  }
}

import 'package:base42_events_mobile/providers/attendance_provider.dart';
import 'package:base42_events_mobile/providers/auth_provider.dart';
import 'package:base42_events_mobile/providers/booking_draft_provider.dart';
import 'package:base42_events_mobile/providers/event_provider.dart';
import 'package:base42_events_mobile/providers/my_bookings_provider.dart';
import 'package:base42_events_mobile/providers/settings_provider.dart';
import 'package:base42_events_mobile/screens/onboarding_screen.dart';
import 'package:base42_events_mobile/services/secure_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'theme.dart';
import 'nav.dart';
import 'services/fcm_service.dart';

void main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => BookingDraftProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProxyProvider<EventProvider, AttendanceProvider>(
          create: (context) =>
              AttendanceProvider(eventProvider: context.read<EventProvider>()),
          update: (context, eventProvider, previous) =>
              previous ?? AttendanceProvider(eventProvider: eventProvider),
        ),
        ChangeNotifierProxyProvider<AttendanceProvider, AuthProvider>(
          create: (context) => AuthProvider(
            attendanceProvider: context.read<AttendanceProvider>(),
          ),
          update: (context, attendance, previous) =>
              previous ?? AuthProvider(attendanceProvider: attendance),
        ),
        ChangeNotifierProvider(create: (_) => MyBookingsProvider()),
      ],
      child: const MyApp(),
    ),
  );
  binding.addPostFrameCallback((_) {
    FCMService.instance.init();
  });
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
    FCMService.instance.setOnNewEventNotification(() {
      if (mounted) context.read<EventProvider>().refreshEvents();
    });
    SecureStorageService().isOnboardingComplete().then((done) {
      if (mounted) setState(() => _onboardingDone = done);
    }).whenComplete(() => FlutterNativeSplash.remove());
  }

  Future<void> _completeOnboarding() async {
    await SecureStorageService().markOnboardingComplete();
    setState(() => _onboardingDone = true);
  }
  
  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<SettingsProvider>().themeMode;
    final authProvider = context.watch<AuthProvider>();

    if (_onboardingDone == null || authProvider.isLoading) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: themeMode,
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
      );
    }
    if (!_onboardingDone!) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: themeMode,
        home: OnboardingScreen(onComplete: _completeOnboarding),
      );
    }

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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/providers/attendance_provider.dart';
import 'package:base42_events_mobile/providers/auth_provider.dart';
import 'package:base42_events_mobile/providers/event_provider.dart';
import 'package:base42_events_mobile/widgets/booking/booking_card.dart';
import 'package:base42_events_mobile/widgets/home/welcome_header.dart';
import 'package:base42_events_mobile/widgets/home/upcoming_events_section.dart';
import 'package:base42_events_mobile/widgets/home/quick_actions_grid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final eventProvider = context.read<EventProvider>();
      if (eventProvider.events.isEmpty && !eventProvider.isLoading) {
        eventProvider.loadEvents();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandTheme>();
    final colorScheme = Theme.of(context).colorScheme;
    final now = DateTime.now();
    final isOpen = now.hour >= 10 && now.hour < 22;
    final currentUser = context.watch<AuthProvider>().currentUser;
    final eventProvider = context.watch<EventProvider>();
    final attendanceProvider = context.watch<AttendanceProvider>();
    final events = eventProvider.events;
    final isLoading = eventProvider.isLoading;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: brand?.backdropGradient),
        child: SafeArea(
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: colorScheme.primary,
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WelcomeHeader(
                          currentUser: currentUser,
                          isOpen: isOpen,
                        ),
                        const SizedBox(height: 24),
                        UpcomingEventsSection(
                          events: events,
                          attendanceProvider: attendanceProvider,
                        ),
                        const SizedBox(height: 26),
                        const BookingCard(),
                        const SizedBox(height: 26),
                        const QuickActionsGrid(),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

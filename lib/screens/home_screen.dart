import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/providers/attendance_provider.dart';
import 'package:base42_events_mobile/providers/auth_provider.dart';
import 'package:base42_events_mobile/providers/event_provider.dart';
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
    final errorMessage = eventProvider.errorMessage;

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
              : (events.isEmpty && errorMessage != null)
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_off_outlined,
                          size: 48,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Couldn\'t load events',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          errorMessage,
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: () => eventProvider.refreshEvents(),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
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
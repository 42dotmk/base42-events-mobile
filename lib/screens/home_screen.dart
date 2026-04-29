import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/providers/auth_provider.dart';
import 'package:base42_events_mobile/models/event.dart';
import 'package:base42_events_mobile/nav.dart';
import 'package:base42_events_mobile/services/event_service.dart';
import 'package:base42_events_mobile/widgets/event_card.dart';
import 'package:base42_events_mobile/widgets/no_events_placeholder.dart';
import 'package:base42_events_mobile/widgets/booking/booking_card.dart';
import 'package:base42_events_mobile/widgets/location_card.dart';
import 'package:base42_events_mobile/widgets/profile/profile_initials_avatar.dart';
import 'package:base42_events_mobile/widgets/quick_action_tile.dart';
import 'package:base42_events_mobile/widgets/section_header_row.dart';
import 'package:base42_events_mobile/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class _QuickAction {
  final IconData icon;
  final String label;
  final String? route;
  final Color color;

  const _QuickAction({
    required this.icon,
    required this.label,
    this.route,
    required this.color,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final EventService _eventService = EventService();
  late final Future<List<Event>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    _eventsFuture = _eventService.fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandTheme>();
    final colorScheme = Theme.of(context).colorScheme;
    final onSurface = colorScheme.onSurface;
    final primaryAccent = colorScheme.primary;
    final now = DateTime.now();
    final isOpen = now.hour >= 10 && now.hour < 22;
    final linkColor = brand?.linkTextGray ?? colorScheme.onSurfaceVariant;
    final quickActions = [
      _QuickAction(
        icon: Icons.monitor_outlined,
        label: 'Book Event',
        route: AppRoutes.book,
        color: colorScheme.primary,
      ),
      _QuickAction(
        icon: Icons.volunteer_activism_outlined,
        label: 'Volunteer',
        color: colorScheme.primary,
      ),
      _QuickAction(
        icon: Icons.card_membership_outlined,
        label: 'Member',
        color: colorScheme.primary,
      ),
    ];
    final currentUser = context.watch<AuthProvider>().currentUser;
    final displayName = buildUserDisplayName(currentUser);
    final initials = buildUserInitials(displayName);
    final profilePicture = currentUser?.profilePicture;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: brand?.backdropGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(2, 8, 2, 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome back,',
                                  style: context.textStyles.titleMedium?.medium
                                      .withColor(
                                        onSurface.withValues(alpha: 0.62),
                                      ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  currentUser?.firstName ?? "User",
                                  style: context.textStyles.headlineLarge?.bold
                                      .withColor(onSurface),
                                ),
                                const SizedBox(height: 20),
                                Wrap(
                                  spacing: 14,
                                  runSpacing: 8,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            color: isOpen
                                                ? (brand?.successGreen ??
                                                      colorScheme.secondary)
                                                : (brand?.errorRed ??
                                                      colorScheme.error),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          isOpen ? 'Open now' : 'Closed',
                                          style: context.textStyles.titleSmall
                                              ?.withColor(
                                                onSurface.withValues(
                                                  alpha: 0.72,
                                                ),
                                              ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.group_outlined,
                                          size: 14,
                                          color: onSurface.withValues(
                                            alpha: 0.55,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '33 people here',
                                          style: context.textStyles.titleSmall
                                              ?.withColor(
                                                onSurface.withValues(
                                                  alpha: 0.72,
                                                ),
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () => context.go(AppRoutes.profile),
                            borderRadius: BorderRadius.circular(999),
                            child: ProfileInitialsAvatar(
                              initials: initials,
                              size: 56,
                              accentColor: primaryAccent,
                              profilePicture: profilePicture,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: quickActions.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.85,
                        ),
                    itemBuilder: (context, index) {
                      final action = quickActions[index];
                      return QuickActionTile(
                        icon: action.icon,
                        label: action.label,
                        color: action.color,
                        onTap: () {
                          if (action.route != null) {
                            context.go(action.route!);
                            return;
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${action.label} is coming soon'),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  SectionHeaderRow(
                    title: "AVAILABLE SPACES",
                    trailingLabel: 'All bookings',
                    trailingColor: linkColor,
                  ),
                  const SizedBox(height: 10),
                  const BookingCard(),
                  const SizedBox(height: 26),
                  SectionHeaderRow(
                    title: 'UPCOMING EVENTS',
                    trailingLabel: 'See all',
                    trailingColor: linkColor,
                    onTap: () => context.go('/events'),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 220,
                    child: FutureBuilder<List<Event>>(
                      future: _eventsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: colorScheme.primary,
                            ),
                          );
                        }

                        if (snapshot.hasError || !snapshot.hasData) {
                          return Center(
                            child: Text(
                              'Could not load events',
                              style: context.textStyles.bodyMedium?.withColor(
                                onSurface.withValues(alpha: 0.58),
                              ),
                            ),
                          );
                        }

                        final now = DateTime.now();
                        final upcoming =
                            snapshot.data!
                                .where((event) => event.start.isAfter(now))
                                .toList()
                              ..sort((a, b) => a.start.compareTo(b.start));

                        if (upcoming.isEmpty) {
                          return NoUpcomingEventsPlacehoder(
                            onTap: () => context.go('/events'),
                          );
                        }

                        final previewEvents = upcoming.take(6).toList();

                        if (previewEvents.length == 1) {
                          final singleEvent = previewEvents.first;
                          return EventCard(
                            event: singleEvent,
                            onTap: () => context.push(
                              '/event/${singleEvent.id}',
                              extra: singleEvent,
                            ),
                          );
                        }

                        return PageView.builder(
                          controller: PageController(viewportFraction: 0.9),
                          itemCount: previewEvents.length,
                          padEnds: false,
                          itemBuilder: (context, index) {
                            final event = previewEvents[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 14),
                              child: EventCard(
                                event: event,
                                onTap: () => context.push(
                                  '/event/${event.id}',
                                  extra: event,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 18),
                  const LocationCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

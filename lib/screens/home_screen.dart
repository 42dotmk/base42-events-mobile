import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/providers/auth_provider.dart';
import 'package:base42_events_mobile/models/event.dart';
import 'package:base42_events_mobile/services/event_service.dart';
import 'package:base42_events_mobile/widgets/no_events_placeholder.dart';
import 'package:base42_events_mobile/widgets/booking_card.dart';
import 'package:base42_events_mobile/widgets/location_card.dart';
import 'package:base42_events_mobile/widgets/quick_action_tile.dart';
import 'package:base42_events_mobile/widgets/section_header_row.dart';
import 'package:base42_events_mobile/widgets/space_availability_cards.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
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

  String _firstNameFromUsername(String? username) {
    final value = username?.trim() ?? '';
    if (value.isEmpty) return 'there';

    final parts = value.split(RegExp(r'\s+'));
    return parts.first;
  }

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandTheme>();
    final colorScheme = Theme.of(context).colorScheme;
    final linkColor = brand?.linkTextGray ?? colorScheme.onSurfaceVariant;
    final quickActions = [
      _QuickAction(
        icon: Icons.monitor_outlined,
        label: 'Book a Desk',
        color: brand?.quickActionDesk ?? colorScheme.secondary,
      ),
      _QuickAction(
        icon: Icons.calendar_month_outlined,
        label: 'Events',
        route: '/events',
        color: brand?.quickActionEvents ?? colorScheme.primary,
      ),
      _QuickAction(
        icon: Icons.coffee_outlined,
        label: 'Cafe Menu',
        color: brand?.quickActionCafe ?? colorScheme.tertiary,
      ),
    ];
    final currentUser = context.watch<AuthProvider>().currentUser;
    final firstName = _firstNameFromUsername(currentUser?.username);
    final initials = firstName.isNotEmpty
        ? firstName.characters.first.toUpperCase()
        : 'U';

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
                  //TODO: Redirect to profile page & make component
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.08),
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
                                        Colors.white.withValues(alpha: 0.55),
                                      ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  currentUser != null
                                      ? currentUser.username
                                      : "Guest User",
                                  style: context.textStyles.headlineLarge?.bold
                                      .withColor(Colors.white),
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
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF67D769),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Open now',
                                          style: context.textStyles.titleSmall
                                              ?.withColor(
                                                Colors.white.withValues(
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
                                          Icons.wifi_rounded,
                                          size: 14,
                                          color: Colors.white.withValues(
                                            alpha: 0.55,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Connected',
                                          style: context.textStyles.titleSmall
                                              ?.withColor(
                                                Colors.white.withValues(
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
                                          color: Colors.white.withValues(
                                            alpha: 0.55,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '33 people here',
                                          style: context.textStyles.titleSmall
                                              ?.withColor(
                                                Colors.white.withValues(
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
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color:
                                  (brand?.neonYellow ?? colorScheme.secondary)
                                      .withValues(alpha: 0.26),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              initials,
                              style: context.textStyles.titleLarge?.bold
                                  .withColor(
                                    brand?.neonYellow ?? colorScheme.secondary,
                                  ),
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
                          childAspectRatio: 1,
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
                    title: "TODAY'S BOOKING",
                    trailingLabel: 'All bookings',
                    trailingColor: linkColor,
                  ),
                  const SizedBox(height: 10),
                  const BookingCard(),
                  const SizedBox(height: 26),
                  SectionHeaderRow(
                    title: 'SPACE AVAILABILITY',
                    trailingLabel: 'View floors',
                    trailingColor: linkColor,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: AvailableDesksCard()),
                      const SizedBox(width: 12),
                      const Expanded(child: FloorsOpenCard()),
                    ],
                  ),
                  const SizedBox(height: 26),
                  SectionHeaderRow(
                    title: 'UPCOMING EVENTS',
                    trailingLabel: 'See all',
                    trailingColor: linkColor,
                    onTap: () => context.go('/events'),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 240,
                    child: FutureBuilder<List<Event>>(
                      future: _eventsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: brand?.neonCyan ?? colorScheme.primary,
                            ),
                          );
                        }

                        if (snapshot.hasError || !snapshot.hasData) {
                          return Center(
                            child: Text(
                              'Could not load events',
                              style: context.textStyles.bodyMedium?.withColor(
                                Colors.white.withValues(alpha: 0.58),
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

                        return ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: previewEvents.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 14),
                          itemBuilder: (context, index) {
                            final event = previewEvents[index];
                            return SizedBox(
                              width: 340,
                              child: _UpcomingEventCard(event: event),
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

class _UpcomingEventCard extends StatelessWidget {
  final Event event;

  const _UpcomingEventCard({required this.event});

  Color _tagBackground(String tagLower) {
    if (tagLower.contains('ai')) return const Color(0xFF5B3B97);
    if (tagLower.contains('pydata')) return const Color(0xFF8B7A20);
    if (tagLower.contains('machine')) return const Color(0xFF314E9A);
    if (tagLower.contains('game')) return const Color(0xFF813771);
    if (tagLower.contains('hack')) return const Color(0xFF8A3F38);
    return const Color(0xFF2A3545);
  }

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandTheme>();
    final colorScheme = Theme.of(context).colorScheme;
    final dateFormat = DateFormat('MMM d, yyyy');
    final timeFormat = DateFormat('HH:mm');

    return InkWell(
      onTap: () => context.push('/event/${event.id}', extra: event),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.62),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 6,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    brand?.neonYellow ?? colorScheme.secondary,
                    brand?.neonCyan ?? colorScheme.primary,
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          dateFormat.format(event.start),
                          style: context.textStyles.titleLarge?.semiBold
                              .withColor(
                                brand?.neonCyan ?? colorScheme.primary,
                              ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 2,
                          height: 20,
                          color: Colors.white.withValues(alpha: 0.12),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          timeFormat.format(event.start),
                          style: context.textStyles.titleLarge?.medium
                              .withColor(Colors.white.withValues(alpha: 0.44)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      event.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.textStyles.headlineSmall?.semiBold
                          .withSize(36 / 2)
                          .withColor(Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event.summary,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.textStyles.titleLarge?.withColor(
                        Colors.white.withValues(alpha: 0.48),
                      ),
                    ),
                    const Spacer(),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: event.tags.take(3).map((tag) {
                        final lower = tag.tagName.toLowerCase();
                        final background = _tagBackground(lower);
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: background,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            tag.tagName,
                            style: context.textStyles.labelLarge?.semiBold
                                .withColor(
                                  Colors.white.withValues(alpha: 0.88),
                                ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

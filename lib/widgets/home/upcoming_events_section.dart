import 'package:base42_events_mobile/nav.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:base42_events_mobile/models/event.dart';
import 'package:base42_events_mobile/providers/attendance_provider.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/utils.dart';
import 'package:base42_events_mobile/widgets/event_card.dart';
import 'package:base42_events_mobile/widgets/no_events_placeholder.dart';
import 'package:base42_events_mobile/widgets/section_header_row.dart';

class UpcomingEventsSection extends StatelessWidget {
  final List<Event> events;
  final AttendanceProvider attendanceProvider;

  const UpcomingEventsSection({
    super.key,
    required this.events,
    required this.attendanceProvider,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final brand = Theme.of(context).extension<BrandTheme>();
    final linkColor = brand?.linkTextGray ?? colorScheme.onSurfaceVariant;
    final now = DateTime.now();
    final upcoming = events
        .where((event) => event.start.isAfter(now))
        .toList()
      ..sort((a, b) => a.start.compareTo(b.start));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeaderRow(
          title: 'UPCOMING EVENTS',
          trailingLabel: 'See all',
          trailingColor: linkColor,
          onTap: () => context.go(AppRoutes.events),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 220,
          child: upcoming.isEmpty
              ? NoUpcomingEventsPlacehoder(
          onTap: () => context.go(AppRoutes.events),
                )
              : upcoming.length == 1
              ? EventCard(
                  event: upcoming.first,
                  attendanceStatus: resolveAttendanceStatus(
                    attendanceProvider,
                    upcoming.first.id,
                  ),
                  onTap: () => context.push(
                        AppRoutes.eventDetailsPath(upcoming.first.id),
                    extra: upcoming.first,
                  ),
                )
              : PageView.builder(
                  controller: PageController(viewportFraction: 0.9),
                  itemCount: upcoming.length > 3 ? 3 : upcoming.length,
                  padEnds: false,
                  itemBuilder: (context, index) {
                    final event = upcoming[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 14),
                      child: EventCard(
                        event: event,
                        attendanceStatus: resolveAttendanceStatus(
                          attendanceProvider,
                          event.id,
                        ),
                        onTap: () => context.push(
                          AppRoutes.eventDetailsPath(event.id),
                          extra: event,
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

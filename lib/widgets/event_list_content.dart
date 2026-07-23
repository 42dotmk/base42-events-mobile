import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:base42_events_mobile/models/event.dart';
import 'package:base42_events_mobile/nav.dart';
import 'package:base42_events_mobile/providers/event_provider.dart';
import 'package:base42_events_mobile/widgets/event_card.dart';
import 'package:base42_events_mobile/widgets/event_list_section_header.dart';
import 'package:provider/provider.dart';

class EventListContent extends StatelessWidget {
  final List<Event> events;

  const EventListContent({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final now = DateTime.now();
    final upcoming = events
        .where((e) => e.start.isAfter(now))
        .toList()
      ..sort((a, b) => a.start.compareTo(b.start));
    final past = events
        .where((e) => !e.start.isAfter(now))
        .toList()
      ..sort((a, b) => b.start.compareTo(a.start));

    final items = <Widget>[];
    if (upcoming.isNotEmpty) {
      items.add(EventListSectionHeader(title: 'UPCOMING'));
      for (final event in upcoming) {
        items.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: EventCard(
              event: event,
              onTap: () => context.push(
                AppRoutes.eventDetailsPath(event.id),
                extra: event,
              ),
            ),
          ),
        );
      }
    }
    if (upcoming.isNotEmpty && past.isNotEmpty) {
      items.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Divider(
          color: colorScheme.outline.withValues(alpha: 0.25),
          height: 1,
        ),
      ));
    }
    if (past.isNotEmpty) {
      items.add(EventListSectionHeader(title: 'PAST'));
      for (final event in past) {
        items.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: EventCard(
              event: event,
              isPast: true,
              onTap: () => context.push(
                AppRoutes.eventDetailsPath(event.id),
                extra: event,
              ),
            ),
          ),
        );
      }
    }

    return RefreshIndicator(
      onRefresh: () => context.read<EventProvider>().refreshEvents(),
      color: colorScheme.primary,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
        children: items,
      ),
    );
  }
}
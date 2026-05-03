import 'package:base42_events_mobile/screens/profile_screen.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:flutter/material.dart';

class _EmptyBookingsState extends StatelessWidget {
  final _BookingFilter filter;

  const _EmptyBookingsState({required this.filter});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final text = filter == _BookingFilter.upcoming
        ? 'No upcoming bookings'
        : 'No past bookings';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.event_busy_outlined,
            color: colorScheme.onSurface.withValues(alpha: 0.55),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: context.textStyles.titleMedium?.withColor(
              colorScheme.onSurface.withValues(alpha: 0.62),
            ),
          ),
        ],
      ),
    );
  }
}

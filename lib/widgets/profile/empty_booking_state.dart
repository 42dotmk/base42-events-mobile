import 'package:base42_events_mobile/theme.dart';
import 'package:flutter/material.dart';

enum BookingFilter { upcoming, past }

class EmptyBookingsState extends StatelessWidget {
  final BookingFilter filter;

  const EmptyBookingsState({super.key, required this.filter});

  @override
  Widget build(BuildContext context) {
    final text = filter == BookingFilter.upcoming
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
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.event_busy_outlined,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.45),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: context.textStyles.titleMedium?.withColor(
              Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

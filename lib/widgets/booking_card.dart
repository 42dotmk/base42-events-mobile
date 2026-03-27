import 'package:base42_events_mobile/theme.dart';
import 'package:flutter/material.dart';

class BookingCard extends StatelessWidget {
  final String spaceName;
  final String floor;
  final String status;
  final String date;
  final String timeRange;

  //MOCK DATA - FETAURE NOT IMPLEMENTED YET
  const BookingCard({
    super.key,
    this.spaceName = 'Main Open Workspace',
    this.floor = 'First Floor',
    this.status = 'Confirmed',
    this.date = 'Feb 12, 2026',
    this.timeRange = '09:00 - 17:00',
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 96),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        spaceName,
                        style: context.textStyles.headlineSmall?.bold
                            .withSize(20)
                            .withColor(Colors.white),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        floor,
                        style: context.textStyles.titleSmall?.medium.withColor(
                          Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 20,
                      color: Colors.white.withValues(alpha: 0.62),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      date,
                      style: context.textStyles.bodySmall?.medium.withColor(
                        Colors.white.withValues(alpha: 0.66),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.access_time_rounded,
                      size: 20,
                      color: Colors.white.withValues(alpha: 0.62),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      timeRange,
                      style: context.textStyles.bodySmall?.medium.withColor(
                        Colors.white.withValues(alpha: 0.66),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFF2F7E46).withValues(alpha: 0.42),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                status,
                style: context.textStyles.labelMedium?.semiBold.withColor(
                  const Color(0xFF6ADE77),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

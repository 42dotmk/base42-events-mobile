import 'package:base42_events_mobile/theme.dart';
import 'package:flutter/material.dart';

class BookingCard extends StatelessWidget {
  final String spaceName;
  final String floor;
  final String status;
  final String date;
  final String timeRange;
  final Color? statusTextColor;
  final Color? statusBackgroundColor;

  //MOCK DATA - FETAURE NOT IMPLEMENTED YET
  const BookingCard({
    super.key,
    this.spaceName = 'Main Open Workspace',
    this.floor = 'First Floor',
    this.status = 'Confirmed',
    this.date = 'Feb 12, 2026',
    this.timeRange = '09:00 - 17:00',
    this.statusTextColor,
    this.statusBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandTheme>()!;
    final colorScheme = Theme.of(context).colorScheme;
    final resolvedStatusTextColor =
        statusTextColor ?? brand.bookingStatusConfirmedText;
    final resolvedStatusBackgroundColor =
        statusBackgroundColor ?? brand.bookingStatusConfirmedBackground;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        spaceName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.textStyles.headlineSmall?.bold
                            .withSize(20)
                            .withColor(colorScheme.onSurface),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        floor,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textStyles.titleSmall?.medium.withColor(
                          colorScheme.onSurface.withValues(alpha: 0.62),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 120),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: resolvedStatusBackgroundColor.withValues(
                        alpha: 0.42,
                      ),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      status,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textStyles.labelMedium?.semiBold.withColor(
                        resolvedStatusTextColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 14,
              runSpacing: 8,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 20,
                      color: colorScheme.onSurface.withValues(alpha: 0.62),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      date,
                      style: context.textStyles.bodySmall?.medium.withColor(
                        colorScheme.onSurface.withValues(alpha: 0.72),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 20,
                      color: colorScheme.onSurface.withValues(alpha: 0.62),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      timeRange,
                      style: context.textStyles.bodySmall?.medium.withColor(
                        colorScheme.onSurface.withValues(alpha: 0.72),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

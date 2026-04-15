import 'package:base42_events_mobile/models/event.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/widgets/chip_label.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventAttendanceTile extends StatelessWidget {
  final Event event;
  final String statusLabel;
  final Color statusColor;
  final String actionLabel;
  final bool isActionEnabled;
  final VoidCallback onActionTap;

  const EventAttendanceTile({
    super.key,
    required this.event,
    required this.statusLabel,
    required this.statusColor,
    required this.actionLabel,
    required this.onActionTap,
    this.isActionEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final brand = Theme.of(context).extension<BrandTheme>();
    final dateText = DateFormat('MMM d, yyyy').format(event.start);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  dateText,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.56),
                  ),
                ),
                const SizedBox(height: 10),
                ChipLabel(
                  text: statusLabel,
                  color: statusColor,
                  backgroundColor: statusColor.withValues(alpha: 0.14),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          TextButton(
            onPressed: isActionEnabled ? onActionTap : null,
            style: TextButton.styleFrom(
              foregroundColor: isActionEnabled
                  ? brand?.neonCyan ?? colorScheme.primary
                  : Colors.white.withValues(alpha: 0.45),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              backgroundColor: isActionEnabled
                  ? (brand?.neonCyan ?? colorScheme.primary).withValues(
                      alpha: 0.1,
                    )
                  : Colors.white.withValues(alpha: 0.08),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              actionLabel,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: isActionEnabled
                    ? brand?.neonCyan ?? colorScheme.primary
                    : Colors.white.withValues(alpha: 0.5),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

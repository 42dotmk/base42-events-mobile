import 'package:base42_events_mobile/models/event.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventAttendanceTile extends StatelessWidget {
  final Event event;
  final Color statusColor;
  final String actionLabel;
  final bool isActionEnabled;
  final VoidCallback onActionTap;

  const EventAttendanceTile({
    super.key,
    required this.event,
    required this.statusColor,
    required this.actionLabel,
    required this.onActionTap,
    this.isActionEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final dateText = DateFormat('MMM d, yyyy').format(event.start);

    return GestureDetector(
      onTap: () => context.push('/event/${event.id}', extra: event),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.62),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
        ),
        padding: const EdgeInsets.all(14),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: context.textStyles.titleMedium?.semiBold.withColor(
                      colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    dateText,
                    style: context.textStyles.bodySmall?.withColor(
                      colorScheme.onSurface.withValues(alpha: 0.56),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 1,
              child: Center(
                child: TextButton(
                  onPressed: isActionEnabled ? onActionTap : null,
                  style: TextButton.styleFrom(
                    foregroundColor: isActionEnabled
                        ? colorScheme.primary
                        : colorScheme.onSurface.withValues(alpha: 0.45),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    backgroundColor: isActionEnabled
                        ? (colorScheme.primary).withValues(alpha: 0.1)
                        : colorScheme.onSurface.withValues(alpha: 0.08),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    actionLabel,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: isActionEnabled
                          ? colorScheme.primary
                          : colorScheme.onSurface.withValues(alpha: 0.5),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

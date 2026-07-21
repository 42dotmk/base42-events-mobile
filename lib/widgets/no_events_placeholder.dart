import 'package:base42_events_mobile/theme.dart';
import 'package:flutter/material.dart';

class NoUpcomingEventsPlaceholder extends StatelessWidget {
  final VoidCallback? onTap;

  const NoUpcomingEventsPlaceholder({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.62),
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.15),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned(
              right: -30,
              bottom: -30,
              child: Icon(
                Icons.calendar_month_outlined,
                size: 180,
                color: colorScheme.primary.withValues(alpha: 0.08),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No upcoming events yet',
                    style: context.textStyles.titleLarge?.semiBold.withColor(
                      colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Stay tuned, new sessions are announced regularly.',
                    style: context.textStyles.bodyMedium?.withColor(
                      colorScheme.onSurface.withValues(alpha: 0.62),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:base42_events_mobile/theme.dart';
import 'package:flutter/material.dart';

class NoUpcomingEventsPlacehoder extends StatelessWidget {
  final VoidCallback? onTap;

  const NoUpcomingEventsPlacehoder({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandTheme>();
    final colorScheme = Theme.of(context).colorScheme;
    final linkColor = brand?.linkTextGray ?? colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: onTap,
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.event_busy_outlined,
                          color: brand?.neonCyan ?? colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'No upcoming events',
                          style: context.textStyles.titleLarge?.semiBold
                              .withColor(Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'New sessions will appear here as soon as they are announced.',
                      style: context.textStyles.bodyMedium?.withColor(
                        Colors.white.withValues(alpha: 0.56),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          'Browse all events',
                          style: context.textStyles.titleMedium?.medium
                              .withColor(linkColor),
                        ),
                        Icon(Icons.chevron_right_rounded, color: linkColor),
                      ],
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

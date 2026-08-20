import 'package:base42_events_mobile/theme.dart';
import 'package:flutter/material.dart';

class MembershipCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? badgeLabel;
  final String? nextCycleDate;

  const MembershipCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.badgeLabel,
    this.nextCycleDate,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = colorScheme.primary;
    final onSurface = colorScheme.onSurface;
    final mutedColor = onSurface.withValues(alpha: 0.55);
    final bgColor = isDark ? colorScheme.surfaceContainerHighest : Colors.white;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.card_membership_rounded,
                    size: 24,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: context.textStyles.headlineSmall?.bold.withColor(
                          onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: context.textStyles.bodyMedium?.withColor(
                          mutedColor,
                        ),
                      ),
                    ],
                  ),
                ),
                if (badgeLabel != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      badgeLabel!,
                      style: context.textStyles.labelSmall?.bold.withColor(
                        primaryColor.readableForeground(),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (nextCycleDate != null) ...[
            Divider(
              height: 1,
              indent: 20,
              endIndent: 20,
              color: onSurface.withValues(alpha: 0.08),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 18,
                    color: mutedColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Next Cycle: $nextCycleDate',
                    style: context.textStyles.bodyMedium?.withColor(
                      mutedColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:base42_events_mobile/theme.dart';

class MemberPerk {
  final IconData icon;
  final String title;
  final String description;

  const MemberPerk({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class MemberPerkCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const MemberPerkCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final onSurface = colorScheme.onSurface;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: onSurface.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(
              icon,
              color: onSurface.withValues(alpha: 0.6),
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.textStyles.titleMedium?.bold.withColor(
                    onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: context.textStyles.bodyMedium?.withColor(
                    onSurface.withValues(alpha: 0.55),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

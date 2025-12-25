import 'package:flutter/material.dart';
import 'package:base42_events_mobile/theme.dart';

class TagChip extends StatelessWidget {
  final String label;

  const TagChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: context.textStyles.labelSmall?.withColor(
          colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}

class EventTagChip extends StatelessWidget {
  final String label;

  const EventTagChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final brand = Theme.of(context).extension<BrandTheme>();
    final Color textColor = brand?.neonCyan ?? colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: textColor, width: 1),
      ),
      child: Text(
        label,
        style: context.textStyles.labelMedium?.withColor(textColor).medium,
      ),
    );
  }
}

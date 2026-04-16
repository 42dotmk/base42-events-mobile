import 'package:base42_events_mobile/theme.dart';
import 'package:flutter/material.dart';

class BookingFilterSwitch extends StatelessWidget {
  final String upcomingLabel;
  final String pastLabel;
  final bool showUpcoming;
  final VoidCallback onUpcomingTap;
  final VoidCallback onPastTap;

  const BookingFilterSwitch({
    super.key,
    required this.upcomingLabel,
    required this.pastLabel,
    required this.showUpcoming,
    required this.onUpcomingTap,
    required this.onPastTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BookingFilterChip(
          label: upcomingLabel,
          selected: showUpcoming,
          onTap: onUpcomingTap,
        ),
        const SizedBox(width: 8),
        BookingFilterChip(
          label: pastLabel,
          selected: !showUpcoming,
          onTap: onPastTap,
        ),
      ],
    );
  }
}

class BookingFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const BookingFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final selectedColor = colorScheme.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? selectedColor.withValues(alpha: 0.18)
              : colorScheme.surfaceContainerHighest.withValues(alpha: 0.62),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? selectedColor.withValues(alpha: 0.6)
                : colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Text(
          label,
          style: context.textStyles.titleSmall?.semiBold.withColor(
            selected
                ? selectedColor
                : colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}

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
    final colorScheme = Theme.of(context).colorScheme;
    final brand = Theme.of(context).extension<BrandTheme>();
    final yellow = brand?.neonYellow ?? colorScheme.secondary;

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(child: _Segment(
            label: upcomingLabel,
            selected: showUpcoming,
            yellow: yellow,
            onSurface: colorScheme.onSurface,
            onTap: onUpcomingTap,
          )),
          Expanded(child: _Segment(
            label: pastLabel,
            selected: !showUpcoming,
            yellow: yellow,
            onSurface: colorScheme.onSurface,
            onTap: onPastTap,
          )),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  final String label;
  final bool selected;
  final Color yellow;
  final Color onSurface;
  final VoidCallback onTap;

  const _Segment({
    required this.label,
    required this.selected,
    required this.yellow,
    required this.onSurface,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: selected ? yellow : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Center(
            child: Text(
              label,
              style: context.textStyles.titleSmall?.semiBold.withColor(
                selected ? Colors.black : onSurface.withValues(alpha: 0.4),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

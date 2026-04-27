import 'package:base42_events_mobile/theme.dart';
import 'package:flutter/material.dart';

class AttendanceFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const AttendanceFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandTheme>();
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? (brand?.neonYellow ?? colorScheme.secondary).withValues(
                  alpha: 0.18,
                )
              : colorScheme.surfaceContainerHighest.withValues(alpha: 0.62),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? (brand?.neonYellow ?? colorScheme.secondary).withValues(
                    alpha: 0.6,
                  )
                : Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: context.textStyles.titleMedium?.semiBold.withColor(
              selected
                  ? brand?.neonYellow ?? colorScheme.secondary
                  : Colors.white.withValues(alpha: 0.44),
            ),
          ),
        ),
      ),
    );
  }
}

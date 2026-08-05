import 'package:flutter/material.dart';
import 'package:base42_events_mobile/theme.dart';

class PlanCard extends StatelessWidget {
  final String label;
  final String price;
  final String? perMonth;
  final String? savingsLabel;
  final bool isSelected;
  final VoidCallback onTap;
  final Color effectiveAccent;

  const PlanCard({
    super.key,
    required this.label,
    required this.price,
    this.perMonth,
    this.savingsLabel,
    required this.isSelected,
    required this.onTap,
    required this.effectiveAccent,
  });

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandTheme>();
    final colorScheme = Theme.of(context).colorScheme;
    final onSurface = colorScheme.onSurface;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? effectiveAccent.withValues(alpha: 0.08)
              : onSurface.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isSelected
                ? effectiveAccent.withValues(alpha: 0.5)
                : onSurface.withValues(alpha: 0.12),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        label,
                        style: context.textStyles.titleMedium?.bold.withColor(
                          isSelected ? effectiveAccent : onSurface,
                        ),
                      ),
                      if (savingsLabel != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: brand?.successGreen ?? Colors.green,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            savingsLabel!,
                            style: context.textStyles.labelSmall?.bold.withColor(
                              isDark ? Colors.black : Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    price,
                    style: context.textStyles.headlineSmall?.bold.withColor(
                      onSurface,
                    ),
                  ),
                  if (perMonth != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      perMonth!,
                      style: context.textStyles.bodySmall?.withColor(
                        onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? effectiveAccent
                      : onSurface.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: effectiveAccent,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

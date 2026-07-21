import 'package:flutter/material.dart';
import 'package:base42_events_mobile/theme.dart';

class VolunteerBenefitItem {
  final IconData icon;
  final String title;
  final String description;

  const VolunteerBenefitItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class VolunteerBenefitCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const VolunteerBenefitCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final onSurface = colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.62,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: onSurface.withValues(alpha: 0.55),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.textStyles.titleMedium?.semiBold
                      .withColor(onSurface),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: context.textStyles.titleSmall?.withColor(
                    onSurface.withValues(alpha: 0.58),
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

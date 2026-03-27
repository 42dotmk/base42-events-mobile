import 'package:base42_events_mobile/theme.dart';
import 'package:flutter/material.dart';

class LocationCard extends StatelessWidget {
  final String name;
  final String address;
  final String status;
  final String hours;

  const LocationCard({
    super.key,
    this.name = 'Base42',
    this.address = 'Rimska 25, Skopje',
    this.status = 'Open',
    this.hours = '09:00 - 22:00',
  });

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandTheme>();
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: (brand?.neonYellow ?? colorScheme.secondary).withValues(
                alpha: 0.16,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.location_on_outlined,
              color: brand?.neonYellow ?? colorScheme.secondary,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: context.textStyles.headlineSmall?.bold
                      .withSize(20)
                      .withColor(Colors.white),
                ),
                const SizedBox(height: 2),
                Text(
                  address,
                  style: context.textStyles.bodySmall?.medium.withColor(
                    Colors.white.withValues(alpha: 0.56),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                status,
                style: context.textStyles.labelLarge?.semiBold.withColor(
                  const Color(0xFF69D976),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                hours,
                style: context.textStyles.bodySmall?.medium.withColor(
                  Colors.white.withValues(alpha: 0.46),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

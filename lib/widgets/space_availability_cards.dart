import 'package:base42_events_mobile/theme.dart';
import 'package:flutter/material.dart';

class AvailableDesksCard extends StatelessWidget {
  final String value;
  final String subtitle;

  const AvailableDesksCard({
    super.key,
    this.value = '66',
    this.subtitle = 'of 99 total',
  });

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandTheme>();
    final colorScheme = Theme.of(context).colorScheme;

    return _AvailabilityCard(
      icon: Icons.bolt_rounded,
      iconColor: brand?.neonYellow ?? colorScheme.secondary,
      title: 'Available Desks',
      value: value,
      subtitle: subtitle,
    );
  }
}

class FloorsOpenCard extends StatelessWidget {
  final String value;
  final String subtitle;

  const FloorsOpenCard({
    super.key,
    this.value = '2',
    this.subtitle = 'Ground + First',
  });

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandTheme>();
    final colorScheme = Theme.of(context).colorScheme;

    return _AvailabilityCard(
      icon: Icons.location_on_outlined,
      iconColor: brand?.neonYellow ?? colorScheme.secondary,
      title: 'Floors Open',
      value: value,
      subtitle: subtitle,
    );
  }
}

class _AvailabilityCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final String subtitle;

  const _AvailabilityCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flex(
            direction: Axis.horizontal,
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textStyles.titleMedium?.semiBold.withColor(
                    Colors.white.withValues(alpha: 0.67),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: context.textStyles.displayMedium?.bold.withColor(iconColor),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textStyles.titleMedium?.withColor(
              Colors.white.withValues(alpha: 0.48),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:base42_events_mobile/theme.dart';
import 'package:flutter/material.dart';

enum FloorType { ground, first }

class BookableSpace {
  final String name;
  final String type;
  final int capacity;
  final String availability;
  final String price;
  final List<String> amenities;
  final IconData icon;

  const BookableSpace({
    required this.name,
    required this.type,
    required this.capacity,
    required this.availability,
    required this.price,
    required this.amenities,
    required this.icon,
  });
}

class CoworkingSection extends StatelessWidget {
  final FloorType activeFloor;
  final ValueChanged<FloorType> onFloorChanged;
  final List<BookableSpace> spaces;

  const CoworkingSection({
    super.key,
    required this.activeFloor,
    required this.onFloorChanged,
    required this.spaces,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _FloorChip(
                label: 'Ground Floor',
                selected: activeFloor == FloorType.ground,
                onTap: () => onFloorChanged(FloorType.ground),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _FloorChip(
                label: 'First Floor',
                selected: activeFloor == FloorType.first,
                onTap: () => onFloorChanged(FloorType.first),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ...spaces.map(
          (space) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _BookableSpaceCard(space: space),
          ),
        ),
      ],
    );
  }
}

class _FloorChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FloorChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: selected
              ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.9)
              : colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? Colors.white.withValues(alpha: 0.24)
                : Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: context.textStyles.labelLarge?.semiBold.withColor(
            selected ? Colors.white : Colors.white.withValues(alpha: 0.62),
          ),
        ),
      ),
    );
  }
}

class _BookableSpaceCard extends StatelessWidget {
  final BookableSpace space;

  const _BookableSpaceCard({required this.space});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final brand = Theme.of(context).extension<BrandTheme>();

    Color availabilityColor;
    switch (space.availability) {
      case 'Available':
        availabilityColor = const Color(0xFF69D976);
      case 'Limited':
        availabilityColor = brand?.neonYellow ?? colorScheme.secondary;
      default:
        availabilityColor = const Color(0xFFE27B7B);
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: (brand?.neonCyan ?? colorScheme.primary).withValues(
                    alpha: 0.18,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  space.icon,
                  color: brand?.neonCyan ?? colorScheme.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      space.name,
                      style: context.textStyles.titleMedium?.semiBold.withColor(
                        Colors.white,
                      ),
                    ),
                    Text(
                      space.type,
                      style: context.textStyles.bodySmall?.withColor(
                        Colors.white.withValues(alpha: 0.56),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: availabilityColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  space.availability,
                  style: context.textStyles.labelSmall?.semiBold.withColor(
                    availabilityColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '${space.capacity} seats • ${space.price}',
            style: context.textStyles.bodySmall?.medium.withColor(
              Colors.white.withValues(alpha: 0.62),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: space.amenities
                .map(
                  (item) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item,
                      style: context.textStyles.labelSmall?.withColor(
                        Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

import 'package:base42_events_mobile/theme.dart';
import 'package:flutter/material.dart';

enum _BookMode { coworking, hostEvent }

enum _FloorType { ground, first }

class _BookableSpace {
  final String name;
  final String type;
  final int capacity;
  final String availability;
  final String price;
  final List<String> amenities;
  final IconData icon;

  const _BookableSpace({
    required this.name,
    required this.type,
    required this.capacity,
    required this.availability,
    required this.price,
    required this.amenities,
    required this.icon,
  });
}

class BookScreen extends StatefulWidget {
  const BookScreen({super.key});

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  _BookMode _mode = _BookMode.coworking;
  _FloorType _activeFloor = _FloorType.ground;

  static const List<_BookableSpace> _groundFloorSpaces = [
    _BookableSpace(
      name: 'Main Open Workspace',
      type: 'Hot desk',
      capacity: 24,
      availability: 'Available',
      price: '150 MKD/hour',
      amenities: ['Wi-Fi', 'Power', 'Whiteboard'],
      icon: Icons.monitor_outlined,
    ),
    _BookableSpace(
      name: 'Meeting Room A',
      type: 'Meeting room',
      capacity: 8,
      availability: 'Limited',
      price: '600 MKD/hour',
      amenities: ['Display', 'Camera', 'Speaker'],
      icon: Icons.slideshow_outlined,
    ),
  ];

  static const List<_BookableSpace> _firstFloorSpaces = [
    _BookableSpace(
      name: 'Quiet Pod 2',
      type: 'Call room',
      capacity: 2,
      availability: 'Available',
      price: '250 MKD/hour',
      amenities: ['Soundproof', 'Wi-Fi'],
      icon: Icons.phone_in_talk_outlined,
    ),
    _BookableSpace(
      name: 'Team Room North',
      type: 'Team room',
      capacity: 12,
      availability: 'Busy',
      price: '900 MKD/hour',
      amenities: ['TV', 'Whiteboard', 'HDMI'],
      icon: Icons.groups_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandTheme>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: brand?.backdropGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Book a Space',
                  style: context.textStyles.headlineSmall?.bold.withColor(
                    Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Reserve your spot at Base42',
                  style: context.textStyles.bodySmall?.withColor(
                    Colors.white.withValues(alpha: 0.56),
                  ),
                ),
                const SizedBox(height: 16),
                _ModeSwitcher(
                  mode: _mode,
                  onChanged: (mode) => setState(() => _mode = mode),
                ),
                const SizedBox(height: 16),
                if (_mode == _BookMode.coworking)
                  _CoworkingSection(
                    activeFloor: _activeFloor,
                    onFloorChanged: (floor) =>
                        setState(() => _activeFloor = floor),
                    spaces: _activeFloor == _FloorType.ground
                        ? _groundFloorSpaces
                        : _firstFloorSpaces,
                  )
                else
                  const _HostEventSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ModeSwitcher extends StatelessWidget {
  final _BookMode mode;
  final ValueChanged<_BookMode> onChanged;

  const _ModeSwitcher({required this.mode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final brand = Theme.of(context).extension<BrandTheme>();

    Widget buildButton(_BookMode buttonMode, String label, IconData icon) {
      final selected = mode == buttonMode;
      return Expanded(
        child: GestureDetector(
          onTap: () => onChanged(buttonMode),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: selected
                  ? (buttonMode == _BookMode.coworking
                        ? brand?.neonCyan ?? colorScheme.primary
                        : brand?.neonYellow ?? colorScheme.secondary)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: selected
                      ? Colors.black
                      : Colors.white.withValues(alpha: 0.56),
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: context.textStyles.labelLarge?.semiBold.withColor(
                    selected
                        ? Colors.black
                        : Colors.white.withValues(alpha: 0.56),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          buildButton(_BookMode.coworking, 'Coworking', Icons.monitor_outlined),
          const SizedBox(width: 4),
          buildButton(
            _BookMode.hostEvent,
            'Host Event',
            Icons.event_note_outlined,
          ),
        ],
      ),
    );
  }
}

class _CoworkingSection extends StatelessWidget {
  final _FloorType activeFloor;
  final ValueChanged<_FloorType> onFloorChanged;
  final List<_BookableSpace> spaces;

  const _CoworkingSection({
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
                selected: activeFloor == _FloorType.ground,
                onTap: () => onFloorChanged(_FloorType.ground),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _FloorChip(
                label: 'First Floor',
                selected: activeFloor == _FloorType.first,
                onTap: () => onFloorChanged(_FloorType.first),
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
  final _BookableSpace space;

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

class _HostEventSection extends StatelessWidget {
  const _HostEventSection();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final brand = Theme.of(context).extension<BrandTheme>();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
              Icon(
                Icons.auto_awesome_outlined,
                color: brand?.neonYellow ?? colorScheme.secondary,
              ),
              const SizedBox(width: 8),
              Text(
                'Host your event at Base42',
                style: context.textStyles.titleMedium?.semiBold.withColor(
                  Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Static preview only for now. This page will be connected to real booking requests once the backend booking endpoints are ready.',
            style: context.textStyles.bodySmall?.withColor(
              Colors.white.withValues(alpha: 0.62),
            ),
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: null,
            icon: const Icon(Icons.send_outlined),
            label: const Text('Submit Booking Request (Coming soon)'),
          ),
        ],
      ),
    );
  }
}

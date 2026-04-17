import 'package:base42_events_mobile/theme.dart';
import 'package:flutter/material.dart';

class HostEventSpaceOption {
  final String value;
  final String label;
  final String imageAssetPath;
  final String description;

  const HostEventSpaceOption({
    required this.value,
    required this.label,
    required this.imageAssetPath,
    required this.description,
  });
}

const List<HostEventSpaceOption> hostEventSpaceOptions = [
  HostEventSpaceOption(
    value: 'Events Hall',
    label: 'Events Hall - 80 people',
    imageAssetPath: 'assets/images/whole-space.jpeg',
    description: 'Ideal for talks, presentations, and larger meetups.',
  ),
  HostEventSpaceOption(
    value: 'Workshop Area',
    label: 'Workshop Area - 40 people',
    imageAssetPath: 'assets/images/workshop-space.jpg',
    description: 'Great for hands-on sessions and collaborative workshops.',
  ),
  HostEventSpaceOption(
    value: 'Electronics Area',
    label: 'Electronics Area - 10 people',
    imageAssetPath: 'assets/images/electronics.jpg',
    description: 'Best for hardware hacking, testing, and prototyping.',
  ),
  HostEventSpaceOption(
    value: 'Full Space',
    label: 'Full space - 120 people',
    imageAssetPath: 'assets/images/whole-space.jpeg',
    description: 'Complete venue booking for conferences and big events.',
  ),
];

HostEventSpaceOption? findHostEventSpaceOption(String? value) {
  if (value == null || value.trim().isEmpty) {
    return null;
  }

  for (final option in hostEventSpaceOptions) {
    if (option.value == value) {
      return option;
    }
  }
  return null;
}

class SelectedSpacePreviewCard extends StatelessWidget {
  final HostEventSpaceOption? space;

  const SelectedSpacePreviewCard({super.key, required this.space});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final imageAssetPath =
        space?.imageAssetPath ?? 'assets/images/base42_placeholder.png';

    return Container(
      height: 190,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            imageAssetPath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Image.asset(
              'assets/images/base42_placeholder.png',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x22000000), Color(0xB0000000)],
              ),
            ),
          ),
          Positioned(
            left: 14,
            right: 14,
            bottom: 14,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  space?.description ??
                      'Select one option from the dropdown to see details.',
                  style: context.textStyles.bodyMedium?.withColor(
                    Colors.white.withValues(alpha: 0.88),
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

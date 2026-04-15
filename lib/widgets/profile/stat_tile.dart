import 'package:base42_events_mobile/theme.dart';
import 'package:flutter/material.dart';

class StatTile extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;

  const StatTile({
    super.key,
    required this.value,
    required this.label,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: context.textStyles.headlineMedium?.bold.withColor(
              valueColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: context.textStyles.titleMedium?.withColor(
              Colors.white.withValues(alpha: 0.44),
            ),
          ),
        ],
      ),
    );
  }
}

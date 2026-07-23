import 'package:flutter/material.dart';
import 'package:base42_events_mobile/theme.dart';

class EventListSectionHeader extends StatelessWidget {
  final String title;

  const EventListSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 2, 0, 8),
      child: Text(
        title,
        style: context.textStyles.labelMedium?.semiBold.withColor(
          colorScheme.onSurface.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
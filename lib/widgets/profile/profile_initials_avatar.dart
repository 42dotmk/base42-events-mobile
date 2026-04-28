import 'package:base42_events_mobile/theme.dart';
import 'package:flutter/material.dart';

class ProfileInitialsAvatar extends StatelessWidget {
  final String initials;
  final double size;
  final Color? accentColor;

  const ProfileInitialsAvatar({
    super.key,
    required this.initials,
    this.size = 56,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final resolvedAccentColor = accentColor ?? colorScheme.primary;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: resolvedAccentColor.withValues(alpha: 0.26),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: context.textStyles.titleLarge?.bold.withColor(
          resolvedAccentColor,
        ),
      ),
    );
  }
}

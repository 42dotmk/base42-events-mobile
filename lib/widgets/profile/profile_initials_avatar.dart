import 'package:base42_events_mobile/consts/api.dart';
import 'package:base42_events_mobile/models/media.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:flutter/material.dart';

class ProfileInitialsAvatar extends StatelessWidget {
  final String initials;
  final double size;
  final Color? accentColor;
  final Media? profilePicture;

  const ProfileInitialsAvatar({
    super.key,
    required this.initials,
    this.size = 56,
    this.accentColor,
    this.profilePicture,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final brand = Theme.of(context).extension<BrandTheme>();
    final resolvedAccentColor = accentColor ?? colorScheme.primary;

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: resolvedAccentColor.withValues(alpha: 0.26),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: profilePicture != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.network(
                profilePicture?.getMediumUrl(baseUrl) ?? '',
                width: 86,
                height: 86,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Text(
                  initials,
                  style: context.textStyles.headlineMedium?.bold.withColor(
                    brand?.neonYellow ?? colorScheme.secondary,
                  ),
                ),
              ),
            )
          : Text(
              initials,
              style: context.textStyles.headlineMedium?.bold.withColor(
                brand?.neonYellow ?? colorScheme.secondary,
              ),
            ),
    );
  }
}

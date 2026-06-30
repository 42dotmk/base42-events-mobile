import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:base42_events_mobile/nav.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/utils.dart';
import 'package:base42_events_mobile/widgets/profile/profile_initials_avatar.dart';

class WelcomeHeader extends StatelessWidget {
  final dynamic currentUser;
  final bool isOpen;

  const WelcomeHeader({
    super.key,
    required this.currentUser,
    required this.isOpen,
  });

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandTheme>();
    final colorScheme = Theme.of(context).colorScheme;
    final onSurface = colorScheme.onSurface;
    final primaryAccent = colorScheme.primary;
    final displayName = buildUserDisplayName(currentUser);
    final initials = buildUserInitials(displayName);
    final profilePicture = currentUser?.profilePicture;

    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(2, 8, 2, 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back,',
                    style: context.textStyles.titleMedium?.medium.withColor(
                      onSurface.withValues(alpha: 0.62),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    currentUser?.firstName ?? "User",
                    style: context.textStyles.headlineLarge?.bold.withColor(
                      onSurface,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 14,
                    runSpacing: 8,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: isOpen
                                  ? (brand?.successGreen ?? colorScheme.secondary)
                                  : (brand?.errorRed ?? colorScheme.error),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isOpen ? 'Open now' : 'Closed',
                            style: context.textStyles.titleSmall?.withColor(
                              onSurface.withValues(alpha: 0.72),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () => context.go(AppRoutes.profile),
              borderRadius: BorderRadius.circular(999),
              child: ProfileInitialsAvatar(
                initials: initials,
                size: 56,
                accentColor: primaryAccent,
                profilePicture: profilePicture,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

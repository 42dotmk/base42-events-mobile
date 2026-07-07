import 'package:base42_events_mobile/consts/membership_pricing.dart';
import 'package:flutter/material.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/models/membership.dart';

class CurrentPlanCard extends StatelessWidget {
  final String userType;
  final Membership? activeMembership;
  final Color accentColor;
  final Color secondaryAccent;
  final Color onSurface;

  const CurrentPlanCard({
    super.key,
    required this.userType,
    this.activeMembership,
    required this.accentColor,
    required this.secondaryAccent,
    required this.onSurface,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMember = userType == 'member' && activeMembership != null;
    final isVolunteer = userType == 'volunteer';
    final primaryAccent = activeMembership?.tier == 'yearly'
        ? secondaryAccent
        : accentColor;

    final planLabel = isMember
        ? '${(activeMembership!.tier == 'monthly' ? 'MONTHLY' : 'YEARLY')} PLAN'
        : isVolunteer
            ? 'VOLUNTEER'
            : 'FREE PLAN';

    final memberSince = isMember && activeMembership!.startDate != null
        ? 'Member since ${activeMembership!.startDate!.month}/${activeMembership!.startDate!.year}'
        : null;

    final description = isMember
        ? 'Full access to Base42'
        : isVolunteer
            ? 'Contributing member access'
            : 'Basic access at Base42';

    final String? price = isMember
        ? MembershipPricing.priceForTier(activeMembership!.tier)
        : null;

    final String? interval = isMember
        ? MembershipPricing.intervalForTier(activeMembership!.tier)
        : null;

    final String? badgeLabel = isMember
        ? activeMembership!.status.toUpperCase()
        : isVolunteer
            ? 'ACTIVE'
            : null;

    final Color? badgeBg;
    final Color? badgeText;
    if (isMember) {
      final status = activeMembership!.status;
      if (status == 'active') {
        badgeBg = primaryAccent.withValues(alpha: 0.15);
        badgeText = primaryAccent;
      } else if (status == 'cancelled') {
        badgeBg = onSurface.withValues(alpha: 0.12);
        badgeText = onSurface.withValues(alpha: 0.6);
      } else if (status == 'pending') {
        badgeBg = Colors.orange.withValues(alpha: 0.2);
        badgeText = Colors.orange;
      } else {
        badgeBg = onSurface.withValues(alpha: 0.12);
        badgeText = onSurface.withValues(alpha: 0.6);
      }
    } else if (isVolunteer) {
      badgeBg = primaryAccent.withValues(alpha: 0.15);
      badgeText = primaryAccent;
    } else {
      badgeBg = null;
      badgeText = null;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surfaceContainerHighest : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: onSurface.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: primaryAccent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(
                  isMember
                      ? Icons.card_membership_rounded
                      : Icons.person_outline_rounded,
                  color: primaryAccent,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      planLabel,
                      style: context.textStyles.headlineSmall?.bold.withColor(
                        onSurface,
                      ),
                    ),
                    if (memberSince != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          memberSince,
                          style: context.textStyles.bodyMedium?.withColor(
                            onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (badgeLabel != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: badgeBg,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Text(
                badgeLabel,
                style: context.textStyles.labelSmall?.bold.withColor(
                  badgeText!,
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              description,
              style: context.textStyles.bodyMedium?.withColor(
                onSurface.withValues(alpha: 0.55),
              ),
            ),
          ),
          if (price != null) ...[
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    price,
                    style: context.textStyles.headlineMedium?.bold.withColor(
                      onSurface,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      '/$interval',
                      style: context.textStyles.titleMedium?.medium.withColor(
                        onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

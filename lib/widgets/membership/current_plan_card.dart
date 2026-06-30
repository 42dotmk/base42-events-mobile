import 'package:flutter/material.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/models/membership.dart';

class CurrentPlanCard extends StatelessWidget {
  final String userType;
  final Membership? activeMembership;
  final Color accentColor;
  final Color onSurface;

  const CurrentPlanCard({
    super.key,
    required this.userType,
    this.activeMembership,
    required this.accentColor,
    required this.onSurface,
  });

  @override
  Widget build(BuildContext context) {
    if (userType == 'member') {
      return _buildMemberCard(context);
    }
    if (userType == 'volunteer') {
      return _buildVolunteerCard(context);
    }
    return _buildFreePlanCard(context);
  }

  Widget _buildFreePlanCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            onSurface.withValues(alpha: 0.06),
            onSurface.withValues(alpha: 0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: onSurface.withValues(alpha: 0.12),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: onSurface.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(
                  Icons.person_outline_rounded,
                  color: onSurface.withValues(alpha: 0.7),
                  size: 28,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FREE PLAN',
                    style: context.textStyles.titleLarge?.bold.withColor(
                      onSurface.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Enjoying basic access',
                    style: context.textStyles.bodyMedium?.withColor(
                      onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Upgrade to unlock 24/7 access, 3D printers, electronics lab, and more.',
            style: context.textStyles.bodyMedium?.withColor(
              onSurface.withValues(alpha: 0.55),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVolunteerCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accentColor.withValues(alpha: 0.12),
            accentColor.withValues(alpha: 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.25),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(
                  Icons.favorite_outline_rounded,
                  color: accentColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'VOLUNTEER',
                    style: context.textStyles.titleLarge?.bold.withColor(
                      accentColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Thank you for contributing!',
                    style: context.textStyles.bodyMedium?.withColor(
                      onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                color: accentColor,
                size: 18,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Community contributor',
                style: context.textStyles.bodyMedium?.semiBold.withColor(
                  accentColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMemberCard(BuildContext context) {
    final membership = activeMembership;
    final startDate = membership?.startDate;
    final formattedDate = startDate != null
        ? '${startDate.month}/${startDate.year}'
        : null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accentColor.withValues(alpha: 0.15),
            accentColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.1),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(
                  Icons.card_membership_rounded,
                  color: accentColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      membership != null ? membership.displayTier.toUpperCase() : 'MEMBER',
                      style: context.textStyles.titleLarge?.bold.withColor(
                        accentColor,
                      ),
                    ),
                    if (formattedDate != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Member since $formattedDate',
                        style: context.textStyles.bodyMedium?.withColor(
                          onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (membership != null) _buildStatusBadge(context, membership.status),
            ],
          ),
          if (membership != null) ...[
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Text(
                  '\$10',
                  style: context.textStyles.displaySmall?.bold.withColor(
                    accentColor,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    '/month',
                    style: context.textStyles.titleMedium?.medium.withColor(
                      onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, String status) {
    final Color bgColor;
    final Color textColor;
    final String label;

    switch (status) {
      case 'active':
        bgColor = accentColor.withValues(alpha: 0.2);
        textColor = accentColor;
        label = 'ACTIVE';
      case 'cancelled':
        bgColor = onSurface.withValues(alpha: 0.12);
        textColor = onSurface.withValues(alpha: 0.6);
        label = 'CANCELLED';
      case 'pending':
        bgColor = Colors.orange.withValues(alpha: 0.2);
        textColor = Colors.orange;
        label = 'PENDING';
      default:
        bgColor = onSurface.withValues(alpha: 0.12);
        textColor = onSurface.withValues(alpha: 0.6);
        label = status.toUpperCase();
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        label,
        style: context.textStyles.labelSmall?.bold.withColor(textColor),
      ),
    );
  }
}

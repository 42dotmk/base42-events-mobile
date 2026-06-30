import 'package:flutter/material.dart';
import 'package:base42_events_mobile/theme.dart';

class MembershipCard extends StatelessWidget {
  final Color accentColor;
  final Color secondaryAccent;
  final Color onSurface;

  const MembershipCard({
    super.key,
    required this.accentColor,
    required this.secondaryAccent,
    required this.onSurface,
  });



  @override
  Widget build(BuildContext context) {

   final accentColor = Theme.of(context).colorScheme.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accentColor.withValues(alpha: 0.15),
            secondaryAccent.withValues(alpha: 0.08),
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
              Text(
                'BASE42 MEMBER',
                style: context.textStyles.titleLarge?.bold.withColor(accentColor),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$10',
                style: context.textStyles.displaySmall?.bold.withColor(
                  accentColor,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '/month',
                  style: context.textStyles.titleMedium?.medium.withColor(
                    onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle_outline_rounded,
                  color: accentColor,
                  size: 18,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'All perks included',
                  style: context.textStyles.bodyMedium?.semiBold.withColor(
                    accentColor,
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

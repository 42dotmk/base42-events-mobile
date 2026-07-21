import 'package:base42_events_mobile/consts/membership_pricing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/nav.dart';
import 'package:base42_events_mobile/widgets/common/custom_button.dart';

class UpgradeCTACard extends StatelessWidget {
  final Color accentColor;
  final Color secondaryAccent;
  final Color onSurface;
  final Color surface;

  const UpgradeCTACard({
    super.key,
    required this.accentColor,
    required this.secondaryAccent,
    required this.onSurface,
    required this.surface,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryAccent = accentColor;

    final perks = [
      '24/7 Base Access',
      '3D Printer Access',
      'Electronics Lab',
      'Priority Event Access',
    ];

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
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: primaryAccent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  color: primaryAccent,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Unlock All Perks',
                style: context.textStyles.headlineSmall?.bold.withColor(
                  onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Become a member and get access to everything Base42 has to offer.',
            style: context.textStyles.bodyMedium?.withColor(
              onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 16),
          ...perks.map(
            (perk) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                children: [
                  Icon(
                    Icons.check_rounded,
                    color: primaryAccent,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    perk,
                    style: context.textStyles.bodyMedium?.withColor(
                      onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Text(
                MembershipPricing.monthlyPrice,
                style: context.textStyles.headlineMedium?.bold.withColor(
                  onSurface,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  '/month',
                  style: context.textStyles.titleMedium?.medium.withColor(
                    onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          CustomButton.action(
            label: 'Become a Member',
            color: secondaryAccent,
            variant: ButtonVariant.solid,
            onTap: () => context.push(AppRoutes.member),
          ),
        ],
      ),
    );
  }
}

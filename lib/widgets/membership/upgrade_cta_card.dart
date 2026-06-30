import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/nav.dart';

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
    final perks = [
      '24/7 Base Access',
      '3D Printer Access',
      'Electronics Lab',
      'Priority Event Access',
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accentColor.withValues(alpha: 0.12),
            secondaryAccent.withValues(alpha: 0.06),
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
                  color: accentColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  color: accentColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                'Unlock All Perks',
                style: context.textStyles.titleLarge?.bold.withColor(
                  accentColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Become a member and get access to everything Base42 has to offer.',
            style: context.textStyles.bodyMedium?.withColor(
              onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ...perks.map(
            (perk) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                children: [
                  Icon(
                    Icons.check_rounded,
                    color: accentColor,
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
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Text(
                '\$10',
                style: context.textStyles.headlineMedium?.bold.withColor(
                  accentColor,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  '/month',
                  style: context.textStyles.titleMedium?.medium.withColor(
                    onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => context.push(AppRoutes.member),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
              child: Text(
                'Become a Member',
                style: context.textStyles.titleMedium?.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

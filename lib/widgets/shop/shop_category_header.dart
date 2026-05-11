import 'package:base42_events_mobile/theme.dart';
import 'package:flutter/material.dart';

class ShopCategoryHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAll;

  const ShopCategoryHeader({super.key, required this.title, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Text(
            title,
            style: context.textStyles.titleMedium?.bold.withColor(
              colorScheme.onSurface,
            ),
          ),
          const Spacer(),
          if (onViewAll != null)
            GestureDetector(
              onTap: onViewAll,
              child: Text(
                'See all',
                style: context.textStyles.bodySmall?.semiBold.withColor(
                  colorScheme.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

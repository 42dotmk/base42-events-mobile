import 'package:base42_events_mobile/models/shop_item.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:flutter/material.dart';
import 'package:iconoir_flutter/regular/shopping_bag_plus.dart';

class ShopItemCard extends StatelessWidget {
  final ShopItem item;
  final VoidCallback onBuyTap;

  const ShopItemCard({super.key, required this.item, required this.onBuyTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final brand = Theme.of(context).extension<BrandTheme>();

    return SizedBox(
      width: 180,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadius.lg),
                ),
                child: Image.network(
                  item.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: colorScheme.surfaceContainerHighest,
                      child: Center(
                        child: Icon(
                          Icons.image_rounded,
                          size: 40,
                          color: colorScheme.onSurface.withValues(alpha: 0.3),
                        ),
                      ),
                    );
                  },
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: colorScheme.surfaceContainerHighest,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.sm,
                AppSpacing.sm,
                AppSpacing.sm,
                AppSpacing.xs,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.textStyles.titleSmall?.semiBold.withColor(
                      colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.textStyles.bodySmall?.withColor(
                      colorScheme.onSurface.withValues(alpha: 0.55),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Text(
                        '\$${item.price.toStringAsFixed(0)}',
                        style: context.textStyles.titleMedium?.bold.withColor(
                          brand?.neonCyan ?? colorScheme.primary,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 34,
                        child: FilledButton.icon(
                          onPressed: onBuyTap,
                          icon: ShoppingBagPlus(
                            color: colorScheme.onPrimary,
                            width: 16,
                            height: 16,
                          ),
                          label: const Text(
                            'Buy',
                            style: TextStyle(fontSize: 12),
                          ),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppRadius.sm),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

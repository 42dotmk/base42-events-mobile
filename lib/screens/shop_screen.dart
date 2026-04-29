import 'package:base42_events_mobile/models/shop_item.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/widgets/shop/shop_item_card.dart';
import 'package:flutter/material.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  static final List<ShopItem> _shopItems = const [
    ShopItem(
      name: '42 T-Shirt',
      description: 'Classic cotton tee with the 42 logo.',
      imageUrl: 'https://picsum.photos/seed/tshirt/400/300',
      price: 25.0,
    ),
    ShopItem(
      name: '42 Hoodie',
      description: 'Warm hoodie for cold hack nights.',
      imageUrl: 'https://picsum.photos/seed/hoodie/400/300',
      price: 55.0,
    ),
    ShopItem(
      name: '42 Sticker Pack',
      description: 'A set of 5 vinyl stickers.',
      imageUrl: 'https://picsum.photos/seed/stickers/400/300',
      price: 8.0,
    ),
    ShopItem(
      name: '42 Cap',
      description: 'Adjustable snapback with logo.',
      imageUrl: 'https://picsum.photos/seed/cap/400/300',
      price: 20.0,
    ),
    ShopItem(
      name: '42 Notebook',
      description: 'A5 lined notebook, 100 pages.',
      imageUrl: 'https://picsum.photos/seed/notebook/400/300',
      price: 12.0,
    ),
    ShopItem(
      name: '42 Mug',
      description: ' Ceramic mug, 300ml.',
      imageUrl: 'https://picsum.photos/seed/mug/400/300',
      price: 15.0,
    ),
  ];

  void _onBuyTap(BuildContext context, ShopItem item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${item.name} - \$${item.price.toStringAsFixed(2)} coming soon!',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Shop',
                      style: context.textStyles.headlineSmall?.bold.withColor(
                        colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Get your 42 gear',
                      style: context.textStyles.bodySmall?.withColor(
                        colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _shopItems.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.shopping_bag_outlined,
                                size: 42,
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.45,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'No items available',
                                style: context.textStyles.titleMedium
                                    ?.withColor(
                                      colorScheme.onSurface.withValues(
                                        alpha: 0.72,
                                      ),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 14,
                              crossAxisSpacing: 14,
                              childAspectRatio: 0.7,
                            ),
                        itemCount: _shopItems.length,
                        itemBuilder: (context, index) {
                          final item = _shopItems[index];
                          return ShopItemCard(
                            item: item,
                            onBuyTap: () => _onBuyTap(context, item),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:base42_events_mobile/nav.dart';
import 'package:base42_events_mobile/models/shop_item.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/widgets/shop/shop_item_card.dart';
import 'package:base42_events_mobile/widgets/shop/shop_category_header.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  void _handleBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutes.home);
  }

  static final List<ShopItem> _base42Items = const [
    ShopItem(
      name: '42 T-Shirt',
      description: 'Classic cotton tee with the 42 logo.',
      imageUrl: 'https://picsum.photos/seed/tshirt/400/300',
      price: 25.0,
      category: 'base42',
    ),
    ShopItem(
      name: '42 Hoodie',
      description: 'Warm hoodie for cold hack nights.',
      imageUrl: 'https://picsum.photos/seed/hoodie/400/300',
      price: 55.0,
      category: 'base42',
    ),
    ShopItem(
      name: '42 Sticker Pack',
      description: 'A set of 5 vinyl stickers.',
      imageUrl: 'https://picsum.photos/seed/stickers/400/300',
      price: 8.0,
      category: 'base42',
    ),
    ShopItem(
      name: '42 Cap',
      description: 'Adjustable snapback with logo.',
      imageUrl: 'https://picsum.photos/seed/cap/400/300',
      price: 20.0,
      category: 'base42',
    ),
    ShopItem(
      name: '42 Mug',
      description: 'Ceramic mug, 300ml.',
      imageUrl: 'https://picsum.photos/seed/mug/400/300',
      price: 15.0,
      category: 'base42',
    ),
  ];

  static final List<ShopItem> _beerjsItems = const [
    ShopItem(
      name: 'BeerJS Tee',
      description: 'Official BeerJS meetup shirt.',
      imageUrl: 'https://picsum.photos/seed/beerjs1/400/300',
      price: 22.0,
      category: 'beerjs',
    ),
    ShopItem(
      name: 'BeerJS Cap',
      description: 'Limited edition meetup cap.',
      imageUrl: 'https://picsum.photos/seed/beerjs2/400/300',
      price: 18.0,
      category: 'beerjs',
    ),
    ShopItem(
      name: 'BeerJS Stickers',
      description: 'Waterproof BeerJS logo stickers.',
      imageUrl: 'https://picsum.photos/seed/beerjs3/400/300',
      price: 5.0,
      category: 'beerjs',
    ),
  ];

  static final List<ShopItem> _miscItems = const [
    ShopItem(
      name: '42 Notebook',
      description: 'A5 lined notebook, 100 pages.',
      imageUrl: 'https://picsum.photos/seed/notebook/400/300',
      price: 12.0,
      category: 'miscellaneous',
    ),
    ShopItem(
      name: 'USB Cable Kit',
      description: 'Multi-connector USB cable set.',
      imageUrl: 'https://picsum.photos/seed/usb/400/300',
      price: 10.0,
      category: 'miscellaneous',
    ),
    ShopItem(
      name: 'Dev Poster',
      description: 'A3 poster with coding cheatsheets.',
      imageUrl: 'https://picsum.photos/seed/poster/400/300',
      price: 7.0,
      category: 'miscellaneous',
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

  Widget _buildCategorySection(
    BuildContext context,
    String title,
    List<ShopItem> items,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShopCategoryHeader(title: title),
        SizedBox(
          height: 280,
          child: items.isEmpty
              ? Center(
                  child: Text(
                    'No items available',
                    style: context.textStyles.bodyMedium?.withColor(
                      colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                )
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ShopItemCard(
                      item: item,
                      onBuyTap: () => _onBuyTap(context, item),
                    );
                  },
                ),
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandTheme>();
    final colorScheme = Theme.of(context).colorScheme;
    final onSurface = colorScheme.onSurface;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: brand?.backdropGradient),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 18, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: onSurface,
                      ),
                      onPressed: () => _handleBack(context),
                    ),
                    Text(
                      'SHOP',
                      style: context.textStyles.headlineSmall?.bold.withColor(
                        onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(left: 18),
                child: Text(
                  'Get your Base42 gear',
                  style: context.textStyles.bodySmall?.withColor(
                    onSurface.withValues(alpha: 0.55),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCategorySection(
                        context,
                        'BASE42',
                        _base42Items,
                      ),
                      _buildCategorySection(
                        context,
                        'BEERJS',
                        _beerjsItems,
                      ),
                      _buildCategorySection(
                        context,
                        'MISCELLANEOUS',
                        _miscItems,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

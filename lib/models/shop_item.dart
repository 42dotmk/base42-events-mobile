class ShopItem {
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final String category;

  const ShopItem({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.category = 'miscellaneous',
  });
}

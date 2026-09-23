class Product {
  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    this.trackStock = true,
    this.imagePath,
    this.isActive = true,
  });

  final String id;
  final String name;
  final String category;
  final int price;
  final int stock;

  /// false = jasa: bebas dijual tanpa cek/kurangi stok.
  final bool trackStock;
  final String? imagePath;
  final bool isActive;

  bool get isService => !trackStock;
}

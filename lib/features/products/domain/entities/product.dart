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

  static const String defaultCategory = 'Lainnya';

  /// Kategori kosong/blank dinormalisasi ke "Lainnya".
  String get effectiveCategory =>
      category.trim().isEmpty ? defaultCategory : category.trim();

  Product copyWith({
    String? name,
    String? category,
    int? price,
    int? stock,
    bool? trackStock,
    String? imagePath,
    bool? isActive,
  }) =>
      Product(
        id: id,
        name: name ?? this.name,
        category: category ?? this.category,
        price: price ?? this.price,
        stock: stock ?? this.stock,
        trackStock: trackStock ?? this.trackStock,
        imagePath: imagePath ?? this.imagePath,
        isActive: isActive ?? this.isActive,
      );
}

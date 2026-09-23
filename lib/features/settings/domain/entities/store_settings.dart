class StoreSettings {
  const StoreSettings({
    required this.storeName,
    required this.taxPercent,
    this.maxDiscountPercent = 20,
    this.address,
    this.phone,
  });

  final String storeName;
  final int taxPercent;

  /// Batas persen diskon item & struk. 0 = tanpa batas.
  final int maxDiscountPercent;
  final String? address;
  final String? phone;
}

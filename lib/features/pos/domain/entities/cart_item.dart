import 'package:kasirapp/features/pos/domain/entities/discount.dart';

/// Satu baris keranjang. Harga = snapshot saat dimasukkan (anti berubah).
class CartItem {
  const CartItem({
    required this.productId,
    required this.name,
    required this.unitPrice,
    required this.qty,
    this.discount = const Discount(),
  });

  final String productId;
  final String name;
  final int unitPrice;
  final int qty;
  final Discount discount;

  int get lineGross => unitPrice * qty;

  /// Diskon line, di-clamp <= lineGross, percent di-clamp 0-100.
  int get lineDiscount {
    if (discount.isNone) return 0;
    switch (discount.type) {
      case DiscountType.none:
        return 0;
      case DiscountType.percent:
        final pct = discount.value.clamp(0, 100);
        return (lineGross * pct / 100).round().clamp(0, lineGross);
      case DiscountType.amount:
        return discount.value.clamp(0, lineGross);
    }
  }

  int get lineNet => lineGross - lineDiscount;

  CartItem copyWith({int? qty, Discount? discount}) => CartItem(
        productId: productId,
        name: name,
        unitPrice: unitPrice,
        qty: qty ?? this.qty,
        discount: discount ?? this.discount,
      );
}

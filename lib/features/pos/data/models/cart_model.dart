import 'package:kasirapp/features/pos/domain/entities/cart.dart';
import 'package:kasirapp/features/pos/domain/entities/cart_item.dart';
import 'package:kasirapp/features/pos/domain/entities/discount.dart';

/// Model data POS (mapping ke Drift di Fase 2).
/// Saat ini sebagai DTO murni agar pola data/ jelas.
class CartModel {
  const CartModel({required this.cart});

  final Cart cart;

  Map<String, Object?> toMap() => {
        'item_count': cart.items.length,
        'tax_percent': cart.taxPercent,
        'customer_id': cart.customerId,
      };

  static CartItem itemFromMap(Map<String, Object?> map) => CartItem(
        productId: map['product_id'] as String,
        name: map['name'] as String,
        unitPrice: (map['unit_price'] as num).toInt(),
        qty: (map['qty'] as num).toInt(),
        discount: Discount(
          type: DiscountType.values[(map['discount_type'] as num?)?.toInt() ??
              DiscountType.none.index],
          value: (map['discount_value'] as num?)?.toInt() ?? 0,
        ),
      );
}

import 'package:kasirapp/features/pos/domain/entities/cart_item.dart';
import 'package:kasirapp/features/pos/domain/entities/discount.dart';

/// Keranjang belanja + diskon struk + pajak persen.
class Cart {
  const Cart({
    this.items = const [],
    this.receiptDiscount = const Discount(),
    this.taxPercent = 10,
    this.customerId,
  });

  final List<CartItem> items;
  final Discount receiptDiscount;
  final int taxPercent;
  final String? customerId;

  bool get isEmpty => items.isEmpty;

  Cart copyWith({
    List<CartItem>? items,
    Discount? receiptDiscount,
    int? taxPercent,
    String? customerId,
    bool clearCustomer = false,
  }) =>
      Cart(
        items: items ?? this.items,
        receiptDiscount: receiptDiscount ?? this.receiptDiscount,
        taxPercent: taxPercent ?? this.taxPercent,
        customerId:
            clearCustomer ? null : (customerId ?? this.customerId),
      );
}

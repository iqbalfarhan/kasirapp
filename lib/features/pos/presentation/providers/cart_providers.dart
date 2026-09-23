import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/data/providers.dart';
import 'package:kasirapp/features/pos/data/repositories/pos_repository_impl.dart';
import 'package:kasirapp/features/pos/domain/entities/cart.dart';
import 'package:kasirapp/features/pos/domain/entities/cart_item.dart';
import 'package:kasirapp/features/pos/domain/entities/checkout_result.dart';
import 'package:kasirapp/features/pos/domain/entities/discount.dart';
import 'package:kasirapp/features/pos/domain/repositories/pos_repository.dart';
import 'package:kasirapp/features/pos/domain/usecases/calculate_total.dart';
import 'package:kasirapp/features/products/domain/entities/product.dart';
import 'package:kasirapp/features/settings/presentation/providers/auth_providers.dart';

final posRepositoryProvider = Provider<PosRepository>(
  (ref) => PosRepositoryImpl(ref.watch(databaseProvider)),
);

/// Keranjang belanja. Harga snapshot saat produk masuk keranjang.
class CartNotifier extends StateNotifier<Cart> {
  CartNotifier() : super(const Cart());

  /// null = ok, String = pesan penolakan (nonaktif / stok habis).
  String? addProduct(Product product) {
    if (!product.isActive) return '${product.name} nonaktif';
    final existing = _find(product.id);
    final qty = (existing?.qty ?? 0) + 1;
    if (product.trackStock && qty > product.stock) {
      return 'Stok ${product.name} habis (sisa ${product.stock})';
    }
    if (existing == null) {
      state = state.copyWith(items: [
        ...state.items,
        CartItem(
          productId: product.id,
          name: product.name,
          unitPrice: product.price,
          qty: 1,
        ),
      ]);
    } else {
      _replace(existing.copyWith(qty: qty));
    }
    return null;
  }

  String? setQty(String productId, int qty, {int? stockCap}) {
    final existing = _find(productId);
    if (existing == null) return null;
    if (qty <= 0) {
      removeItem(productId);
      return null;
    }
    if (stockCap != null && qty > stockCap) {
      return 'Maksimal $stockCap';
    }
    _replace(existing.copyWith(qty: qty));
    return null;
  }

  void removeItem(String productId) {
    state = state.copyWith(
      items: state.items.where((e) => e.productId != productId).toList(),
    );
  }

  void setItemDiscount(String productId, Discount discount) {
    final existing = _find(productId);
    if (existing == null) return;
    _replace(existing.copyWith(discount: discount));
  }

  void setReceiptDiscount(Discount discount) {
    state = state.copyWith(receiptDiscount: discount);
  }

  void setTaxPercent(int percent) {
    state = state.copyWith(taxPercent: percent);
  }

  void setCustomer(String? customerId) {
    state = state.copyWith(customerId: customerId, clearCustomer: customerId == null);
  }

  void clear() => state = Cart(taxPercent: state.taxPercent);

  CartItem? _find(String productId) {
    for (final e in state.items) {
      if (e.productId == productId) return e;
    }
    return null;
  }

  void _replace(CartItem updated) {
    state = state.copyWith(
      items: [
        for (final e in state.items)
          if (e.productId == updated.productId) updated else e,
      ],
    );
  }
}

final cartProvider =
    StateNotifierProvider<CartNotifier, Cart>((ref) => CartNotifier());

/// Metode bayar aktif di checkout sheet.
final paymentMethodProvider = StateProvider<String>((ref) => 'tunai');

/// Nominal bayar (IDR) yang diketik kasir.
final paymentInputProvider = StateProvider<int>((ref) => 0);

/// Preview angka live — murni dari domain, tanpa validasi bayar.
final cartTotalsProvider = Provider<CartTotals>((ref) {
  return summarizeCart(ref.watch(cartProvider));
});

/// Preview checkout lengkap (termasuk validasi bayar); error = pesan validasi.
final checkoutPreviewProvider =
    FutureProvider<CheckoutResult>((ref) async {
  final cart = ref.watch(cartProvider);
  final settings = ref.watch(settingsProvider).valueOrNull;
  final result = await const CalculateTotal()(CalculateTotalParams(
    cart: cart,
    payment: ref.watch(paymentInputProvider),
    paymentMethod: ref.watch(paymentMethodProvider),
    maxDiscountPercent: settings?.maxDiscountPercent ?? 20,
  ));
  return switch (result) {
    Success() => result.data,
    FailureResult() => throw result.failure.message,
  };
});

import 'package:flutter_test/flutter_test.dart';
import 'package:kasirapp/features/pos/domain/entities/cart.dart';
import 'package:kasirapp/features/pos/domain/entities/cart_item.dart';
import 'package:kasirapp/features/pos/domain/entities/discount.dart';
import 'package:kasirapp/features/pos/domain/usecases/calculate_total.dart';
import 'package:kasirapp/core/result/result.dart';

/// Test pola Full Clean untuk aturan PLAN §1 + hasil review:
/// snapshot pajak, batas diskon, non-tunai wajib pas.
void main() {
  const useCase = CalculateTotal();

  Future<CheckoutResultData> calc(
    Cart cart,
    int payment, {
    String paymentMethod = 'tunai',
    int maxDiscountPercent = 20,
  }) async {
    final result = await useCase(CalculateTotalParams(
      cart: cart,
      payment: payment,
      paymentMethod: paymentMethod,
      maxDiscountPercent: maxDiscountPercent,
    ));
    switch (result) {
      case FailureResult():
        throw StateError(result.failure.message);
      case Success():
        return CheckoutResultData(
            total: result.data.total, change: result.data.change);
    }
  }

  Future<String?> calcError(
    Cart cart,
    int payment, {
    String paymentMethod = 'tunai',
    int maxDiscountPercent = 20,
  }) async {
    final result = await useCase(CalculateTotalParams(
      cart: cart,
      payment: payment,
      paymentMethod: paymentMethod,
      maxDiscountPercent: maxDiscountPercent,
    ));
    return switch (result) {
      FailureResult() => result.failure.message,
      Success() => null,
    };
  }

  test('tanpa diskon + pajak 10%: 2x10000 bayar 25000', () async {
    const cart = Cart(
      items: [
        CartItem(productId: 'p1', name: 'Kopi', unitPrice: 10000, qty: 2),
      ],
      taxPercent: 10,
    );
    final r = await calc(cart, 25000);
    // subtotal 20000 + pajak 2000 = 22000, kembali 3000
    expect(r.total, 22000);
    expect(r.change, 3000);
  });

  test('diskon item 10% + diskon struk Rp 1000', () async {
    const cart = Cart(
      items: [
        CartItem(
          productId: 'p1',
          name: 'Teh',
          unitPrice: 10000,
          qty: 1,
          discount: Discount(type: DiscountType.percent, value: 10),
        ),
      ],
      receiptDiscount: Discount(type: DiscountType.amount, value: 1000),
      taxPercent: 10,
    );
    final r = await calc(cart, 10000);
    // 10000-1000=9000, -1000=8000, +pajak 800 = 8800
    expect(r.total, 8800);
  });

  test('non-tunai wajib uang pas', () async {
    const cart = Cart(
      items: [
        CartItem(productId: 'p1', name: 'Kopi', unitPrice: 10000, qty: 1),
      ],
      taxPercent: 10,
    );
    // total = 11000; bayar lebih via qris harus gagal
    final err = await calcError(cart, 15000, paymentMethod: 'qris');
    expect(err, isNotNull);
    // bayar pas harus sukses dengan kembalian 0
    final ok = await calc(cart, 11000, paymentMethod: 'qris');
    expect(ok.total, 11000);
    expect(ok.change, 0);
  });

  test('diskon persen melebihi batas ditolak', () async {
    const cart = Cart(
      items: [
        CartItem(
          productId: 'p1',
          name: 'Kopi',
          unitPrice: 10000,
          qty: 1,
          discount: Discount(type: DiscountType.percent, value: 50),
        ),
      ],
      taxPercent: 10,
    );
    final err = await calcError(cart, 10000, maxDiscountPercent: 20);
    expect(err, contains('batas'));
  });
}

class CheckoutResultData {
  const CheckoutResultData({required this.total, required this.change});
  final int total;
  final int change;
}

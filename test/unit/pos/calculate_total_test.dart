import 'package:flutter_test/flutter_test.dart';
import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/features/pos/domain/entities/cart.dart';
import 'package:kasirapp/features/pos/domain/entities/cart_item.dart';
import 'package:kasirapp/features/pos/domain/entities/checkout_result.dart';
import 'package:kasirapp/features/pos/domain/entities/discount.dart';
import 'package:kasirapp/features/pos/domain/usecases/calculate_total.dart';

/// Fulltest aturan PLAN §1: 20+ kasus (clamp, rounding, batas, uang pas).
void main() {
  const useCase = CalculateTotal();
  const pct10 = Discount(type: DiscountType.percent, value: 10);

  Future<CheckoutResult> ok(
    Cart cart,
    int payment, {
    String method = 'tunai',
    int maxPct = 20,
  }) async {
    final r = await useCase(CalculateTotalParams(
      cart: cart,
      payment: payment,
      paymentMethod: method,
      maxDiscountPercent: maxPct,
    ));
    if (r is FailureResult<CheckoutResult>) {
      fail('seharusnya sukses: ${r.failure.message}');
    }
    return (r as Success<CheckoutResult>).data;
  }

  Future<String> err(
    Cart cart,
    int payment, {
    String method = 'tunai',
    int maxPct = 20,
  }) async {
    final r = await useCase(CalculateTotalParams(
      cart: cart,
      payment: payment,
      paymentMethod: method,
      maxDiscountPercent: maxPct,
    ));
    expect(r, isA<FailureResult<CheckoutResult>>());
    return (r as FailureResult<CheckoutResult>).failure.message;
  }

  CartItem item(String id, int price, int qty,
          [Discount d = const Discount()]) =>
      CartItem(productId: id, name: id, unitPrice: price, qty: qty, discount: d);

  group('validasi dasar', () {
    test('01 keranjang kosong ditolak', () async {
      await err(const Cart(), 0);
    });
    test('02 pajak negatif ditolak', () async {
      await err(Cart(items: [item('a', 1000, 1)], taxPercent: -1), 1000);
    });
    test('03 pajak >100 ditolak', () async {
      await err(Cart(items: [item('a', 1000, 1)], taxPercent: 101), 2000);
    });
    test('04 batas diskon invalid ditolak', () async {
      await err(Cart(items: [item('a', 1000, 1)]), 1100, maxPct: 101);
    });
  });

  group('tanpa diskon', () {
    test('05 total = subtotal + pajak 10%', () async {
      final r = await ok(
          Cart(items: [item('kopi', 10000, 2)]), 25000);
      expect(r.total, 22000);
      expect(r.change, 3000);
      expect(r.subtotalGross, 20000);
      expect(r.tax, 2000);
    });
    test('06 pajak 0%', () async {
      final r = await ok(
          Cart(items: [item('a', 10000, 1)], taxPercent: 0), 10000);
      expect(r.total, 10000);
      expect(r.change, 0);
    });
    test('07 pembulatan pajak 3333x10% = 333', () async {
      final r = await ok(
          Cart(items: [item('a', 3333, 1)], taxPercent: 10), 4000);
      expect(r.tax, 333);
      expect(r.total, 3666);
    });
    test('08 bayar pas kembalian 0', () async {
      final r = await ok(Cart(items: [item('a', 10000, 1)]), 11000);
      expect(r.change, 0);
    });
    test('09 bayar kurang ditolak', () async {
      await err(Cart(items: [item('a', 10000, 1)]), 10999);
    });
    test('10 multi item dijumlah', () async {
      final r = await ok(
          Cart(items: [item('a', 10000, 1), item('b', 5000, 3)]),
          30000);
      expect(r.subtotalGross, 25000);
      expect(r.total, 27500);
    });
  });

  group('diskon item', () {
    test('11 persen 10% per line', () async {
      final r = await ok(
          Cart(items: [item('a', 10000, 1, pct10)]), 10000);
      expect(r.itemDiscountTotal, 1000);
      expect(r.total, 9900); // 9000 + 900
    });
    test('12 nominal di-clamp ke line total', () async {
      const d = Discount(type: DiscountType.amount, value: 99999);
      final r = await ok(
          Cart(items: [item('a', 10000, 1, d)], taxPercent: 0), 0);
      expect(r.total, 0);
    });
    test('13 persen 100% menghabiskan line', () async {
      const d = Discount(type: DiscountType.percent, value: 100);
      final r = await ok(
          Cart(items: [item('a', 10000, 1, d)],
              taxPercent: 10,
          ),
          0,
          maxPct: 100);
      expect(r.total, 0);
    });
    test('14 persen > batas ditolak; maxPct 0 = bebas', () async {
      const d = Discount(type: DiscountType.percent, value: 50);
      await err(Cart(items: [item('a', 10000, 1, d)]), 10000, maxPct: 20);
      final r = await ok(Cart(items: [item('a', 10000, 1, d)]), 10000,
          maxPct: 0);
      expect(r.total, 5500); // 5000 + 500
    });
  });

  group('diskon struk', () {
    test('15 persen 10% dari sisa + kombinasi item', () async {
      const cart = Cart(
        items: [
          CartItem(
              productId: 'teh',
              name: 'Teh',
              unitPrice: 10000,
              qty: 1,
              discount: pct10),
        ],
        receiptDiscount: Discount(type: DiscountType.amount, value: 1000),
        taxPercent: 10,
      );
      final r = await ok(cart, 10000);
      expect(r.total, 8800);
    });
    test('16 persen struk dihitung setelah diskon item', () async {
      const d = Discount(type: DiscountType.percent, value: 10);
      final r = await ok(
          Cart(items: [item('a', 20000, 1)], receiptDiscount: d, taxPercent: 0),
          18000);
      expect(r.receiptDiscount, 2000);
      expect(r.total, 18000);
    });
    test('17 nominal struk > basis di-clamp', () async {
      const d = Discount(type: DiscountType.amount, value: 99999);
      final r = await ok(
          Cart(items: [item('a', 5000, 1)], receiptDiscount: d, taxPercent: 10),
          0);
      expect(r.total, 0);
    });
    test('18 persen struk > batas ditolak', () async {
      const d = Discount(type: DiscountType.percent, value: 25);
      await err(
          Cart(items: [item('a', 10000, 1)], receiptDiscount: d), 10000,
          maxPct: 20);
    });
    test('19 persen 100% + pajak = 0', () async {
      const d = Discount(type: DiscountType.percent, value: 100);
      final r = await ok(
          Cart(items: [item('a', 10000, 1)], receiptDiscount: d), 0,
          maxPct: 100);
      expect(r.total, 0);
    });
  });

  group('metode bayar', () {
    test('20 non-tunai lebih ditolak', () async {
      await err(Cart(items: [item('a', 10000, 1)]), 15000, method: 'qris');
    });
    test('21 non-tunai pas ok, case-insensitive', () async {
      final r = await ok(Cart(items: [item('a', 10000, 1)]), 11000,
          method: 'QRIS');
      expect(r.change, 0);
    });
    test('22 transfer pas ok', () async {
      final r = await ok(Cart(items: [item('a', 10000, 1)]), 11000,
          method: 'transfer');
      expect(r.total, 11000);
    });
  });
}

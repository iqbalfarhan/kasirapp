import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasirapp/data/db.dart';
import 'package:kasirapp/data/providers.dart';
import 'package:kasirapp/features/pos/domain/entities/cart.dart';
import 'package:kasirapp/features/pos/domain/entities/cart_item.dart';
import 'package:kasirapp/features/pos/domain/entities/checkout_result.dart';
import 'package:kasirapp/features/pos/domain/entities/discount.dart';
import 'package:kasirapp/features/pos/presentation/providers/cart_providers.dart';
import 'package:kasirapp/features/products/domain/entities/product.dart';

/// CartNotifier murni (tanpa DB): tambah, cap stok, qty, diskon, clear.
void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  ProviderContainer make() => ProviderContainer(
        overrides: [databaseProvider.overrideWithValue(db)],
      );
  const kopi = Product(
      id: 'p1', name: 'Kopi', category: 'Minuman', price: 10000, stock: 2);
  const cukur = Product(
      id: 'j1',
      name: 'Cukur',
      category: 'Jasa',
      price: 25000,
      stock: 0,
      trackStock: false);

  test('tambah produk + snapshot harga', () {
    final c = make();
    addTearDown(c.dispose);
    expect(c.read(cartProvider.notifier).addProduct(kopi), isNull);
    expect(c.read(cartProvider.notifier).addProduct(kopi), isNull);
    expect(c.read(cartProvider).items.single.qty, 2);
  });

  test('barang dibatasi stok, jasa bebas', () {
    final c = make();
    addTearDown(c.dispose);
    final notifier = c.read(cartProvider.notifier);
    expect(notifier.addProduct(kopi), isNull);
    expect(notifier.addProduct(kopi), isNull);
    expect(notifier.addProduct(kopi), isNotNull); // stok 2
    expect(c.read(cartProvider).items.single.qty, 2);

    expect(notifier.addProduct(cukur), isNull);
    expect(notifier.addProduct(cukur), isNull);
    expect(
        c.read(cartProvider).items
            .firstWhere((e) => e.productId == 'j1')
            .qty,
        2);
  });

  test('produk nonaktif ditolak', () {
    final c = make();
    addTearDown(c.dispose);
    const off = Product(
        id: 'x', name: 'Roti', category: 'A', price: 5000, stock: 9,
        isActive: false);
    expect(c.read(cartProvider.notifier).addProduct(off), isNotNull);
    expect(c.read(cartProvider).isEmpty, isTrue);
  });

  test('qty 0 menghapus item; clear mengosongkan', () {
    final c = make();
    addTearDown(c.dispose);
    final notifier = c.read(cartProvider.notifier);
    notifier.addProduct(kopi);
    notifier.setQty('p1', 0);
    expect(c.read(cartProvider).isEmpty, isTrue);

    notifier.addProduct(kopi);
    notifier.setReceiptDiscount(
        const Discount(type: DiscountType.percent, value: 5));
    notifier.clear();
    final cart = c.read(cartProvider);
    expect(cart.isEmpty, isTrue);
    expect(cart.receiptDiscount.isNone, isTrue);
  });

  test('preview totals sinkron dari domain', () {
    final c = make();
    addTearDown(c.dispose);
    c.read(cartProvider.notifier).addProduct(kopi);
    final t = c.read(cartTotalsProvider);
    expect(t.subtotalGross, 10000);
    expect(t.total, 11000); // pajak default cart 10%
  });

  test('checkoutPreview gagal saat bayar kurang', () async {
    final c = make();
    addTearDown(c.dispose);
    c.read(cartProvider.notifier).addProduct(kopi);
    c.read(paymentInputProvider.notifier).state = 1000;
    await expectLater(
      c.read(checkoutPreviewProvider.future),
      throwsA(contains('kurang')),
    );
  });

  test('checkoutPreview sukses saat uang pas', () async {
    final c = make();
    addTearDown(c.dispose);
    c.read(cartProvider.notifier).addProduct(kopi);
    c.read(paymentInputProvider.notifier).state = 11000;
    final r = await c.read(checkoutPreviewProvider.future);
    expect(r, isA<CheckoutResult>());
    expect(r.total, 11000);
    expect(CartItem(productId: 'a', name: 'a', unitPrice: 1, qty: 1)
        .lineNet, 1);
    expect(const Cart().isEmpty, isTrue);
  });
}

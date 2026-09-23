import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/data/db.dart';
import 'package:kasirapp/features/pos/data/repositories/pos_repository_impl.dart';
import 'package:kasirapp/features/pos/domain/entities/cart.dart';
import 'package:kasirapp/features/pos/domain/entities/cart_item.dart';
import 'package:kasirapp/features/pos/domain/entities/discount.dart';
import 'package:kasirapp/features/products/data/repositories/product_repository_impl.dart';
import 'package:kasirapp/features/products/domain/entities/product.dart';

/// Checkout atomik (memory DB): snapshot, stok, jasa, non-tunai.
void main() {
  late AppDatabase db;
  late PosRepositoryImpl pos;
  late ProductRepositoryImpl products;

  const kopi = Product(
      id: 'p1', name: 'Kopi', category: 'Minuman', price: 10000, stock: 5);
  const cukur = Product(
      id: 'j1',
      name: 'Cukur',
      category: 'Jasa',
      price: 25000,
      stock: 0,
      trackStock: false);

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    pos = PosRepositoryImpl(db);
    products = ProductRepositoryImpl(db);
    await products.saveProduct(kopi);
    await products.saveProduct(cukur);
  });

  tearDown(() => db.close());

  Cart cartOf(List<CartItem> items) => Cart(items: items, taxPercent: 10);

  test('tunai sukses: snapshot + stok berkurang', () async {
    final cart = cartOf(const [
      CartItem(productId: 'p1', name: 'Kopi', unitPrice: 10000, qty: 2),
    ]);
    final r = await pos.checkout(
      cart: cart,
      payment: 25000,
      cashierId: 'k1',
      paymentMethod: 'tunai',
    );
    expect(r, isA<Success<String>>());
    final txId = (r as Success<String>).data;

    final tx = await (db.select(db.transactions)
          ..where((t) => t.id.equals(txId)))
        .getSingle();
    expect(tx.total, 22000); // 20000 + pajak 10%
    expect(tx.kembalian, 3000);
    expect(tx.pajakPersen, 10);
    expect(tx.metode, 'tunai');

    final items = await (db.select(db.transactionItems)
          ..where((t) => t.transactionId.equals(txId)))
        .get();
    expect(items, hasLength(1));
    expect(items.single.namaSnapshot, 'Kopi');

    final row =
        await (db.select(db.products)..where((t) => t.id.equals('p1')))
            .getSingle();
    expect(row.stok, 3);
  });

  test('stok kurang → gagal, tanpa sisa transaksi', () async {
    final cart = cartOf(const [
      CartItem(productId: 'p1', name: 'Kopi', unitPrice: 10000, qty: 99),
    ]);
    final r = await pos.checkout(
      cart: cart,
      payment: 2000000,
      cashierId: 'k1',
      paymentMethod: 'tunai',
    );
    expect(r, isA<FailureResult<String>>());
    expect(await db.select(db.transactions).get(), isEmpty);

    final row =
        await (db.select(db.products)..where((t) => t.id.equals('p1')))
            .getSingle();
    expect(row.stok, 5); // tidak berkurang
  });

  test('jasa tanpa stok tetap bisa checkout', () async {
    final cart = cartOf(const [
      CartItem(
          productId: 'j1', name: 'Cukur', unitPrice: 25000, qty: 3),
    ]);
    final r = await pos.checkout(
      cart: cart,
      payment: 82500, // 75000 + pajak 7500
      cashierId: 'k1',
      paymentMethod: 'tunai',
    );
    expect(r, isA<Success<String>>());
  });

  test('qris wajib pas; lebih ditolak', () async {
    const item = CartItem(
        productId: 'p1', name: 'Kopi', unitPrice: 10000, qty: 1);
    final over = await pos.checkout(
      cart: cartOf(const [item]),
      payment: 15000,
      cashierId: 'k1',
      paymentMethod: 'qris',
    );
    expect(over, isA<FailureResult<String>>());

    final pas = await pos.checkout(
      cart: cartOf(const [item]),
      payment: 11000,
      cashierId: 'k1',
      paymentMethod: 'qris',
    );
    expect(pas, isA<Success<String>>());
    final txId = (pas as Success<String>).data;
    final tx = await (db.select(db.transactions)
          ..where((t) => t.id.equals(txId)))
        .getSingle();
    expect(tx.kembalian, 0);
  });

  test('diskon item + struk tersnapshot', () async {
    final cart = Cart(
      items: const [
        CartItem(
          productId: 'p1',
          name: 'Kopi',
          unitPrice: 10000,
          qty: 1,
          discount: Discount(type: DiscountType.percent, value: 10),
        ),
      ],
      receiptDiscount:
          const Discount(type: DiscountType.amount, value: 1000),
      taxPercent: 10,
    );
    final r = await pos.checkout(
      cart: cart,
      payment: 8800,
      cashierId: 'k1',
      paymentMethod: 'tunai',
    );
    expect(r, isA<Success<String>>());
    final tx = await (db.select(db.transactions)
          ..where((t) => t.id.equals((r as Success<String>).data)))
        .getSingle();
    expect(tx.diskonItem, 1000);
    expect(tx.diskonStrukNilai, 1000);
    expect(tx.total, 8800);
  });
}

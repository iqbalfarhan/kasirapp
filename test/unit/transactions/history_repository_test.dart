import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasirapp/core/period.dart';
import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/data/db.dart';
import 'package:kasirapp/features/pos/data/repositories/pos_repository_impl.dart';
import 'package:kasirapp/features/pos/domain/entities/cart.dart';
import 'package:kasirapp/features/pos/domain/entities/cart_item.dart';
import 'package:kasirapp/features/products/data/repositories/product_repository_impl.dart';
import 'package:kasirapp/features/products/domain/entities/product.dart';
import 'package:kasirapp/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:kasirapp/features/transactions/domain/entities/transaction.dart';
import 'package:kasirapp/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:kasirapp/features/transactions/domain/usecases/get_transactions.dart';
import 'package:kasirapp/features/transactions/domain/usecases/void_transaction.dart';

/// Riwayat + void (memory DB): range, detail, stok kembali, double-void.
void main() {
  late AppDatabase db;
  late TransactionRepository history;
  late PosRepositoryImpl pos;

  const kopi = Product(
      id: 'p1', name: 'Kopi', category: 'Minuman', price: 10000, stock: 5);
  const cukur = Product(
      id: 'j1',
      name: 'Cukur',
      category: 'Jasa',
      price: 25000,
      stock: 0,
      trackStock: false);

  Future<String> sell(List<CartItem> items, int payment) async {
    final r = await pos.checkout(
      cart: Cart(items: items, taxPercent: 10),
      payment: payment,
      cashierId: 'k1',
      paymentMethod: 'tunai',
    );
    return (r as Success<String>).data;
  }

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    history = TransactionRepositoryImpl(db);
    pos = PosRepositoryImpl(db);
    final products = ProductRepositoryImpl(db);
    await products.saveProduct(kopi);
    await products.saveProduct(cukur);
  });

  tearDown(() => db.close());

  test('range hari ini + detail + search ID', () async {
    final id = await sell(
        const [CartItem(productId: 'p1', name: 'Kopi', unitPrice: 10000, qty: 1)],
        11000);
    final range =
        resolvePeriod(ReportPeriodType.today, now: DateTime.now());

    final list = await GetTransactions(history)(
        GetTransactionsParams(start: range.start, end: range.end));
    expect((list as Success<List<Transaction>>).data, hasLength(1));

    final found = await history.getTransactions(
        start: range.start, end: range.end, query: id.substring(0, 6));
    expect((found as Success<List<Transaction>>).data, hasLength(1));

    final missing = await history.getTransactions(
        start: range.start, end: range.end, query: 'zzzzzz');
    expect((missing as Success<List<Transaction>>).data, isEmpty);

    final detail = await history.getDetail(id);
    expect((detail as Success<Transaction>).data.items, hasLength(1));
    expect(detail.data.total, 11000);
  });

  test('void mengembalikan stok + audit, double-void gagal', () async {
    final id = await sell(
        const [CartItem(productId: 'p1', name: 'Kopi', unitPrice: 10000, qty: 2)],
        22000);

    final voidUseCase =
        VoidTransaction(_FakeRepoForGuard(), isAdmin: false);
    // Guard admin di usecase (repo asli di bawah via admin=true).
    expect(
      await voidUseCase(
          VoidTransactionParams(id: id, reason: 'x', voidBy: 'a')),
      isA<FailureResult<void>>(),
    );

    final adminVoid =
        VoidTransaction(history, isAdmin: true);
    final ok = await adminVoid(
        VoidTransactionParams(id: id, reason: 'salah input', voidBy: 'Admin'));
    expect(ok, isA<Success<void>>());

    final detail =
        (await history.getDetail(id) as Success<Transaction>).data;
    expect(detail.isVoided, isTrue);
    expect(detail.voidReason, 'salah input');
    expect(detail.voidBy, 'Admin');
    expect(detail.voidAt, isNotNull);

    final row =
        await (db.select(db.products)..where((t) => t.id.equals('p1')))
            .getSingle();
    expect(row.stok, 5); // 5-2+2 kembali

    final again = await adminVoid(
        VoidTransactionParams(id: id, reason: 'lagi', voidBy: 'Admin'));
    expect(again, isA<FailureResult<void>>());
  });

  test('void tanpa alasan ditolak', () async {
    final id = await sell(
        const [CartItem(productId: 'p1', name: 'Kopi', unitPrice: 10000, qty: 1)],
        11000);
    final r = await VoidTransaction(history, isAdmin: true)(
        VoidTransactionParams(id: id, reason: ' ', voidBy: 'Admin'));
    expect(r, isA<FailureResult<void>>());
  });

  test('transaksi lama di luar range tidak ikut', () async {
    await sell(
        const [CartItem(productId: 'p1', name: 'Kopi', unitPrice: 10000, qty: 1)],
        11000);
    // Sisipkan transaksi 40 hari lalu langsung via DB.
    final old = DateTime.now().subtract(const Duration(days: 40));
    await db.into(db.transactions).insert(TransactionsCompanion.insert(
          id: 'old-tx',
          kasirId: 'k1',
          subtotal: 10000,
          diskonItem: 0,
          total: 11000,
          bayar: 11000,
          kembalian: 0,
          metode: 'tunai',
          createdAt: old.millisecondsSinceEpoch,
        ));
    final range =
        resolvePeriod(ReportPeriodType.today, now: DateTime.now());
    final list = await history.getTransactions(
        start: range.start, end: range.end);
    expect((list as Success<List<Transaction>>).data, hasLength(1));
  });
}

/// Repo dummy: hanya untuk membuktikan guard isAdmin=false menolak
/// sebelum menyentuh DB.
class _FakeRepoForGuard implements TransactionRepository {
  @override
  Future<Result<List<Transaction>>> getTransactions(
          {required DateTime start,
          required DateTime end,
          String? query}) =>
      throw UnimplementedError();

  @override
  Future<Result<Transaction>> getDetail(String id) =>
      throw UnimplementedError();

  @override
  Future<Result<void>> voidTransaction(
          VoidTransactionParams params) =>
      throw UnimplementedError();
}

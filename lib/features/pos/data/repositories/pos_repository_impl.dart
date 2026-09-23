import 'package:drift/drift.dart';
import 'package:kasirapp/core/error/failures.dart';
import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/data/db.dart';
import 'package:kasirapp/features/pos/domain/entities/cart.dart';
import 'package:kasirapp/features/pos/domain/entities/checkout_result.dart';
import 'package:kasirapp/features/pos/domain/repositories/pos_repository.dart';
import 'package:kasirapp/features/pos/domain/usecases/calculate_total.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// Abort internal agar `transaction()` Drift rollback otomatis.
class _CheckoutAbort implements Exception {
  const _CheckoutAbort(this.message);
  final String message;
}

class PosRepositoryImpl implements PosRepository {
  PosRepositoryImpl(this._db, {CalculateTotal? calculator})
      : _calculator = calculator ?? const CalculateTotal();

  final AppDatabase _db;
  final CalculateTotal _calculator;

  @override
  Future<Result<CheckoutResult>> calculate(
          CalculateTotalParams params) =>
      _calculator(params);

  @override
  Future<Result<String>> checkout({
    required Cart cart,
    required int payment,
    required String cashierId,
    required String paymentMethod,
    int maxDiscountPercent = 20,
    String? customerId,
  }) async {
    final calc = await _calculator(CalculateTotalParams(
      cart: cart,
      payment: payment,
      paymentMethod: paymentMethod,
      maxDiscountPercent: maxDiscountPercent,
    ));
    if (calc is FailureResult<CheckoutResult>) {
      return FailureResult<String>(calc.failure);
    }
    final totals = (calc as Success<CheckoutResult>).data;
    final now = DateTime.now().millisecondsSinceEpoch;

    try {
      final txId = await _db.transaction(() async {
        final id = _uuid.v4();
        final ids = cart.items.map((e) => e.productId).toSet().toList();
        final rows = await (_db.select(_db.products)
              ..where((t) => t.id.isIn(ids)))
            .get();
        final byId = {for (final r in rows) r.id: r};

        // Validasi stok barang di dalam transaksi (anti race).
        for (final item in cart.items) {
          final row = byId[item.productId];
          if (row == null || row.isActive != 1) {
            throw _CheckoutAbort('${item.name} tidak tersedia');
          }
          if (row.trackStock == 1 && row.stok < item.qty) {
            throw _CheckoutAbort(
                'Stok ${item.name} kurang (sisa ${row.stok})');
          }
          // Harga ikut master terbaru saat checkout? Tidak — snapshot
          // keranjang yang dipakai (harga dikunci saat masuk keranjang).
        }

        await _db.into(_db.transactions).insert(
              TransactionsCompanion.insert(
                id: id,
                customerId: Value(customerId ?? cart.customerId),
                kasirId: cashierId,
                subtotal: totals.subtotalGross,
                diskonItem: totals.itemDiscountTotal,
                diskonStrukTipe:
                    Value(cart.receiptDiscount.type.name),
                diskonStrukNilai: Value(cart.receiptDiscount.value),
                pajakPersen: Value(cart.taxPercent),
                pajakNilai: Value(totals.tax),
                total: totals.total,
                bayar: payment,
                kembalian: totals.change,
                metode: paymentMethod.toLowerCase(),
                createdAt: now,
              ),
            );

        for (final item in cart.items) {
          await _db.into(_db.transactionItems).insert(
                TransactionItemsCompanion.insert(
                  id: _uuid.v4(),
                  transactionId: id,
                  productId: item.productId,
                  namaSnapshot: item.name,
                  hargaSnapshot: item.unitPrice,
                  qty: item.qty,
                  diskonTipe: Value(item.discount.type.name),
                  diskonNilai: Value(item.discount.value),
                  subtotal: item.lineNet,
                ),
              );
          final row = byId[item.productId]!;
          if (row.trackStock == 1) {
            await (_db.update(_db.products)
                  ..where((t) => t.id.equals(item.productId)))
                .write(ProductsCompanion(
              stok: Value(row.stok - item.qty),
              updatedAt: Value(now),
            ));
          }
        }
        return id;
      });
      return Success(txId);
    } on _CheckoutAbort catch (e) {
      return FailureResult(ValidationFailure(e.message));
    } catch (e) {
      return FailureResult(DatabaseFailure('Gagal checkout: $e'));
    }
  }
}

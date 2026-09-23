import 'package:drift/drift.dart';
import 'package:kasirapp/core/error/failures.dart';
import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/data/db.dart';
import 'package:kasirapp/features/pos/domain/entities/discount.dart';
import 'package:kasirapp/features/transactions/domain/entities/transaction.dart';
import 'package:kasirapp/features/transactions/domain/repositories/transaction_repository.dart';

class _VoidAbort implements Exception {
  const _VoidAbort(this.message);
  final String message;
}

DiscountType _discountTypeOf(String raw) => DiscountType.values.firstWhere(
      (e) => e.name == raw,
      orElse: () => DiscountType.none,
    );

class TransactionRepositoryImpl implements TransactionRepository {
  const TransactionRepositoryImpl(this._db);
  final AppDatabase _db;

  TransactionItem _mapItem(DbTransactionItem row) => TransactionItem(
        productId: row.productId,
        nameSnapshot: row.namaSnapshot,
        unitPriceSnapshot: row.hargaSnapshot,
        qty: row.qty,
        subtotal: row.subtotal,
        discountType: _discountTypeOf(row.diskonTipe),
        discountValue: row.diskonNilai,
      );

  Transaction _map(DbTransaction row, List<TransactionItem> items) =>
      Transaction(
        id: row.id,
        customerId: row.customerId,
        cashierId: row.kasirId,
        subtotal: row.subtotal,
        itemDiscountTotal: row.diskonItem,
        receiptDiscountType: _discountTypeOf(row.diskonStrukTipe),
        receiptDiscountValue: row.diskonStrukNilai,
        receiptDiscountTotal:
            row.subtotal - row.diskonItem - (row.total - row.pajakNilai),
        taxPercent: row.pajakPersen,
        taxTotal: row.pajakNilai,
        total: row.total,
        payment: row.bayar,
        change: row.kembalian,
        paymentMethod: row.metode,
        createdAt:
            DateTime.fromMillisecondsSinceEpoch(row.createdAt),
        status: row.status == 'batal'
            ? TransactionStatus.voided
            : TransactionStatus.success,
        items: items,
        voidReason: row.voidReason,
        voidBy: row.voidBy,
        voidAt: row.voidAt == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(row.voidAt!),
      );

  Future<List<TransactionItem>> _itemsOf(String txId) async {
    final rows = await (_db.select(_db.transactionItems)
          ..where((t) => t.transactionId.equals(txId)))
        .get();
    return rows.map(_mapItem).toList();
  }

  @override
  Future<Result<List<Transaction>>> getTransactions(
      {required DateTime start,
      required DateTime end,
      String? query}) async {
    try {
      final like = query?.trim();
      final startMs = start.millisecondsSinceEpoch;
      final endMs = end.millisecondsSinceEpoch;

      List<DbTransaction> headers;
      if (like != null && like.isNotEmpty) {
        // Cari ID transaksi atau nama pelanggan (join).
        final q = _db.select(_db.transactions).join([
          leftOuterJoin(
            _db.customers,
            _db.customers.id.equalsExp(_db.transactions.customerId),
          ),
        ])
          ..where(_db.transactions.createdAt
                  .isBiggerOrEqualValue(startMs) &
              _db.transactions.createdAt.isSmallerOrEqualValue(endMs) &
              (_db.transactions.id.like('%$like%') |
                  _db.customers.nama.like('%$like%')))
          ..orderBy(
              [OrderingTerm.desc(_db.transactions.createdAt)]);
        headers = [
          for (final row in await q.get())
            row.readTable(_db.transactions)
        ];
      } else {
        headers = await (_db.select(_db.transactions)
              ..where((t) =>
                  t.createdAt.isBiggerOrEqualValue(startMs) &
                  t.createdAt.isSmallerOrEqualValue(endMs))
              ..orderBy(
                  [(t) => OrderingTerm.desc(t.createdAt)]))
            .get();
      }

      final result = <Transaction>[];
      for (final h in headers) {
        result.add(_map(h, await _itemsOf(h.id)));
      }
      return Success(result);
    } catch (e) {
      return FailureResult(DatabaseFailure('Gagal memuat riwayat: $e'));
    }
  }

  @override
  Future<Result<Transaction>> getDetail(String id) async {
    try {
      final row = await (_db.select(_db.transactions)
            ..where((t) => t.id.equals(id)))
          .getSingleOrNull();
      if (row == null) {
        return const FailureResult(
            NotFoundFailure('Transaksi tidak ditemukan'));
      }
      return Success(_map(row, await _itemsOf(id)));
    } catch (e) {
      return FailureResult(DatabaseFailure('Gagal memuat detail: $e'));
    }
  }

  @override
  Future<Result<void>> voidTransaction(
      VoidTransactionParams params) async {
    if (params.reason.trim().isEmpty) {
      return const FailureResult(
          ValidationFailure('Alasan void wajib diisi'));
    }
    try {
      await _db.transaction(() async {
        final tx = await (_db.select(_db.transactions)
              ..where((t) => t.id.equals(params.id)))
            .getSingleOrNull();
        if (tx == null) {
          throw const _VoidAbort('Transaksi tidak ditemukan');
        }
        if (tx.status == 'batal') {
          throw const _VoidAbort('Transaksi sudah dibatalkan');
        }

        // Kembalikan stok barang (jasa dilewati).
        final items = await (_db.select(_db.transactionItems)
              ..where((t) => t.transactionId.equals(params.id)))
            .get();
        for (final item in items) {
          final product = await (_db.select(_db.products)
                ..where((t) => t.id.equals(item.productId)))
              .getSingleOrNull();
          if (product != null && product.trackStock == 1) {
            await (_db.update(_db.products)
                  ..where((t) => t.id.equals(item.productId)))
                .write(ProductsCompanion(
              stok: Value(product.stok + item.qty),
              updatedAt: Value(
                  DateTime.now().millisecondsSinceEpoch),
            ));
          }
        }

        await (_db.update(_db.transactions)
              ..where((t) => t.id.equals(params.id)))
            .write(TransactionsCompanion(
          status: const Value('batal'),
          voidReason: Value(params.reason.trim()),
          voidBy: Value(params.voidBy),
          voidAt: Value(DateTime.now().millisecondsSinceEpoch),
        ));
      });
      return const Success(null);
    } on _VoidAbort catch (e) {
      return FailureResult(ValidationFailure(e.message));
    } catch (e) {
      return FailureResult(DatabaseFailure('Gagal void: $e'));
    }
  }
}

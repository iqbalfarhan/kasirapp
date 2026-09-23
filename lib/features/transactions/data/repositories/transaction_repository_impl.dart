import 'package:kasirapp/core/error/failures.dart';
import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/features/transactions/domain/entities/transaction.dart';
import 'package:kasirapp/features/transactions/domain/repositories/transaction_repository.dart';

/// TODO Fase 3: ganti dengan Drift DAO + kembalikan stok barang saat void
/// (produk jasa track_stock=0 tidak dikembalikan).
class TransactionRepositoryImpl implements TransactionRepository {
  const TransactionRepositoryImpl();

  @override
  Future<Result<List<Transaction>>> getTransactions(
          {required DateTime start, required DateTime end}) async =>
      const FailureResult(
          DatabaseFailure('Belum diimplementasi (Fase 3: Drift)'));

  @override
  Future<Result<Transaction>> getDetail(String id) async =>
      const FailureResult(
          DatabaseFailure('Belum diimplementasi (Fase 3: Drift)'));

  @override
  Future<Result<void>> voidTransaction(
      VoidTransactionParams params) async {
    if (params.reason.trim().isEmpty) {
      return const FailureResult(
          ValidationFailure('Alasan void wajib diisi'));
    }
    return const FailureResult(
        DatabaseFailure('Belum diimplementasi (Fase 3: Drift)'));
  }
}

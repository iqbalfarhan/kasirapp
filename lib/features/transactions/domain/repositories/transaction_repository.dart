import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/features/transactions/domain/entities/transaction.dart';

class VoidTransactionParams {
  const VoidTransactionParams({
    required this.id,
    required this.reason,
    required this.voidBy,
  });

  final String id;
  final String reason;
  final String voidBy;
}

abstract class TransactionRepository {
  Future<Result<List<Transaction>>> getTransactions(
      {required DateTime start, required DateTime end});
  Future<Result<Transaction>> getDetail(String id);

  /// Soft-void: set status batal + audit. Kembalikan stok barang (jasa tidak).
  /// TODO Fase 3: implementasi Drift dalam 1 transaksi DB.
  Future<Result<void>> voidTransaction(VoidTransactionParams params);
}

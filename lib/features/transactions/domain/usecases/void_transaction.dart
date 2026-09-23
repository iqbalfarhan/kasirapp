import 'package:kasirapp/core/error/failures.dart';
import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/core/usecase/usecase.dart';
import 'package:kasirapp/features/transactions/domain/repositories/transaction_repository.dart';

/// Void hanya boleh dipanggil dari UI admin (guard di router + tombol).
/// Alasan wajib (hasil review) + jejak voidBy untuk audit.
class VoidTransaction
    implements UseCase<void, VoidTransactionParams> {
  const VoidTransaction(this._repository, {this.isAdmin = false});
  final TransactionRepository _repository;
  final bool isAdmin;

  @override
  Future<Result<void>> call(VoidTransactionParams params) {
    if (!isAdmin) {
      return Future.value(
          const FailureResult<void>(AuthFailure('Hanya admin')));
    }
    if (params.reason.trim().isEmpty) {
      return Future.value(const FailureResult<void>(
          ValidationFailure('Alasan void wajib diisi')));
    }
    if (params.voidBy.trim().isEmpty) {
      return Future.value(const FailureResult<void>(
          ValidationFailure('voidBy wajib diisi')));
    }
    return _repository.voidTransaction(params);
  }
}

import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/core/usecase/usecase.dart';
import 'package:kasirapp/features/transactions/domain/entities/transaction.dart';
import 'package:kasirapp/features/transactions/domain/repositories/transaction_repository.dart';

class GetTransactionsParams {
  const GetTransactionsParams({required this.start, required this.end});
  final DateTime start;
  final DateTime end;
}

class GetTransactions
    implements UseCase<List<Transaction>, GetTransactionsParams> {
  const GetTransactions(this._repository);
  final TransactionRepository _repository;

  @override
  Future<Result<List<Transaction>>> call(GetTransactionsParams params) =>
      _repository.getTransactions(start: params.start, end: params.end);
}

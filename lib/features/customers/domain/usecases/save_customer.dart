import 'package:kasirapp/core/error/failures.dart';
import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/core/usecase/usecase.dart';
import 'package:kasirapp/features/customers/domain/entities/customer.dart';
import 'package:kasirapp/features/customers/domain/repositories/customer_repository.dart';

class SaveCustomer implements UseCase<String, Customer> {
  const SaveCustomer(this._repository);
  final CustomerRepository _repository;

  @override
  Future<Result<String>> call(Customer params) {
    if (params.name.trim().isEmpty) {
      return Future.value(
          const FailureResult<String>(ValidationFailure('Nama wajib diisi')));
    }
    return _repository.saveCustomer(params);
  }
}

import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/core/usecase/usecase.dart';
import 'package:kasirapp/features/customers/domain/entities/customer.dart';
import 'package:kasirapp/features/customers/domain/repositories/customer_repository.dart';

class GetCustomers implements UseCase<List<Customer>, String?> {
  const GetCustomers(this._repository);
  final CustomerRepository _repository;

  @override
  Future<Result<List<Customer>>> call(String? params) =>
      _repository.getCustomers(query: params);
}

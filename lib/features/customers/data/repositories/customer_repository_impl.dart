import 'package:kasirapp/core/error/failures.dart';
import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/features/customers/domain/entities/customer.dart';
import 'package:kasirapp/features/customers/domain/repositories/customer_repository.dart';

/// TODO Fase 1: ganti dengan Drift DAO.
class CustomerRepositoryImpl implements CustomerRepository {
  const CustomerRepositoryImpl();

  @override
  Future<Result<List<Customer>>> getCustomers({String? query}) async =>
      const FailureResult(
          DatabaseFailure('Belum diimplementasi (Fase 1: Drift)'));

  @override
  Future<Result<String>> saveCustomer(Customer customer) async =>
      const FailureResult(
          DatabaseFailure('Belum diimplementasi (Fase 1: Drift)'));
}

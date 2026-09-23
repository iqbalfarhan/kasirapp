import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/features/customers/domain/entities/customer.dart';

abstract class CustomerRepository {
  Future<Result<List<Customer>>> getCustomers({String? query});
  Future<Result<String>> saveCustomer(Customer customer);
}

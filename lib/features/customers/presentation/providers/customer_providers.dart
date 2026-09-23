import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/data/providers.dart';
import 'package:kasirapp/features/customers/data/repositories/customer_repository_impl.dart';
import 'package:kasirapp/features/customers/domain/entities/customer.dart';
import 'package:kasirapp/features/customers/domain/repositories/customer_repository.dart';
import 'package:kasirapp/features/customers/domain/usecases/get_customers.dart';

final customerRepositoryProvider = Provider<CustomerRepository>(
  (ref) => CustomerRepositoryImpl(ref.watch(databaseProvider)),
);

final customerQueryProvider = StateProvider<String>((ref) => '');

final customerListProvider = FutureProvider<List<Customer>>((ref) async {
  final repo = ref.watch(customerRepositoryProvider);
  final result =
      await GetCustomers(repo)(ref.watch(customerQueryProvider));
  return switch (result) {
    Success() => result.data,
    FailureResult() => throw result.failure.message,
  };
});

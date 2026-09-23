import 'package:drift/drift.dart';
import 'package:kasirapp/core/error/failures.dart';
import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/data/db.dart';
import 'package:kasirapp/features/customers/domain/entities/customer.dart';
import 'package:kasirapp/features/customers/domain/repositories/customer_repository.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  const CustomerRepositoryImpl(this._db);
  final AppDatabase _db;

  Customer _map(DbCustomer row) => Customer(
        id: row.id,
        name: row.nama,
        phone: row.hp,
        address: row.alamat,
      );

  @override
  Future<Result<List<Customer>>> getCustomers({String? query}) async {
    try {
      final q = _db.select(_db.customers)
        ..orderBy([(t) => OrderingTerm(expression: t.nama)]);
      final like = query?.trim();
      if (like != null && like.isNotEmpty) {
        q.where((t) => t.nama.like('%$like%') | t.hp.like('%$like%'));
      }
      final rows = await q.get();
      return Success(rows.map(_map).toList());
    } catch (e) {
      return FailureResult(DatabaseFailure('Gagal memuat pelanggan: $e'));
    }
  }

  @override
  Future<Result<String>> saveCustomer(Customer customer) async {
    try {
      await _db.into(_db.customers).insertOnConflictUpdate(
            CustomersCompanion.insert(
              id: customer.id,
              nama: customer.name.trim(),
              hp: Value(customer.phone?.trim().isEmpty == true
                  ? null
                  : customer.phone?.trim()),
              alamat: Value(customer.address?.trim().isEmpty == true
                  ? null
                  : customer.address?.trim()),
              createdAt: DateTime.now().millisecondsSinceEpoch,
            ),
          );
      return Success(customer.id);
    } catch (e) {
      return FailureResult(DatabaseFailure('Gagal menyimpan pelanggan: $e'));
    }
  }
}

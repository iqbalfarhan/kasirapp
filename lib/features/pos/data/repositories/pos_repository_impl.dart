import 'package:kasirapp/core/error/failures.dart';
import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/features/pos/data/datasources/pos_local_datasource.dart';
import 'package:kasirapp/features/pos/domain/entities/cart.dart';
import 'package:kasirapp/features/pos/domain/entities/checkout_result.dart';
import 'package:kasirapp/features/pos/domain/repositories/pos_repository.dart';
import 'package:kasirapp/features/pos/domain/usecases/calculate_total.dart';

/// Contoh implementasi repository — pola yang dicopy semua fitur.
/// Fase 0: calculate jalan penuh (pure). Checkout: validasi + TODO Drift.
class PosRepositoryImpl implements PosRepository {
  PosRepositoryImpl(this._local, {CalculateTotal? calculator})
      : _calculator = calculator ?? const CalculateTotal();

  final PosLocalDataSource? _local;
  final CalculateTotal _calculator;

  @override
  Future<Result<CheckoutResult>> calculate(Cart cart, int payment) =>
      _calculator(CalculateTotalParams(cart: cart, payment: payment));

  @override
  Future<Result<String>> checkout({
    required Cart cart,
    required int payment,
    required String cashierId,
    required String paymentMethod,
  }) async {
    final calc = await calculate(cart, payment);
    if (calc is FailureResult<CheckoutResult>) {
      return FailureResult<String>(calc.failure);
    }
    if (_local == null) {
      return const FailureResult<String>(
        DatabaseFailure('DataSource belum diinisialisasi (Fase 2: Drift)'),
      );
    }
    try {
      final id = await _local.insertTransaction(
        header: {
          'cashier_id': cashierId,
          'payment_method': paymentMethod,
          'payment': payment,
        },
        items: const [],
      );
      return Success(id);
    } catch (e) {
      return FailureResult(DatabaseFailure('Gagal checkout: $e'));
    }
  }
}

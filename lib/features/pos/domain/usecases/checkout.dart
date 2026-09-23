import 'package:kasirapp/core/error/failures.dart';
import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/core/usecase/usecase.dart';
import 'package:kasirapp/features/pos/domain/entities/cart.dart';
import 'package:kasirapp/features/pos/domain/repositories/pos_repository.dart';

class CheckoutParams {
  const CheckoutParams({
    required this.cart,
    required this.payment,
    required this.cashierId,
    required this.paymentMethod,
  });
  final Cart cart;
  final int payment;
  final String cashierId;
  final String paymentMethod;
}

/// Usecase checkout — validasi ringan di domain, commit di repository.
class Checkout implements UseCase<String, CheckoutParams> {
  const Checkout(this._repository);
  final PosRepository _repository;

  @override
  Future<Result<String>> call(CheckoutParams params) async {
    if (params.cart.isEmpty) {
      return const FailureResult(ValidationFailure('Keranjang kosong'));
    }
    if (params.cashierId.isEmpty) {
      return const FailureResult(ValidationFailure('Kasir wajib diisi'));
    }
    return _repository.checkout(
      cart: params.cart,
      payment: params.payment,
      cashierId: params.cashierId,
      paymentMethod: params.paymentMethod,
    );
  }
}

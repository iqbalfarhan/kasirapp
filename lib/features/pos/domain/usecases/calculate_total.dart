import 'package:kasirapp/core/error/failures.dart';
import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/core/usecase/usecase.dart';
import 'package:kasirapp/features/pos/domain/entities/cart.dart';
import 'package:kasirapp/features/pos/domain/entities/checkout_result.dart';
import 'package:kasirapp/features/pos/domain/entities/discount.dart';

class CalculateTotalParams {
  const CalculateTotalParams({
    required this.cart,
    required this.payment,
    this.paymentMethod = 'tunai',
    this.maxDiscountPercent = 20,
  });

  final Cart cart;
  final int payment;

  /// 'tunai' | 'qris' | 'transfer'. Non-tunai wajib uang pas.
  final String paymentMethod;

  /// 0 = tanpa batas. Selain itu % diskon item & struk tidak boleh lebih.
  final int maxDiscountPercent;
}

/// Usecase Full Clean — implementasi aturan hitung PLAN §1 + hasil review:
/// diskon item -> diskon struk -> pajak (snapshot) -> total -> validasi bayar.
/// Murni Dart, 100% unit-testable, tanpa Flutter/Drift.
class CalculateTotal implements UseCase<CheckoutResult, CalculateTotalParams> {
  const CalculateTotal();

  @override
  Future<Result<CheckoutResult>> call(CalculateTotalParams params) async {
    final cart = params.cart;
    final payment = params.payment;
    final method = params.paymentMethod.toLowerCase();
    final maxPct = params.maxDiscountPercent;

    if (cart.isEmpty) {
      return const FailureResult(ValidationFailure('Keranjang kosong'));
    }
    if (cart.taxPercent < 0 || cart.taxPercent > 100) {
      return const FailureResult(
          ValidationFailure('Pajak harus 0-100%'));
    }
    if (maxPct < 0 || maxPct > 100) {
      return const FailureResult(
          ValidationFailure('Batas diskon harus 0-100%'));
    }

    // Batas diskon persen (amount bebas selama <= basis).
    for (final item in cart.items) {
      if (!item.discount.isNone &&
          item.discount.type == DiscountType.percent &&
          maxPct > 0 &&
          item.discount.value > maxPct) {
        return FailureResult(
            ValidationFailure('Diskon ${item.name} melebihi batas $maxPct%'));
      }
    }
    if (!cart.receiptDiscount.isNone &&
        cart.receiptDiscount.type == DiscountType.percent &&
        maxPct > 0 &&
        cart.receiptDiscount.value > maxPct) {
      return FailureResult(
          ValidationFailure('Diskon struk melebihi batas $maxPct%'));
    }

    final subtotalGross =
        cart.items.fold<int>(0, (sum, e) => sum + e.lineGross);
    final itemDiscountTotal =
        cart.items.fold<int>(0, (sum, e) => sum + e.lineDiscount);
    final subtotalAfterItemDiscount = subtotalGross - itemDiscountTotal;

    final receiptDiscount = _receiptDiscount(
      cart.receiptDiscount,
      subtotalAfterItemDiscount,
    );
    final subtotalAfterDiscount =
        (subtotalAfterItemDiscount - receiptDiscount).clamp(0, 1 << 62);
    final tax =
        (subtotalAfterDiscount * cart.taxPercent / 100).round();
    final total = subtotalAfterDiscount + tax;

    if (method != 'tunai' && payment != total) {
      return const FailureResult(
          ValidationFailure('Non-tunai wajib uang pas'));
    }
    if (payment < total) {
      return const FailureResult(ValidationFailure('Nominal bayar kurang'));
    }

    return Success(CheckoutResult(
      subtotalGross: subtotalGross,
      itemDiscountTotal: itemDiscountTotal,
      subtotalAfterItemDiscount: subtotalAfterItemDiscount,
      receiptDiscount: receiptDiscount,
      subtotalAfterDiscount: subtotalAfterDiscount,
      tax: tax,
      total: total,
      payment: payment,
      change: payment - total,
    ));
  }

  int _receiptDiscount(Discount discount, int base) {
    if (discount.isNone || base <= 0) return 0;
    switch (discount.type) {
      case DiscountType.none:
        return 0;
      case DiscountType.percent:
        final pct = discount.value.clamp(0, 100);
        return (base * pct / 100).round().clamp(0, base);
      case DiscountType.amount:
        return discount.value.clamp(0, base);
    }
  }
}

import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/features/pos/domain/entities/cart.dart';
import 'package:kasirapp/features/pos/domain/entities/checkout_result.dart';

/// Interface repository POS. Implementasi ada di data/ (Drift) — Fase 2.
/// Pola ini dicopy ke semua fitur (products, customers, ...).
abstract class PosRepository {
  /// Hitung total dari cart + payment (pure, delegasi ke CalculateTotal).
  Future<Result<CheckoutResult>> calculate(Cart cart, int payment);

  /// Commit atomik: validasi stok + insert transaksi + kurangi stok.
  /// TODO Fase 2: implementasi Drift transaction().
  Future<Result<String>> checkout({
    required Cart cart,
    required int payment,
    required String cashierId,
    required String paymentMethod,
  });
}

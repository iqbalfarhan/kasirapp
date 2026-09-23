import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/features/pos/domain/entities/cart.dart';
import 'package:kasirapp/features/pos/domain/entities/checkout_result.dart';
import 'package:kasirapp/features/pos/domain/usecases/calculate_total.dart';

/// Interface repository POS. Implementasi ada di data/ (Drift) — Fase 2.
/// Pola ini dicopy ke semua fitur (products, customers, ...).
abstract class PosRepository {
  /// Hitung total dari cart + payment (pure, delegasi ke CalculateTotal).
  Future<Result<CheckoutResult>> calculate(CalculateTotalParams params);

  /// Commit atomik: validasi stok + insert transaksi + kurangi stok
  /// dalam 1 `transaction()` Drift. Produk jasa tidak dicek/dikurangi.
  Future<Result<String>> checkout({
    required Cart cart,
    required int payment,
    required String cashierId,
    required String paymentMethod,
    int maxDiscountPercent = 20,
    String? customerId,
  });
}

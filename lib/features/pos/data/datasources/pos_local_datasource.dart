/// Akses data lokal POS. Implementasi Drift menyusul di Fase 2.
/// Interface ini menjaga domain tetap murni (Dependency Inversion).
abstract class PosLocalDataSource {
  /// Insert transaksi + items + kurangi stok dalam 1 transaksi DB.
  /// Mengembalikan id transaksi.
  Future<String> insertTransaction({
    required Map<String, Object?> header,
    required List<Map<String, Object?>> items,
  });

  /// Cek stok cukup untuk semua item. Throw jika tidak cukup.
  Future<void> assertStockAvailable(
      List<Map<String, Object?>> items);
}

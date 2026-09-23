import 'package:kasirapp/core/error/failures.dart';
import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/data/db.dart';
import 'package:kasirapp/features/settings/domain/entities/store_settings.dart';
import 'package:kasirapp/features/settings/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._db);
  final AppDatabase _db;

  Future<String?> _get(String key) async {
    final row = await (_db.select(_db.settings)
          ..where((t) => t.key.equals(key)))
        .getSingleOrNull();
    return row?.value;
  }

  Future<void> _set(String key, String value) =>
      _db.into(_db.settings).insertOnConflictUpdate(
          SettingsCompanion.insert(key: key, value: value));

  int _parseInt(String? raw, int fallback) =>
      int.tryParse(raw ?? '') ?? fallback;

  @override
  Future<Result<StoreSettings>> getSettings() async {
    try {
      final name = await _get('store_name');
      final tax = await _get('tax_percent');
      final maxDisc = await _get('max_discount_percent');
      final address = await _get('store_address');
      final phone = await _get('store_phone');
      return Success(StoreSettings(
        storeName: (name == null || name.isEmpty) ? 'Kasirapp' : name,
        taxPercent: _parseInt(tax, 10),
        maxDiscountPercent: _parseInt(maxDisc, 20),
        address: address?.isEmpty == true ? null : address,
        phone: phone?.isEmpty == true ? null : phone,
      ));
    } catch (e) {
      return FailureResult(DatabaseFailure('Gagal memuat pengaturan: $e'));
    }
  }

  @override
  Future<Result<void>> saveTax(int percent) async {
    if (percent < 0 || percent > 100) {
      return const FailureResult(
          ValidationFailure('Pajak harus 0-100%'));
    }
    try {
      await _set('tax_percent', percent.toString());
      return const Success(null);
    } catch (e) {
      return FailureResult(DatabaseFailure('Gagal menyimpan pajak: $e'));
    }
  }

  @override
  Future<Result<void>> saveMaxDiscount(int percent) async {
    if (percent < 0 || percent > 100) {
      return const FailureResult(
          ValidationFailure('Batas diskon harus 0-100%'));
    }
    try {
      await _set('max_discount_percent', percent.toString());
      return const Success(null);
    } catch (e) {
      return FailureResult(
          DatabaseFailure('Gagal menyimpan batas diskon: $e'));
    }
  }

  @override
  Future<Result<void>> saveStore(StoreSettings settings) async {
    if (settings.storeName.trim().isEmpty) {
      return const FailureResult(
          ValidationFailure('Nama toko wajib diisi'));
    }
    if (settings.taxPercent < 0 || settings.taxPercent > 100) {
      return const FailureResult(
          ValidationFailure('Pajak harus 0-100%'));
    }
    try {
      await _set('store_name', settings.storeName.trim());
      await _set('tax_percent', settings.taxPercent.toString());
      await _set('max_discount_percent',
          settings.maxDiscountPercent.toString());
      await _set('store_address', settings.address?.trim() ?? '');
      await _set('store_phone', settings.phone?.trim() ?? '');
      return const Success(null);
    } catch (e) {
      return FailureResult(
          DatabaseFailure('Gagal menyimpan info toko: $e'));
    }
  }
}

import 'package:kasirapp/core/error/failures.dart';
import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/features/settings/domain/entities/app_user.dart';
import 'package:kasirapp/features/settings/domain/entities/store_settings.dart';
import 'package:kasirapp/features/settings/domain/repositories/settings_repository.dart';

/// TODO Fase 0/1: ganti dengan Drift (tabel settings + users).
class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl();

  @override
  Future<Result<StoreSettings>> getSettings() async => const Success(
        StoreSettings(
            storeName: 'Kasirapp', taxPercent: 10, maxDiscountPercent: 20),
      );

  @override
  Future<Result<void>> saveTax(int percent) async {
    if (percent < 0 || percent > 100) {
      return const FailureResult(
          ValidationFailure('Pajak harus 0-100%'));
    }
    return const FailureResult(
        DatabaseFailure('Belum diimplementasi (Fase 5: Drift)'));
  }

  @override
  Future<Result<void>> saveStore(StoreSettings settings) async =>
      const FailureResult(
          DatabaseFailure('Belum diimplementasi (Fase 5: Drift)'));
}

class UserRepositoryImpl implements UserRepository {
  const UserRepositoryImpl();

  @override
  Future<Result<AppUser>> loginWithPin(String pin) async =>
      const FailureResult(
          DatabaseFailure('Belum diimplementasi (Fase 1: Drift)'));

  @override
  Future<Result<List<AppUser>>> getUsers() async => const FailureResult(
      DatabaseFailure('Belum diimplementasi (Fase 1: Drift)'));
}

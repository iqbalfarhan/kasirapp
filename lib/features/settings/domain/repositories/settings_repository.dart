import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/features/settings/domain/entities/app_user.dart';
import 'package:kasirapp/features/settings/domain/entities/store_settings.dart';

abstract class SettingsRepository {
  Future<Result<StoreSettings>> getSettings();
  Future<Result<void>> saveTax(int percent);
  Future<Result<void>> saveMaxDiscount(int percent);
  Future<Result<void>> saveStore(StoreSettings settings);
}

abstract class UserRepository {
  Future<Result<AppUser>> loginWithPin(String pin);
  Future<Result<List<AppUser>>> getUsers();

  /// PIN plaintext (4–6 digit, tervalidasi di usecase); impl melakukan hashing.
  Future<Result<String>> saveUser({
    required String name,
    required UserRole role,
    required String pin,
  });
  Future<Result<void>> changePin({
    required String userId,
    required String newPin,
  });
  Future<Result<void>> toggleUserActive(String id, bool isActive);
}

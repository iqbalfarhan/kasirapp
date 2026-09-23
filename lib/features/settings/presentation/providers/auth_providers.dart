import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/data/providers.dart';
import 'package:kasirapp/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:kasirapp/features/settings/data/repositories/user_repository_impl.dart';
import 'package:kasirapp/features/settings/domain/entities/app_user.dart';
import 'package:kasirapp/features/settings/domain/entities/store_settings.dart';
import 'package:kasirapp/features/settings/domain/repositories/settings_repository.dart';
import 'package:kasirapp/features/settings/domain/usecases/get_settings.dart';
import 'package:kasirapp/core/usecase/usecase.dart';
import 'package:kasirapp/features/settings/domain/usecases/login_with_pin.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepositoryImpl(ref.watch(databaseProvider)),
);

final userRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepositoryImpl(ref.watch(databaseProvider)),
);

final settingsProvider = FutureProvider<StoreSettings>((ref) async {
  final result =
      await GetSettings(ref.watch(settingsRepositoryProvider))(const NoParams());
  return switch (result) {
    Success() => result.data,
    FailureResult() => throw result.failure.message,
  };
});

final usersProvider = FutureProvider<List<AppUser>>((ref) async {
  final result =
      await ref.watch(userRepositoryProvider).getUsers();
  return switch (result) {
    Success() => result.data,
    FailureResult() => throw result.failure.message,
  };
});

/// Sesi login. null = belum login.
class AuthNotifier extends StateNotifier<AppUser?> {
  AuthNotifier(this._login) : super(null);

  final LoginWithPin _login;

  /// true jika sukses; pesan error terakhir via [lastError].
  String? lastError;

  Future<bool> login(String pin) async {
    final result = await _login(pin);
    switch (result) {
      case Success():
        lastError = null;
        state = result.data;
        return true;
      case FailureResult():
        lastError = result.failure.message;
        return false;
    }
  }

  void logout() => state = null;

  void markPinChanged() {
    final user = state;
    if (user != null) state = user.copyWith(mustChangePin: false);
  }
}

final authProvider =
    StateNotifierProvider<AuthNotifier, AppUser?>((ref) {
  return AuthNotifier(
      LoginWithPin(ref.watch(userRepositoryProvider)));
});

final isAdminProvider = Provider<bool>(
  (ref) => ref.watch(authProvider)?.isAdmin ?? false,
);

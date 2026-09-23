import 'package:kasirapp/core/error/failures.dart';
import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/core/usecase/usecase.dart';
import 'package:kasirapp/features/settings/domain/entities/app_user.dart';
import 'package:kasirapp/features/settings/domain/repositories/settings_repository.dart';

class LoginWithPin implements UseCase<AppUser, String> {
  const LoginWithPin(this._repository);
  final UserRepository _repository;

  static final _pinPattern = RegExp(r'^[0-9]{4,6}$');

  @override
  Future<Result<AppUser>> call(String params) {
    if (!_pinPattern.hasMatch(params.trim())) {
      return Future.value(const FailureResult<AppUser>(
          ValidationFailure('PIN harus 4-6 digit angka')));
    }
    // Lockout 5x salah → 5 menit dicek di repository/data (Fase 1, butuh
    // failed_attempts/locked_until dari DB); domain hanya validasi format.
    return _repository.loginWithPin(params.trim());
  }
}

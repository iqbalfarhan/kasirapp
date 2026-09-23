import 'package:kasirapp/core/error/failures.dart';
import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/core/usecase/usecase.dart';
import 'package:kasirapp/features/settings/domain/entities/app_user.dart';
import 'package:kasirapp/features/settings/domain/repositories/settings_repository.dart';

class CreateUserParams {
  const CreateUserParams({
    required this.name,
    required this.role,
    required this.pin,
  });

  final String name;
  final UserRole role;
  final String pin;
}

/// Tambah pengguna (admin). PIN 4–6 digit; hashing di repository.
class CreateUser implements UseCase<String, CreateUserParams> {
  const CreateUser(this._repository);
  final UserRepository _repository;

  static final _pinPattern = RegExp(r'^[0-9]{4,6}$');

  @override
  Future<Result<String>> call(CreateUserParams params) {
    if (params.name.trim().isEmpty) {
      return Future.value(
          const FailureResult<String>(ValidationFailure('Nama wajib diisi')));
    }
    if (!_pinPattern.hasMatch(params.pin)) {
      return Future.value(const FailureResult<String>(
          ValidationFailure('PIN harus 4-6 digit angka')));
    }
    return _repository.saveUser(
      name: params.name.trim(),
      role: params.role,
      pin: params.pin,
    );
  }
}

import 'package:kasirapp/core/error/failures.dart';
import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/core/usecase/usecase.dart';
import 'package:kasirapp/features/settings/domain/repositories/settings_repository.dart';

class ChangePinParams {
  const ChangePinParams({required this.userId, required this.newPin});

  final String userId;
  final String newPin;
}

/// Ganti PIN (dipakai wajib saat `mustChangePin`, dan form ganti PIN).
class ChangePin implements UseCase<void, ChangePinParams> {
  const ChangePin(this._repository);
  final UserRepository _repository;

  static final _pinPattern = RegExp(r'^[0-9]{4,6}$');

  @override
  Future<Result<void>> call(ChangePinParams params) {
    if (params.userId.isEmpty) {
      return Future.value(const FailureResult<void>(
          ValidationFailure('User tidak valid')));
    }
    if (!_pinPattern.hasMatch(params.newPin)) {
      return Future.value(const FailureResult<void>(
          ValidationFailure('PIN harus 4-6 digit angka')));
    }
    return _repository.changePin(
      userId: params.userId,
      newPin: params.newPin,
    );
  }
}

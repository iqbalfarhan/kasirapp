import 'package:kasirapp/core/error/failures.dart';
import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/core/usecase/usecase.dart';
import 'package:kasirapp/features/settings/domain/entities/app_user.dart';
import 'package:kasirapp/features/settings/domain/repositories/settings_repository.dart';

class LoginWithPin implements UseCase<AppUser, String> {
  const LoginWithPin(this._repository);
  final UserRepository _repository;

  @override
  Future<Result<AppUser>> call(String params) {
    if (params.trim().isEmpty) {
      return Future.value(
          const FailureResult<AppUser>(ValidationFailure('PIN wajib diisi')));
    }
    return _repository.loginWithPin(params);
  }
}

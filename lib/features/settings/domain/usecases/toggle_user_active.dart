import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/core/usecase/usecase.dart';
import 'package:kasirapp/features/settings/domain/repositories/settings_repository.dart';

class ToggleUserActiveParams {
  const ToggleUserActiveParams({required this.id, required this.isActive});

  final String id;
  final bool isActive;
}

class ToggleUserActive
    implements UseCase<void, ToggleUserActiveParams> {
  const ToggleUserActive(this._repository);
  final UserRepository _repository;

  @override
  Future<Result<void>> call(ToggleUserActiveParams params) =>
      _repository.toggleUserActive(params.id, params.isActive);
}

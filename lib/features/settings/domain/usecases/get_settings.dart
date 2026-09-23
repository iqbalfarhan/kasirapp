import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/core/usecase/usecase.dart';
import 'package:kasirapp/features/settings/domain/entities/store_settings.dart';
import 'package:kasirapp/features/settings/domain/repositories/settings_repository.dart';

class GetSettings implements UseCase<StoreSettings, NoParams> {
  const GetSettings(this._repository);
  final SettingsRepository _repository;

  @override
  Future<Result<StoreSettings>> call(NoParams params) =>
      _repository.getSettings();
}

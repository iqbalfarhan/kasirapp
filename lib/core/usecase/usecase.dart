import 'package:kasirapp/core/result/result.dart';

/// Kontrak usecase seragam untuk semua fitur.
abstract class UseCase<T, Params> {
  Future<Result<T>> call(Params params);
}

/// Untuk usecase tanpa parameter.
class NoParams {
  const NoParams();
}

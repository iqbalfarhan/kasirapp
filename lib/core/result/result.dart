import 'package:kasirapp/core/error/failures.dart';

/// Wrapper hasil usecase/repository agar error eksplisit dan testable.
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;
}

class FailureResult<T> extends Result<T> {
  const FailureResult(this.failure);
  final Failure failure;
}

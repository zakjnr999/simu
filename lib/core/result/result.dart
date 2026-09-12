import 'package:simu/core/errors/app_failure.dart';

/// Lightweight Result type representing either a [Success] value or a [Failure] error.
///
/// Avoids overengineered monads while preserving type safety and explicit error handling.
sealed class Result<T, E extends AppFailure> {
  const Result();

  /// Creates a successful result with [data].
  const factory Result.success(T data) = Success<T, E>;

  /// Creates a failed result with [failure].
  const factory Result.failure(E failure) = Failure<T, E>;

  bool get isSuccess => this is Success<T, E>;
  bool get isFailure => this is Failure<T, E>;

  T? get dataOrNull => switch (this) {
        Success(:final data) => data,
        Failure() => null,
      };

  E? get failureOrNull => switch (this) {
        Success() => null,
        Failure(:final failure) => failure,
      };

  /// Pattern match over the result.
  R when<R>({
    required R Function(T data) onSuccess,
    required R Function(E failure) onFailure,
  }) {
    return switch (this) {
      Success(:final data) => onSuccess(data),
      Failure(:final failure) => onFailure(failure),
    };
  }

  /// Transforms the success value if present.
  Result<R, E> map<R>(R Function(T data) transform) {
    return switch (this) {
      Success(:final data) => Result.success(transform(data)),
      Failure(:final failure) => Result.failure(failure),
    };
  }
}

/// Represents a successful computation.
final class Success<T, E extends AppFailure> extends Result<T, E> {
  const Success(this.data);
  final T data;

  @override
  String toString() => 'Result.success($data)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Success<T, E> && other.data == data);

  @override
  int get hashCode => data.hashCode;
}

/// Represents a failed computation.
final class Failure<T, E extends AppFailure> extends Result<T, E> {
  const Failure(this.failure);
  final E failure;

  @override
  String toString() => 'Result.failure($failure)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Failure<T, E> && other.failure == failure);

  @override
  int get hashCode => failure.hashCode;
}

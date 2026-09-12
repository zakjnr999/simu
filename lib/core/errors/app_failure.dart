/// Base failure class for the Simu application.
///
/// Application failures represent expected failure states that are handled
/// and presented to the user or domain logic, avoiding uncaught raw exceptions.
abstract class AppFailure {
  const AppFailure({
    required this.message,
    this.code,
    this.cause,
  });

  final String message;
  final String? code;
  final Object? cause;

  @override
  String toString() => '$runtimeType(message: $message, code: $code)';
}

/// Network-related failures (connectivity, timeout, DNS, etc.)
class NetworkFailure extends AppFailure {
  const NetworkFailure({
    required super.message,
    super.code,
    super.cause,
    this.statusCode,
  });

  final int? statusCode;
}

/// Storage-related failures (preferences, secure storage, file system)
class StorageFailure extends AppFailure {
  const StorageFailure({
    required super.message,
    super.code,
    super.cause,
  });
}

/// Validation failures (invalid form, out of range values)
class ValidationFailure extends AppFailure {
  const ValidationFailure({
    required super.message,
    super.code,
    super.cause,
    this.fieldErrors = const {},
  });

  final Map<String, String> fieldErrors;
}

/// Unauthorized / authentication failures
class UnauthorizedFailure extends AppFailure {
  const UnauthorizedFailure({
    super.message = 'Unauthorized access. Please log in again.',
    super.code,
    super.cause,
  });
}

/// Server / internal system failures
class ServerFailure extends AppFailure {
  const ServerFailure({
    required super.message,
    super.code,
    super.cause,
  });
}

/// Generic unexpected failure
class UnknownFailure extends AppFailure {
  const UnknownFailure({
    required super.message,
    super.code,
    super.cause,
  });
}

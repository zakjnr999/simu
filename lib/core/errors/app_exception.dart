/// Base exception class for Simu low-level exceptions.
abstract class AppException implements Exception {
  const AppException({
    required this.message,
    this.code,
    this.cause,
  });

  final String message;
  final String? code;
  final Object? cause;

  @override
  String toString() => '$runtimeType: $message (code: $code)';
}

/// Generic storage exception thrown by data sources.
class StorageException extends AppException {
  const StorageException({
    required super.message,
    super.code,
    super.cause,
  });
}

/// Generic network exception thrown by data sources.
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code,
    super.cause,
    this.statusCode,
  });

  final int? statusCode;
}

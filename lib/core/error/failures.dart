import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
abstract class Failure extends Equatable {
  final String message;
  final String? code;
  final Map<String, dynamic>? details;

  const Failure({
    required this.message,
    this.code,
    this.details,
  });

  @override
  List<Object?> get props => [message, code, details];

  @override
  String toString() => 'Failure: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Network-related failures
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'Network error occurred',
    super.code = 'NETWORK_ERROR',
    super.details,
  });
}

class ServerFailure extends Failure {
  const ServerFailure({
    super.message = 'Server error occurred',
    super.code = 'SERVER_ERROR',
    super.details,
  });
}

class ConnectionTimeoutFailure extends Failure {
  const ConnectionTimeoutFailure({
    super.message = 'Connection timeout',
    super.code = 'CONNECTION_TIMEOUT',
    super.details,
  });
}

class NoInternetConnectionFailure extends Failure {
  const NoInternetConnectionFailure({
    super.message = 'No internet connection',
    super.code = 'NO_INTERNET',
    super.details,
  });
}

/// Data-related failures
class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Cache error occurred',
    super.code = 'CACHE_ERROR',
    super.details,
  });
}

class DatabaseFailure extends Failure {
  const DatabaseFailure({
    required super.message,
    super.code = 'DATABASE_ERROR',
    super.details,
  });
}

class DataNotFoundFailure extends Failure {
  const DataNotFoundFailure({
    super.message = 'Data not found',
    super.code = 'DATA_NOT_FOUND',
    super.details,
  });
}

class InvalidDataFailure extends Failure {
  const InvalidDataFailure({
    super.message = 'Invalid data provided',
    super.code = 'INVALID_DATA',
    super.details,
  });
}

/// Authentication and authorization failures
class AuthenticationFailure extends Failure {
  const AuthenticationFailure({
    super.message = 'Authentication failed',
    super.code = 'AUTH_ERROR',
    super.details,
  });
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = 'Unauthorized access',
    super.code = 'UNAUTHORIZED',
    super.details,
  });
}

/// Business logic failures
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code = 'VALIDATION_ERROR',
    super.details,
  });
}

class BusinessLogicFailure extends Failure {
  const BusinessLogicFailure({
    required super.message,
    super.code = 'BUSINESS_LOGIC_ERROR',
    super.details,
  });
}

/// Generic failures
class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'An unknown error occurred',
    super.code = 'UNKNOWN_ERROR',
    super.details,
  });
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    super.message = 'An unexpected error occurred',
    super.code = 'UNEXPECTED_ERROR',
    super.details,
  });
}

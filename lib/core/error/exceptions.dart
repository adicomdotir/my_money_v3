import 'package:equatable/equatable.dart';

/// Base class for all exceptions in the application
abstract class AppException extends Equatable implements Exception {
  final String message;
  final String? code;
  final Map<String, dynamic>? details;

  const AppException({
    required this.message,
    this.code,
    this.details,
  });

  @override
  List<Object?> get props => [message, code, details];

  @override
  String toString() =>
      'AppException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Network-related exceptions
class NetworkException extends AppException {
  const NetworkException({
    super.message = 'Network error occurred',
    super.code = 'NETWORK_ERROR',
    super.details,
  });
}

class ServerException extends AppException {
  const ServerException({
    super.message = 'Server error occurred',
    super.code = 'SERVER_ERROR',
    super.details,
  });
}

class ConnectionTimeoutException extends AppException {
  const ConnectionTimeoutException({
    super.message = 'Connection timeout',
    super.code = 'CONNECTION_TIMEOUT',
    super.details,
  });
}

class NoInternetConnectionException extends AppException {
  const NoInternetConnectionException({
    super.message = 'No internet connection',
    super.code = 'NO_INTERNET',
    super.details,
  });
}

/// HTTP-specific exceptions
class HttpException extends AppException {
  final int? statusCode;

  const HttpException({
    required super.message,
    super.code = 'HTTP_ERROR',
    this.statusCode,
    super.details,
  });

  @override
  List<Object?> get props => [...super.props, statusCode];
}

class BadRequestException extends HttpException {
  const BadRequestException({
    super.message = 'Bad Request',
    super.code = 'BAD_REQUEST',
    super.statusCode = 400,
    super.details,
  });
}

class UnauthorizedException extends HttpException {
  const UnauthorizedException({
    super.message = 'Unauthorized',
    super.code = 'UNAUTHORIZED',
    super.statusCode = 401,
    super.details,
  });
}

class ForbiddenException extends HttpException {
  const ForbiddenException({
    super.message = 'Forbidden',
    super.code = 'FORBIDDEN',
    super.statusCode = 403,
    super.details,
  });
}

class NotFoundException extends HttpException {
  const NotFoundException({
    super.message = 'Requested Info Not Found',
    super.code = 'NOT_FOUND',
    super.statusCode = 404,
    super.details,
  });
}

class ConflictException extends HttpException {
  const ConflictException({
    super.message = 'Conflict Occurred',
    super.code = 'CONFLICT',
    super.statusCode = 409,
    super.details,
  });
}

class InternalServerErrorException extends HttpException {
  const InternalServerErrorException({
    super.message = 'Internal Server Error',
    super.code = 'INTERNAL_SERVER_ERROR',
    super.statusCode = 500,
    super.details,
  });
}

/// Data-related exceptions
class CacheException extends AppException {
  const CacheException({
    super.message = 'Cache error occurred',
    super.code = 'CACHE_ERROR',
    super.details,
  });
}

class DatabaseException extends AppException {
  const DatabaseException({
    required super.message,
    super.code = 'DATABASE_ERROR',
    super.details,
  });
}

class DataNotFoundException extends AppException {
  const DataNotFoundException({
    super.message = 'Data not found',
    super.code = 'DATA_NOT_FOUND',
    super.details,
  });
}

class InvalidDataException extends AppException {
  const InvalidDataException({
    super.message = 'Invalid data provided',
    super.code = 'INVALID_DATA',
    super.details,
  });
}

/// Authentication and authorization exceptions
class AuthenticationException extends AppException {
  const AuthenticationException({
    super.message = 'Authentication failed',
    super.code = 'AUTH_ERROR',
    super.details,
  });
}

/// Business logic exceptions
class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.code = 'VALIDATION_ERROR',
    super.details,
  });
}

class BusinessLogicException extends AppException {
  const BusinessLogicException({
    required super.message,
    super.code = 'BUSINESS_LOGIC_ERROR',
    super.details,
  });
}

/// Generic exceptions
class UnknownException extends AppException {
  const UnknownException({
    super.message = 'An unknown error occurred',
    super.code = 'UNKNOWN_ERROR',
    super.details,
  });
}

class UnexpectedException extends AppException {
  const UnexpectedException({
    super.message = 'An unexpected error occurred',
    super.code = 'UNEXPECTED_ERROR',
    super.details,
  });
}

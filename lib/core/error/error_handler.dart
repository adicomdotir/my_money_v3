import 'exceptions.dart';
import 'failures.dart';

/// Utility class for handling errors and mapping exceptions to failures
class ErrorHandler {
  ErrorHandler._();

  /// Maps exceptions to their corresponding failures
  static Failure mapExceptionToFailure(AppException exception) {
    switch (exception.runtimeType) {
      case NetworkException _:
        return NetworkFailure(
          message: exception.message,
          code: exception.code,
          details: exception.details,
        );

      case ServerException _:
        return ServerFailure(
          message: exception.message,
          code: exception.code,
          details: exception.details,
        );

      case ConnectionTimeoutException _:
        return ConnectionTimeoutFailure(
          message: exception.message,
          code: exception.code,
          details: exception.details,
        );

      case NoInternetConnectionException _:
        return NoInternetConnectionFailure(
          message: exception.message,
          code: exception.code,
          details: exception.details,
        );

      case CacheException _:
        return CacheFailure(
          message: exception.message,
          code: exception.code,
          details: exception.details,
        );

      case DatabaseException _:
        return DatabaseFailure(
          message: exception.message,
          code: exception.code,
          details: exception.details,
        );

      case DataNotFoundException _:
        return DataNotFoundFailure(
          message: exception.message,
          code: exception.code,
          details: exception.details,
        );

      case InvalidDataException _:
        return InvalidDataFailure(
          message: exception.message,
          code: exception.code,
          details: exception.details,
        );

      case AuthenticationException _:
        return AuthenticationFailure(
          message: exception.message,
          code: exception.code,
          details: exception.details,
        );

      case UnauthorizedException _:
        return UnauthorizedFailure(
          message: exception.message,
          code: exception.code,
          details: exception.details,
        );

      case ValidationException _:
        return ValidationFailure(
          message: exception.message,
          code: exception.code,
          details: exception.details,
        );

      case BusinessLogicException _:
        return BusinessLogicFailure(
          message: exception.message,
          code: exception.code,
          details: exception.details,
        );

      case UnknownException _:
        return UnknownFailure(
          message: exception.message,
          code: exception.code,
          details: exception.details,
        );

      case UnexpectedException _:
        return UnexpectedFailure(
          message: exception.message,
          code: exception.code,
          details: exception.details,
        );

      default:
        return UnknownFailure(
          message: exception.message,
          code: exception.code,
          details: exception.details,
        );
    }
  }

  /// Maps HTTP status codes to appropriate exceptions
  static AppException mapHttpStatusToException(
    int statusCode, {
    String? message,
  }) {
    switch (statusCode) {
      case 400:
        return BadRequestException(message: message ?? 'Bad Request');
      case 401:
        return UnauthorizedException(message: message ?? 'Unauthorized');
      case 403:
        return ForbiddenException(message: message ?? 'Forbidden');
      case 404:
        return NotFoundException(message: message ?? 'Not Found');
      case 409:
        return ConflictException(message: message ?? 'Conflict');
      case 500:
        return InternalServerErrorException(
          message: message ?? 'Internal Server Error',
        );
      default:
        return ServerException(message: message ?? 'HTTP Error: $statusCode');
    }
  }

  /// Creates a generic exception from any error
  static AppException createExceptionFromError(error) {
    if (error is AppException) {
      return error;
    }

    if (error is Exception) {
      return UnknownException(message: error.toString());
    }

    return UnknownException(message: error?.toString() ?? 'Unknown error');
  }

  /// Checks if an error is a network-related error
  static bool isNetworkError(error) {
    return error is NetworkException ||
        error is ServerException ||
        error is ConnectionTimeoutException ||
        error is NoInternetConnectionException;
  }

  /// Checks if an error is a data-related error
  static bool isDataError(error) {
    return error is CacheException ||
        error is DatabaseException ||
        error is DataNotFoundException ||
        error is InvalidDataException;
  }

  /// Checks if an error is an authentication error
  static bool isAuthError(error) {
    return error is AuthenticationException || error is UnauthorizedException;
  }

  /// Gets a user-friendly error message
  static String getUserFriendlyMessage(error) {
    if (error is AppException) {
      return error.message;
    }

    if (error is Failure) {
      return error.message;
    }

    return 'An unexpected error occurred. Please try again.';
  }

  /// Logs error details for debugging
  static void logError(error, {String? context}) {
    // This would typically integrate with your logging system
    // For now, we'll just print to console
    // ignore: avoid_print
    print('Error${context != null ? ' in $context' : ''}: $error');

    if (error is AppException) {
      // ignore: avoid_print
      print('Error Code: ${error.code}');
      // ignore: avoid_print
      print('Error Details: ${error.details}');
    }

    if (error is Failure) {
      // ignore: avoid_print
      print('Failure Code: ${error.code}');
      // ignore: avoid_print
      print('Failure Details: ${error.details}');
    }
  }
}

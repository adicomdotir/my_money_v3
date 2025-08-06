import 'package:dartz/dartz.dart';

import 'error.dart';

/// Example repository implementation showing proper error handling
class ExampleRepository {
  /// Example of handling network errors
  Future<Either<Failure, String>> fetchDataFromApi() async {
    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 1));

      // Simulate network error
      throw NetworkException(
        message: 'Failed to connect to server',
        code: 'NETWORK_TIMEOUT',
        details: {'timeout': 30, 'retry_count': 3},
      );
    } on AppException catch (e) {
      // Log the error for debugging
      ErrorHandler.logError(e, context: 'fetchDataFromApi');

      // Convert exception to failure
      final failure = ErrorHandler.mapExceptionToFailure(e);

      return Left(failure);
    } catch (e) {
      // Handle unexpected errors
      ErrorHandler.logError(e, context: 'fetchDataFromApi');

      final exception = ErrorHandler.createExceptionFromError(e);
      final failure = ErrorHandler.mapExceptionToFailure(exception);

      return Left(failure);
    }
  }

  /// Example of handling database errors
  Future<Either<Failure, List<String>>> getDataFromDatabase() async {
    try {
      // Simulate database operation
      await Future.delayed(Duration(milliseconds: 500));

      // Simulate database error
      throw DatabaseException(
        message: 'Database connection failed',
        code: 'DB_CONNECTION_ERROR',
        details: {'table': 'users', 'operation': 'SELECT'},
      );
    } on AppException catch (e) {
      ErrorHandler.logError(e, context: 'getDataFromDatabase');

      final failure = ErrorHandler.mapExceptionToFailure(e);

      return Left(failure);
    } catch (e) {
      ErrorHandler.logError(e, context: 'getDataFromDatabase');

      final exception = ErrorHandler.createExceptionFromError(e);
      final failure = ErrorHandler.mapExceptionToFailure(exception);

      return Left(failure);
    }
  }

  /// Example of handling HTTP errors
  Future<Either<Failure, Map<String, dynamic>>> makeHttpRequest() async {
    try {
      // Simulate HTTP request
      await Future.delayed(Duration(milliseconds: 300));

      // Simulate 404 error
      final statusCode = 404;
      final exception = ErrorHandler.mapHttpStatusToException(
        statusCode,
        message: 'User not found',
      );

      throw exception;
    } on AppException catch (e) {
      ErrorHandler.logError(e, context: 'makeHttpRequest');

      final failure = ErrorHandler.mapExceptionToFailure(e);

      return Left(failure);
    } catch (e) {
      ErrorHandler.logError(e, context: 'makeHttpRequest');

      final exception = ErrorHandler.createExceptionFromError(e);
      final failure = ErrorHandler.mapExceptionToFailure(exception);

      return Left(failure);
    }
  }

  /// Example of handling validation errors
  Future<Either<Failure, bool>> validateUserInput(String input) async {
    try {
      if (input.isEmpty) {
        throw ValidationException(
          message: 'Input cannot be empty',
          code: 'EMPTY_INPUT',
          details: {'field': 'user_input', 'value': input},
        );
      }

      if (input.length < 3) {
        throw ValidationException(
          message: 'Input must be at least 3 characters',
          code: 'TOO_SHORT',
          details: {
            'field': 'user_input',
            'min_length': 3,
            'actual_length': input.length,
          },
        );
      }

      return Right(true);
    } on AppException catch (e) {
      ErrorHandler.logError(e, context: 'validateUserInput');

      final failure = ErrorHandler.mapExceptionToFailure(e);

      return Left(failure);
    } catch (e) {
      ErrorHandler.logError(e, context: 'validateUserInput');

      final exception = ErrorHandler.createExceptionFromError(e);
      final failure = ErrorHandler.mapExceptionToFailure(exception);

      return Left(failure);
    }
  }
}

/// Example use case showing how to handle errors
class ExampleUseCase {
  final ExampleRepository repository;

  ExampleUseCase(this.repository);

  Future<Either<Failure, String>> execute() async {
    final result = await repository.fetchDataFromApi();

    return result.fold(
      (failure) {
        // Handle different types of failures
        if (ErrorHandler.isNetworkError(failure)) {
          return Left(
            NetworkFailure(
              message: 'Please check your internet connection',
              code: 'NETWORK_RETRY',
            ),
          );
        }

        if (ErrorHandler.isDataError(failure)) {
          return Left(
            DatabaseFailure(
              message: 'Unable to access data. Please try again later.',
              code: 'DB_RETRY',
            ),
          );
        }

        // Return the original failure for other cases
        return Left(failure);
      },
      (data) => Right(data),
    );
  }
}

/// Example of UI error handling
class ExampleErrorHandling {
  /// Show appropriate error message based on failure type
  static String getErrorMessage(Failure failure) {
    return ErrorHandler.getUserFriendlyMessage(failure);
  }

  /// Check if error should trigger a retry
  static bool shouldRetry(Failure failure) {
    return ErrorHandler.isNetworkError(failure) ||
           failure.code == 'DB_RETRY' ||
           failure.code == 'NETWORK_RETRY';
  }

  /// Get retry message for user
  static String getRetryMessage(Failure failure) {
    if (ErrorHandler.isNetworkError(failure)) {
      return 'Network error. Tap to retry.';
    }

    if (failure.code == 'DB_RETRY') {
      return 'Database error. Tap to retry.';
    }

    return 'An error occurred. Tap to retry.';
  }
}

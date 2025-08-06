# Error Handling System

This directory contains a comprehensive error handling system for the application, following clean architecture principles and providing consistent error management across all layers.

## Structure

### Files

- `exceptions.dart` - Application exceptions used in the data layer
- `failures.dart` - Domain layer failures used in use cases and repositories
- `error_handler.dart` - Utility functions for error handling and mapping
- `error.dart` - Barrel file for easy imports

## Architecture

The error handling system follows a layered approach:

```
Data Layer (Exceptions) → Domain Layer (Failures) → Presentation Layer (UI Error Handling)
```

### Exceptions (Data Layer)

Exceptions are thrown in the data layer when external operations fail:

```dart
// Network operations
throw NetworkException(message: 'Connection failed');
throw ServerException(message: 'Server error', code: 'SERVER_500');

// Database operations
throw DatabaseException(message: 'Database connection failed');

// HTTP operations
throw BadRequestException(message: 'Invalid request data');
throw UnauthorizedException(message: 'Authentication required');
```

### Failures (Domain Layer)

Failures are used in the domain layer and represent business logic errors:

```dart
// In use cases and repositories
return Left(NetworkFailure(message: 'No internet connection'));
return Left(ValidationFailure(message: 'Invalid input data'));
return Left(DatabaseFailure(message: 'Failed to save data'));
```

### Error Handler (Utility)

The `ErrorHandler` class provides utility functions for:

- Mapping exceptions to failures
- Converting HTTP status codes to exceptions
- Error type checking
- User-friendly error messages

## Usage Examples

### Basic Error Handling

```dart
import 'package:my_money_v3/core/error/error.dart';

// In a repository implementation
try {
  final data = await apiCall();
  return Right(data);
} catch (e) {
  final exception = ErrorHandler.createExceptionFromError(e);
  final failure = ErrorHandler.mapExceptionToFailure(exception);
  return Left(failure);
}
```

### HTTP Error Handling

```dart
// Convert HTTP status codes to exceptions
final exception = ErrorHandler.mapHttpStatusToException(
  404, 
  message: 'User not found'
);
```

### Error Type Checking

```dart
// Check if error is network-related
if (ErrorHandler.isNetworkError(error)) {
  // Handle network error
}

// Check if error is data-related
if (ErrorHandler.isDataError(error)) {
  // Handle data error
}
```

### User-Friendly Messages

```dart
// Get user-friendly error message
final message = ErrorHandler.getUserFriendlyMessage(failure);
```

## Error Types

### Network Errors
- `NetworkException` / `NetworkFailure` - General network issues
- `ServerException` / `ServerFailure` - Server-side errors
- `ConnectionTimeoutException` / `ConnectionTimeoutFailure` - Timeout errors
- `NoInternetConnectionException` / `NoInternetConnectionFailure` - No internet

### HTTP Errors
- `BadRequestException` - 400 errors
- `UnauthorizedException` / `UnauthorizedFailure` - 401 errors
- `ForbiddenException` - 403 errors
- `NotFoundException` - 404 errors
- `ConflictException` - 409 errors
- `InternalServerErrorException` - 500 errors

### Data Errors
- `CacheException` / `CacheFailure` - Cache-related errors
- `DatabaseException` / `DatabaseFailure` - Database errors
- `DataNotFoundException` / `DataNotFoundFailure` - Data not found
- `InvalidDataException` / `InvalidDataFailure` - Invalid data

### Authentication Errors
- `AuthenticationException` / `AuthenticationFailure` - Auth failures
- `UnauthorizedException` / `UnauthorizedFailure` - Unauthorized access

### Business Logic Errors
- `ValidationException` / `ValidationFailure` - Validation errors
- `BusinessLogicException` / `BusinessLogicFailure` - Business logic errors

### Generic Errors
- `UnknownException` / `UnknownFailure` - Unknown errors
- `UnexpectedException` / `UnexpectedFailure` - Unexpected errors

## Best Practices

1. **Use appropriate error types**: Choose the most specific error type for your use case
2. **Provide meaningful messages**: Always include descriptive error messages
3. **Include error codes**: Use error codes for programmatic error handling
4. **Add context details**: Use the `details` parameter for additional context
5. **Log errors**: Use `ErrorHandler.logError()` for debugging
6. **Handle errors gracefully**: Always provide fallback behavior

## Migration Guide

If you're updating from the old error system:

1. Replace direct exception throws with the new exception types
2. Update failure classes to use the new constructor pattern
3. Use `ErrorHandler.mapExceptionToFailure()` for exception-to-failure mapping
4. Update error handling in UI components to use the new error structure

## Testing

When testing error scenarios:

```dart
// Test exception handling
test('should throw NetworkException when network fails', () {
  expect(() => throw NetworkException(), throwsA(isA<NetworkException>()));
});

// Test failure mapping
test('should map NetworkException to NetworkFailure', () {
  final exception = NetworkException();
  final failure = ErrorHandler.mapExceptionToFailure(exception);
  expect(failure, isA<NetworkFailure>());
});
``` 
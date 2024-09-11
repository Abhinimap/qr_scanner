import 'package:qr_attendance/constants/app_exceptions.dart';

sealed class Result<T> {
  // Private constructor to prevent direct instantiation.
  const Result._();
}

// Represents a successful result with a value of type T.
class Success<T> extends Result<T> {
  final T value;

  // Constructor accepting the successful value.
  Success(this.value) : super._();
}

// Represents an error result with an exception and an optional message.
class Error<T> extends Result<T> {
  final AppException exception;
  final String message;

  // Constructor accepting an exception and a message.
  Error(this.exception, {this.message = ''}) : super._();
}

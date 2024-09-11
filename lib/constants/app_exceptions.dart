class AppException {
  final String errorMessage;
  AppException({this.errorMessage = ''});
}

class LocalStorageException extends AppException {
  LocalStorageException({String message = ''}) : super(errorMessage: message);
}

class AppFormatException extends AppException {
  AppFormatException({String message = ''}) : super(errorMessage: message);
}

class AppInternalServerException extends AppException {
  AppInternalServerException({String message = 'Internal Server Error'})
      : super(errorMessage: message);
}

class AppServerUnavailableException extends AppException {
  AppServerUnavailableException(
      {String message = 'Server Not Available, please Try after some time...'})
      : super(errorMessage: message);
}

class AppServerNotFoundException extends AppException {
  AppServerNotFoundException(
      {String message = 'Server Not Found, please try again...'})
      : super(errorMessage: message);
}

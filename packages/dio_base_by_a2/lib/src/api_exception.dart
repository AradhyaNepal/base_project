
class APIException implements Exception {
  String errorMessage;
  int statusCode;
  Object? error;
  StackTrace? stackTrace;

  APIException(
      this.errorMessage,
      this.statusCode, {
        this.error,
        this.stackTrace,
      });
}

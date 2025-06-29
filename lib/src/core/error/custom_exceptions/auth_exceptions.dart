import 'package:dio/dio.dart';

/// This class is used to handle exceptions related to authentication with custom messages
/// the handler will be used is [AuthExceptionHandler]
class AuthException extends DioException {
  AuthException(
      {required super.requestOptions,
      super.error,
      super.message,
      super.response,
      super.stackTrace,
      super.type});
}

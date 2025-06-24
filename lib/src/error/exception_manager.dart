import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart' show Fluttertoast;
import 'package:sunnah_academy/src/error/custom_exceptions/auth_exceptions.dart'
    show AuthException;
import 'package:sunnah_academy/src/error/handlers/auth_exception_handler.dart';
import 'package:sunnah_academy/src/error/handlers/dio_exception_handler.dart';
import 'package:sunnah_academy/src/error/handlers/unexpected_exception_handler.dart';

abstract class ExceptionHandler {
  String handle(Exception exception);
  String getIconPath(Exception exception);
}

class ExceptionManager {
  static final Map<Type, ExceptionHandler> _handlers = <Type, ExceptionHandler>{
    DioException: DioExceptionHandler(),
    AuthException: AuthExceptionHandler(),
    UnexpectedExceptionHandler: UnexpectedExceptionHandler(),
  };

  static String getMessage(Exception exception) {
    return _handlers[exception.runtimeType]?.handle(exception) ??
        _handlers[UnexpectedExceptionHandler]!.handle(exception);
  }

  static String getIconPath(Exception exception) {
    return _handlers[exception.runtimeType]?.getIconPath(exception) ??
        _handlers[UnexpectedExceptionHandler]!.getIconPath(exception);
  }

  static void showMessage(Exception exception) {
    Fluttertoast.showToast(
      msg: getMessage(exception),
    );
  }
}

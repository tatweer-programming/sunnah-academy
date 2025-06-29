import 'package:sunnah_academy/src/core/error/exception_manager.dart';
import 'package:sunnah_academy/src/core/utils/assets_manager.dart'
    show AssetsManager;

class UnexpectedExceptionHandler implements ExceptionHandler {
  @override
  String handle(Exception exception) {
    return "حدث خطاء غير متوقع";
  }

  @override
  String getIconPath(Exception exception) {
    return AssetsManager.errorIcon;
  }
}

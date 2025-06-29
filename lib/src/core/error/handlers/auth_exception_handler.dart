import 'package:sunnah_academy/src/core/error/custom_exceptions/auth_exceptions.dart';
import 'package:sunnah_academy/src/core/error/exception_manager.dart';
import 'package:sunnah_academy/src/core/utils/assets_manager.dart';

class AuthExceptionHandler implements ExceptionHandler {
  @override
  String handle(Exception exception) {
    final err = exception as AuthException;
    switch (err.response?.statusCode ?? 0) {
      case 400:
        return "بيانات الاعتماد غير صالحة أو الطلب غير صحيح";
      case 401:
        return "اسم المستخدم أو كلمة المرور غير صحيحة";
      case 403:
        return "ليس لديك صلاحية للوصول إلى هذا المورد";
      case 404:
        return "المستخدم غير موجود";
      case 409:
        return "المستخدم موجود بالفعل";
      case 422:
        return "بيانات غير صالحة. يرجى التحقق من المعلومات المدخلة";
      case 423:
        return "الحساب مغلق. يرجى التواصل مع الدعم الفني";
      case 429:
        return "محاولات تسجيل دخول كثيرة. يرجى المحاولة لاحقاً";
      case 451:
        return "الحساب موقوف لأسباب قانونية";
      case 503:
        return "خدمة المصادقة غير متوفرة حالياً";

      default:
        return AssetsManager.errorIcon;
    }
  }

  @override
  String getIconPath(Exception exception) {
    switch ((exception as AuthException).response?.statusCode ?? 0) {
      case 401:
        return AssetsManager.unauthorizedError;
      case 403:
        return AssetsManager.forbiddenError;
      case 404:
        return AssetsManager.notFoundError;
      case 400:
        return AssetsManager.badRequestError;

      default:
        return AssetsManager.errorIcon;
    }
  }
}

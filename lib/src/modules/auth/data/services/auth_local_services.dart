import 'package:dartz/dartz.dart';
import 'package:sunnah_academy/src/core/apis/api.dart';
import 'package:sunnah_academy/src/core/services/secure_storage_helper.dart';
import 'package:sunnah_academy/src/modules/student/data/models/student.dart';
import 'package:sunnah_academy/src/modules/auth/data/models/auth_info.dart';

class AuthLocalServices {
  // This class can be used to manage local authentication services
  // such as saving user credentials, tokens, or preferences locally.

  Future<Either<Exception, Unit>> saveAuthResult(
      AuthInfo authInfo, Student student) async {
    ApiManager.authToken = authInfo.token;
    ApiManager.userId = authInfo.id;
    try {
      await SecureStorageHelper.saveData(
          key: "auth_info",
          value: authInfo.toJson(),
          expiresAfter: Duration(days: 30));
      return Right(unit);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  // Logging out the user by clearing the stored auth info
  Future<Either<Exception, Unit>> logout() async {
    try {
      await SecureStorageHelper.removeData(key: "auth_info");
      ApiManager.authToken = null;
      ApiManager.userId = null;
      return Right(unit);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}

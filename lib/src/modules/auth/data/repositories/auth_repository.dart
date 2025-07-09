import 'package:dartz/dartz.dart';
import 'package:sunnah_academy/src/modules/auth/data/models/auth_info.dart';
import 'package:sunnah_academy/src/modules/auth/data/models/student_creation_form.dart';
import 'package:sunnah_academy/src/modules/auth/data/services/auth_local_services.dart';
import 'package:sunnah_academy/src/modules/auth/data/services/auth_remote_services.dart';
import 'package:sunnah_academy/src/modules/student/data/models/student.dart';

class AuthRepository {
  final AuthRemoteServices _authRemoteServices;
  final AuthLocalServices _authLocalServices;
  AuthRepository(this._authRemoteServices, this._authLocalServices);

  Future<Either<Exception, Unit>> register(
      StudentCreationForm creationForm) async {
    var remoteResult = await _authRemoteServices.register(creationForm);
    return _handleAuthResult(remoteResult);
  }

  Future<Either<Exception, Unit>> login(
      String username, String password) async {
    var remoteResult = await _authRemoteServices.login(username, password);
    return _handleAuthResult(remoteResult);
  }

  Future<Either<Exception, Unit>> forgotPassword(String email) async {
    var remoteResult = await _authRemoteServices.forgotPassword(email);
    return remoteResult.fold(
      (exception) => Left(exception),
      (success) async {
        return const Right(unit);
      },
    );
  }

  // Example method for user logout
  Future<Either<Exception, Unit>> logout() async {
    // Clear local authentication data
    var localResult = await _authLocalServices.logout();
    return localResult.fold(
      (exception) => Left(exception),
      (success) async {
        return const Right(unit);
      },
    );
  }

  // Handle the result of authentication operations to save user data locally and return appropriate response
  Either<Exception, Unit> _handleAuthResult(
      Either<Exception, Tuple2<Student, AuthInfo>> result) {
    return result.fold(
      (exception) => Left(exception),
      (success) {
        // Save user data locally after successful login
        _authLocalServices.saveAuthResult(success.value2, success.value1);
        return const Right(unit);
      },
    );
  }
}

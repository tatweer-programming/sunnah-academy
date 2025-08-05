import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sunnah_academy/src/core/apis/end_points.dart';
import 'package:sunnah_academy/src/modules/auth/data/models/auth_info.dart';
import 'package:sunnah_academy/src/modules/auth/data/models/student_creation_form.dart';
import 'package:sunnah_academy/src/modules/student/data/models/student.dart';

import '../../../../core/apis/dio_helper.dart';
import '../../../../core/error/custom_exceptions/auth_exceptions.dart';

class AuthRemoteServices {
  String? verificationId;

  Future<Either<Exception, Tuple2<Student, AuthInfo>>> register(
      StudentCreationForm creationForm) async {
    try {
      var response = await DioHelper.postData(
          path: EndPoints.register, data: creationForm.toJson());
      var authInfo = AuthInfo.fromJson(response.data);
      var student = Student.fromJson(response.data['user']);
      return Right(tuple2(student, authInfo));
    } on Exception catch (e) {
      return Left(_classifyException(e));
    }
  }

  Future<Either<Exception, Tuple2<Student, AuthInfo>>> login(
      String email, String password) async {
    try {
      var response = await DioHelper.postData(path: EndPoints.login, data: {
        "email": email,
        "password": password,
      });
      var authInfo = AuthInfo.fromJson(response.data);
      var student = Student.fromJson(response.data['data']);
      return Right(tuple2(student, authInfo));
    } on Exception catch (e) {
      return Left(_classifyException(e));
    }
  }

  Future<Either<Exception, Unit>> forgotPassword(String email) async {
    try {
      var response =
          await DioHelper.postData(path: EndPoints.forgotPassword, data: {
        "email": email,
      });
      verificationId = response.data['userId'];
      return const Right(unit);
    } on Exception catch (e) {
      return Left(_classifyException(e));
    }
  }

  Future<Either<Exception, Unit>> verifyCode(String code) async {
    try {
      await DioHelper.postData(path: EndPoints.verifyOtp, data: {
        "id": verificationId,
        "code": code,
      });
      return const Right(unit);
    } on Exception catch (e) {
      return Left(_classifyException(e));
    }
  }

  Future<Either<Exception, Unit>> resetPassword(
    String newPassword,
  ) async {
    try {
      await DioHelper.postData(path: EndPoints.resetPassword, data: {
        "newPassword": newPassword,
        "id": verificationId,
      });
      return const Right(unit);
    } on Exception catch (e) {
      return Left(_classifyException(e));
    }
  }

  _classifyException(
    Exception exception,
  ) {
    {
      if (exception is DioException) {
        AuthException authException = AuthException(
            requestOptions: exception.requestOptions,
            response: exception.response);
        return authException;
      }
      return exception;
    }
  }
}

import 'package:dartz/dartz.dart';
import 'package:sunnah_academy/src/core/apis/end_points.dart';
import 'package:sunnah_academy/src/modules/auth/data/models/auth_info.dart';
import 'package:sunnah_academy/src/modules/auth/data/models/student_creation_form.dart';
import 'package:sunnah_academy/src/modules/student/data/models/student.dart';

import '../../../../core/apis/dio_helper.dart';

class AuthRemoteServices {
  Future<Either<Exception, Tuple2<Student, AuthInfo>>> register(
      StudentCreationForm creationForm) async {
    try {
      var response = await DioHelper.postData(
          path: EndPoints.register, data: creationForm.toJson());
      var authInfo = AuthInfo.fromJson(response.data);
      var student = Student.fromJson(response.data['student']);
      return Right(tuple2(student, authInfo));
    } on Exception catch (e) {
      return Left(e);
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
      var student = Student.fromJson(response.data['student']);
      return Right(tuple2(student, authInfo));
    } on Exception catch (e) {
      return Left(e);
    }
  }

  Future<Either<Exception, Unit>> forgotPassword(String email) async {
    try {
      await DioHelper.postData(path: EndPoints.forgotPassword, data: {
        "email": email,
      });
      return const Right(unit);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}

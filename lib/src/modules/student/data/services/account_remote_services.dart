import 'package:dartz/dartz.dart';
import 'package:sunnah_academy/src/core/apis/end_points.dart';
import 'package:sunnah_academy/src/modules/student/data/models/student.dart';

import '../../../../core/apis/dio_helper.dart';

class StudentRemoteServices {
  /// Get student profile
  Future<Either<Exception, Student>> getProfile() async {
    try {
      var response = await DioHelper.getData(path: EndPoints.profile);
      var student = Student.fromJson(response.data['data']);
      return Right(student);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  /// Update student profile
  Future<Either<Exception, Student>> updateProfile({
    String? name,
    String? phoneNumber,
    String? email,
    String? birthDate,
  }) async {
    try {
      // Prepare data map, only include non-null values
      Map<String, dynamic> data = {};
      if (name != null) data['name'] = name;
      if (phoneNumber != null) data['phoneNumber'] = phoneNumber;
      if (email != null) data['email'] = email;
      if (birthDate != null) data['birthDate'] = birthDate;

      var response = await DioHelper.putData(
        path: EndPoints.profile,
        data: data,
      );
      var student = Student.fromJson(response.data['data']);
      return Right(student);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  /// Delete student student
  Future<Either<Exception, Unit>> deleteAccount() async {
    try {
      await DioHelper.deleteData(path: EndPoints.profile);
      return const Right(unit);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}

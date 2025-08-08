import 'package:dartz/dartz.dart';
import 'package:sunnah_academy/src/modules/student/data/models/student.dart';
import 'package:sunnah_academy/src/modules/student/data/services/account_remote_services.dart';

class StudentRepository {
  final StudentRemoteServices _remoteServices;
  const StudentRepository(this._remoteServices);

  Future<Either<Exception, Student>> getProfile() {
    return _remoteServices.getProfile();
  }

  Future<Either<Exception, Student>> updateProfile({
    String? name,
    String? phoneNumber,
    String? email,
    String? birthDate,
  }) {
    return _remoteServices.updateProfile(
        email: email,
        name: name,
        birthDate: birthDate,
        phoneNumber: phoneNumber);
  }

  Future<Either<Exception, Unit>> deleteAccount() {
    return _remoteServices.deleteAccount();
  }
}

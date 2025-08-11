import 'package:dartz/dartz.dart';
import 'package:sunnah_academy/src/modules/subjects/data/models/subject.dart';
import 'package:sunnah_academy/src/modules/subjects/data/services/subjects_services.dart';

class SubjectsRepository {
  final BaseSubjectServices _remoteServices;
  SubjectsRepository(this._remoteServices);

  List<Subject> _subjects = [];

  Future<Either<Exception, List<Subject>>> getSubjects(
      {bool? forceRefresh}) async {
    if (_subjects.isNotEmpty && forceRefresh != true) {
      return Right(_subjects);
    }
    final result = await _remoteServices.getSubjects();
    return result.fold(
      (exception) => Left(exception),
      (subjects) {
        _subjects = subjects;
        return Right(_subjects);
      },
    );
  }

  Future<Either<Exception, Unit>> completeLecture({
    required String lectureId,
  }) async {
    return await _remoteServices.completeLecture(lectureId: lectureId);
  }
}

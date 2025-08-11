import 'package:dartz/dartz.dart';
import 'package:sunnah_academy/src/modules/subjects/data/models/lecture.dart';
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
    final result = await _remoteServices.completeLecture(lectureId: lectureId);
    return result.fold(
      (exception) => Left(exception),
      (success) {
        Lecture lecture = _subjects
            .firstWhere((subject) =>
                subject.lectures.any((lecture) => lecture.id == lectureId))
            .lectures
            .firstWhere((lecture) => lecture.id == lectureId);
        lecture = lecture.copyWith(isComplete: true);
        return Right(unit);
      },
    );
  }
}

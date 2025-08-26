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

  Subject getSubjectById({required String subjectId}) {
    return _subjects.firstWhere((subject) => subject.id == subjectId);
  }

  Future<Either<Exception, List<Subject>>> completeLecture({
    required String lectureId,
  }) async {
    final result = await _remoteServices.completeLecture(lectureId: lectureId);
    return result.fold(
      (exception) => Left(exception),
      (success) {
        // Update the lecture locally
        _updateLectureStatus(lectureId, true);
        return Right(_subjects);
      },
    );
  }

  List<Subject> markLectureAsCompleted({required String lectureId}) {
    _updateLectureStatus(lectureId, true);
    return _subjects;
  }

  List<Subject> markSubjectAsCompleted({required String subjectId}) {
    final subjectIndex =
        _subjects.indexWhere((subject) => subject.id == subjectId);
    if (subjectIndex != -1) {
      _subjects[subjectIndex] =
          _subjects[subjectIndex].copyWith(isCompleted: true);
    }
    return _subjects;
  }

  // Helper method to update lecture status and recalculate progress
  void _updateLectureStatus(String lectureId, bool isComplete) {
    for (int subjectIndex = 0;
        subjectIndex < _subjects.length;
        subjectIndex++) {
      final subject = _subjects[subjectIndex];
      final lectureIndex =
          subject.lectures.indexWhere((lecture) => lecture.id == lectureId);

      if (lectureIndex != -1) {
        // Update the lecture
        final updatedLectures = List<Lecture>.from(subject.lectures);
        updatedLectures[lectureIndex] =
            updatedLectures[lectureIndex].copyWith(isComplete: isComplete);

        // Calculate new progress
        final completedLectures =
            updatedLectures.where((lecture) => lecture.isComplete).length;
        final totalLectures = updatedLectures.length;
        final newProgress = totalLectures > 0
            ? (completedLectures / totalLectures * 100).round()
            : 0;

        // Update the subject with new lectures and progress
        _subjects[subjectIndex] = subject.copyWith(
          lectures: updatedLectures,
          progress: newProgress,
          isCompleted: newProgress == 100,
        );

        break;
      }
    }
  }

  // Get current subjects (for UI updates)
  List<Subject> getCurrentSubjects() {
    return List.from(_subjects);
  }
}

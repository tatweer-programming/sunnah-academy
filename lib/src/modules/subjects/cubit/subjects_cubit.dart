import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sunnah_academy/src/modules/subjects/data/models/subject.dart';
import 'package:sunnah_academy/src/modules/subjects/data/repositories/subjects_repository.dart';

part 'subjects_state.dart';

class SubjectsCubit extends Cubit<SubjectsState> {
  final SubjectsRepository _repository;
  SubjectsCubit(this._repository) : super(SubjectsInitial());

  Future<void> getSubjects({bool? forceRefresh}) async {
    SubjectsState currentState = state;
    emit(GetSubjectsLoading(subjects: currentState.subjects));

    final result = await _repository.getSubjects(forceRefresh: forceRefresh);
    result.fold(
      (exception) =>
          emit(GetSubjectsError(exception, subjects: currentState.subjects)),
      (subjects) => emit(GetSubjectsSuccess(subjects: subjects)),
    );
  }

  /// Mark lecture as completed through API
  Future<void> completeLecture({required String lectureId}) async {
    SubjectsState currentState = state;
    emit(CompleteLectureLoading(lectureId, subjects: currentState.subjects));

    final result = await _repository.completeLecture(lectureId: lectureId);
    result.fold(
      (exception) => emit(CompleteLectureError(lectureId, exception,
          subjects: currentState.subjects)),
      (subjects) => emit(CompleteLectureSuccess(lectureId, subjects: subjects)),
    );
  }

  Subject getSubjectById({required String subjectId}) {
    Subject subject = _repository.getSubjectById(subjectId: subjectId);
    emit(GetSubjectByIdSuccess(subject,
        subjects: _repository.getCurrentSubjects()));
    return subject;
  }

  /// Mark lecture as completed locally
  Future<void> markLectureAsCompleted({required String lectureId}) async {
    var updatedSubjects =
        _repository.markLectureAsCompleted(lectureId: lectureId);
    emit(CompleteLectureSuccess(lectureId, subjects: updatedSubjects));
  }

  /// Mark subject as completed locally
  Future<void> markSubjectAsCompleted({required String subjectId}) async {
    var updatedSubjects =
        _repository.markSubjectAsCompleted(subjectId: subjectId);
    emit(CompleteSubjectSuccess(subjectId, subjects: updatedSubjects));
  }

  /// Refresh current subject data after updates
  void refreshSubjectById({required String subjectId}) {
    try {
      Subject subject = _repository.getSubjectById(subjectId: subjectId);
      emit(GetSubjectByIdSuccess(subject,
          subjects: _repository.getCurrentSubjects()));
    } catch (e) {
      // Handle error if subject not found
    }
  }

  /// Get current subjects without emitting loading state
  void getCurrentSubjects() {
    final subjects = _repository.getCurrentSubjects();
    if (subjects.isNotEmpty) {
      emit(GetSubjectsSuccess(subjects: subjects));
    }
  }
}

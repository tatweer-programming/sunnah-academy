import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sunnah_academy/src/modules/subjects/data/models/subject.dart';
import 'package:sunnah_academy/src/modules/subjects/data/repositories/subjects_repository.dart';

part 'subjects_state.dart';

class SubjectsCubit extends Cubit<SubjectsState> {
  final SubjectsRepository _repository;
  SubjectsCubit(this._repository) : super(SubjectsInitial());
  late List<Subject> subjects = [];
  Future<void> getSubjects({bool? forceRefresh}) async {
    emit(GetSubjectsLoading());
    final result = await _repository.getSubjects();
    result.fold((exception) => emit(GetSubjectsError(exception)), (subjects) {
      this.subjects = subjects;
      emit(GetSubjectsSuccess());
    });
  }

  Future<void> completeLecture({required String lectureId}) async {
    emit(CompleteLectureLoading(lectureId));
    final result = await _repository.completeLecture(lectureId: lectureId);
    result.fold(
      (exception) => emit(CompleteLectureError(lectureId, exception)),
      (_) => emit(CompleteLectureSuccess(lectureId)),
    );
  }

  Future<void> markLectureAsCompleted({required String lectureId}) async {
    _repository.markLectureAsCompleted(lectureId: lectureId);
    emit(CompleteLectureSuccess(lectureId));
  }

  Future<void> markSubjectAsCompleted({required String lectureId}) async {
    _repository.markSubjectAsCompleted(subjectId: lectureId);
    emit(CompleteSubjectSuccess(lectureId));
  }
}

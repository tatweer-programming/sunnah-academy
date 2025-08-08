import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sunnah_academy/src/modules/subjects/data/models/subject.dart';

import '../data/repositories/subjects_repository.dart';

part 'subjects_state.dart';

class SubjectsCubit extends Cubit<SubjectsState> {
  final SubjectsRepository _repository;
  SubjectsCubit(this._repository) : super(SubjectsInitial());

  Future<void> getSubjects() async {
    emit(GetSubjectsLoading());
    final result = await _repository.getSubjects();
    result.fold(
      (exception) => emit(GetSubjectsError(exception)),
      (subjects) => emit(GetSubjectsSuccess(subjects)),
    );
  }
}

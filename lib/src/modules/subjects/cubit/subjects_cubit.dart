import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sunnah_academy/src/modules/subjects/data/models/subject.dart';

part 'subjects_state.dart';

class SubjectsCubit extends Cubit<SubjectsState> {
  SubjectsCubit() : super(SubjectsInitial());
}

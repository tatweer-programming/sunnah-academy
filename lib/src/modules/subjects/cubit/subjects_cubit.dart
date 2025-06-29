import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'subjects_state.dart';

class SubjectsCubit extends Cubit<SubjectsState> {
  SubjectsCubit() : super(SubjectsInitial());
}

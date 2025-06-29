part of 'subjects_cubit.dart';

sealed class SubjectsState extends Equatable {
  const SubjectsState();
}

final class SubjectsInitial extends SubjectsState {
  @override
  List<Object> get props => [];
}

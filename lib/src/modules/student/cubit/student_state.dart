part of 'student_cubit.dart';

sealed class StudentState extends Equatable {
  const StudentState();
}

final class StudentInitial extends StudentState {
  @override
  List<Object> get props => [];
}

final class GetProfileLoading extends StudentState {
  @override
  List<Object> get props => [];
}

final class GetProfileSuccess extends StudentState {
  final Student student;
  const GetProfileSuccess(this.student);
  @override
  List<Object> get props => [student];
}

final class StudentError extends StudentState {
  final Exception error;
  const StudentError(this.error);
  @override
  List<Object> get props => [error];
}

final class UpdateProfileLoading extends StudentState {
  @override
  List<Object> get props => [];
}

final class UpdateProfileSuccess extends StudentState {
  final Student student;
  const UpdateProfileSuccess(this.student);
  @override
  List<Object> get props => [student];
}

final class DeleteProfileLoading extends StudentState {
  @override
  List<Object> get props => [];
}

final class DeleteProfileSuccess extends StudentState {
  @override
  List<Object> get props => [];
}

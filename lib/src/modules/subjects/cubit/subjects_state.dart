part of 'subjects_cubit.dart';

sealed class SubjectsState extends Equatable {
  const SubjectsState();
}

final class SubjectsInitial extends SubjectsState {
  @override
  List<Object> get props => [];
}

final class GetSubjectsLoading extends SubjectsState {
  @override
  List<Object> get props => [];
}

final class GetSubjectsSuccess extends SubjectsState {
  final List<Subject> subjects;

  const GetSubjectsSuccess(this.subjects);

  @override
  List<Object> get props => [subjects];
}

final class GetSubjectsError extends SubjectsState {
  final Exception exception;

  const GetSubjectsError(this.exception);

  @override
  List<Object> get props => [exception];
}

final class MarkLectureCompleteLoading extends SubjectsState {
  final String lectureId;

  const MarkLectureCompleteLoading(this.lectureId);

  @override
  List<Object> get props => [lectureId];
}

final class MarkLectureCompleteSuccess extends SubjectsState {
  final String lectureId;

  const MarkLectureCompleteSuccess(this.lectureId);

  @override
  List<Object> get props => [lectureId];
}

final class MarkLectureCompleteError extends SubjectsState {
  final String lectureId;
  final Exception exception;

  const MarkLectureCompleteError(this.lectureId, this.exception);

  @override
  List<Object> get props => [lectureId, exception];
}

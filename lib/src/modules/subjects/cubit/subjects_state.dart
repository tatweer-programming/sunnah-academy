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
  @override
  List<Object> get props => [];
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

final class CompleteLectureLoading extends SubjectsState {
  final String lectureId;

  const CompleteLectureLoading(this.lectureId);

  @override
  List<Object> get props => [lectureId];
}

final class CompleteLectureSuccess extends SubjectsState {
  final String lectureId;

  const CompleteLectureSuccess(this.lectureId);

  @override
  List<Object> get props => [lectureId];
}

final class CompleteLectureError extends SubjectsState {
  final String lectureId;
  final Exception exception;

  const CompleteLectureError(this.lectureId, this.exception);

  @override
  List<Object> get props => [lectureId, exception];
}

final class CompleteSubjectLoading extends SubjectsState {
  final String subjectId;
  const CompleteSubjectLoading(this.subjectId);
  @override
  List<Object> get props => [subjectId];
}

final class CompleteSubjectSuccess extends SubjectsState {
  final String subjectId;
  const CompleteSubjectSuccess(this.subjectId);
  @override
  List<Object> get props => [subjectId];
}

final class CompleteSubjectError extends SubjectsState {
  final String subjectId;
  final Exception exception;
  const CompleteSubjectError(this.subjectId, this.exception);
  @override
  List<Object> get props => [subjectId, exception];
}

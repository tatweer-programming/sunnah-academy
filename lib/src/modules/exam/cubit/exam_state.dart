part of 'exam_cubit.dart';

sealed class ExamState extends Equatable {
  const ExamState();
  @override
  List<Object?> get props => [];
}

final class ExamInitial extends ExamState {}

final class ExamLoading extends ExamState {}

final class ExamLoaded extends ExamState {
  final Exam exam;

  const ExamLoaded({required this.exam});

  @override
  List<Object> get props => [exam];
}

final class ExamError extends ExamState {
  final String message;

  const ExamError({required this.message});

  @override
  List<Object> get props => [message];
}

class ExamInProgress extends ExamState {
  final Exam exam;
  final ExamCondition examCondition;
  final int currentQuestionIndex;
  final HashMap<String, int> selectedAnswers;

  const ExamInProgress({
    required this.exam,
    required this.examCondition,
    required this.currentQuestionIndex,
    required this.selectedAnswers,
  });

  @override
  List<Object> get props =>
      [examCondition, exam, currentQuestionIndex, selectedAnswers];

  ExamInProgress copyWith({
    Exam? exam,
    int? currentQuestionIndex,
    ExamCondition? examCondition,
    HashMap<String, int>? selectedAnswers,
  }) {
    return ExamInProgress(
      exam: exam ?? this.exam,
      examCondition: examCondition ?? this.examCondition,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
    );
  }
}

class ExamSubmitting extends ExamState {}

class ExamSubmissionSuccess extends ExamState {
  final String message;

  const ExamSubmissionSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class ExamSubmissionError extends ExamState {
  final String message;

  const ExamSubmissionError({required this.message});

  @override
  List<Object> get props => [message];
}

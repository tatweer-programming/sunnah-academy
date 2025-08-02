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
}/// State indicating the user is currently taking the exam.
class ExamInProgress extends ExamState {
  final Exam exam;
  final int currentQuestionIndex;
  final HashMap<String, int> selectedAnswers; // Using HashMap for efficient lookups

  const ExamInProgress({
    required this.exam,
    required this.currentQuestionIndex,
    required this.selectedAnswers,
  });

  @override
  List<Object> get props => [exam, currentQuestionIndex, selectedAnswers];

  ExamInProgress copyWith({
    Exam? exam,
    int? currentQuestionIndex,
    HashMap<String, int>? selectedAnswers,
  }) {
    return ExamInProgress(
      exam: exam ?? this.exam,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
    );
  }
}

/// State indicating that answers are being submitted.
class ExamSubmitting extends ExamState {}

/// State indicating successful submission of answers.
class ExamSubmissionSuccess extends ExamState {
  final String message;

  const ExamSubmissionSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

/// State indicating an error during answer submission.
class ExamSubmissionError extends ExamState {
  final String message;

  const ExamSubmissionError({required this.message});

  @override
  List<Object> get props => [message];
}
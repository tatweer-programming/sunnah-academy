import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/models/answer.dart';
import '../data/models/exam.dart';
import '../data/models/submit_answer_request.dart';
import '../data/repositories/exam_repository.dart';

part 'exam_state.dart';

class ExamCubit extends Cubit<ExamState> {
  final ExamRepository examRepository;

  ExamCubit({required this.examRepository}) : super(ExamInitial());

  /// Fetches exam details from the repository.
  Future<void> getExamDetails(String examId) async {
    emit(ExamLoading());
    final result = await examRepository.getExam(examId);
    result.fold(
      (failure) => emit(ExamError(message: failure.toString())),
      (exam) => emit(ExamLoaded(exam: exam)),
    );
  }
  void startExam(Exam exam) {
    emit(ExamInProgress(
      exam: exam,
      currentQuestionIndex: 0,
      selectedAnswers: HashMap<String, int>(),
    ));
  }

  /// Selects an answer for the current question.
  void selectAnswer(String questionId, int selectedOptionIndex) {
    if (state is ExamInProgress) {
      final currentState = state as ExamInProgress;
      final updatedAnswers = HashMap<String, int>.from(currentState.selectedAnswers);
      updatedAnswers[questionId] = selectedOptionIndex;
      emit(currentState.copyWith(selectedAnswers: updatedAnswers));
    }
  }

  /// Moves to the next question.
  void nextQuestion() {
    if (state is ExamInProgress) {
      final currentState = state as ExamInProgress;
      if (currentState.currentQuestionIndex < currentState.exam.questions.length - 1) {
        emit(currentState.copyWith(currentQuestionIndex: currentState.currentQuestionIndex + 1));
      } else {
        // If it's the last question, automatically trigger submission
        submitAnswers();
      }
    }
  }

  /// Submits the collected answers.
  Future<void> submitAnswers() async {
    if (state is ExamInProgress) {
      final currentState = state as ExamInProgress;
      emit(ExamSubmitting());

      final List<Answer> answers = currentState.selectedAnswers.entries
          .map((entry) => Answer(questionId: entry.key, selectedOptionIndex: entry.value))
          .toList();

      final submitRequest = SubmitAnswersRequest(answers: answers, examId: currentState.exam.id);
      final result = await examRepository.submitExamAnswers(submitRequest);

      result.fold(
            (failure) => emit(ExamSubmissionError(message: failure.toString())),
            (successMessage) => emit(ExamSubmissionSuccess(message: successMessage)),
      );
    }
  }
}

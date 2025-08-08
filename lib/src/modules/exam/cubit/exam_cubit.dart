import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sunnah_academy/src/modules/exam/ui/widgets/navigation_question_button.dart';

import '../data/models/answer.dart';
import '../data/models/exam.dart';
import '../data/models/submit_answer_request.dart';
import '../data/repositories/exam_repository.dart';

part 'exam_state.dart';

class ExamCubit extends Cubit<ExamState> {
  final ExamRepository _examRepository;

  ExamCubit(this._examRepository) : super(ExamInitial());
  Future<void> getExamDetails(String examId) async {
    emit(ExamLoading());
    final result = await _examRepository.getExam(examId);
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
      final updatedAnswers =
          HashMap<String, int>.from(currentState.selectedAnswers);
      updatedAnswers[questionId] = selectedOptionIndex;
      emit(currentState.copyWith(selectedAnswers: updatedAnswers));
    }
  }

  void nextQuestion(NavigationType navigationType) {
    print(navigationType);
    if (state is ExamInProgress) {
      final currentState = state as ExamInProgress;
      if (navigationType == NavigationType.next) {
        emit(currentState.copyWith(
            currentQuestionIndex: currentState.currentQuestionIndex + 1));
      } else if (navigationType == NavigationType.previous) {
        emit(currentState.copyWith(
            currentQuestionIndex: currentState.currentQuestionIndex - 1));
      } else {
        submitAnswers();
      }
    }
  }

  Future<void> submitAnswers() async {
    if (state is ExamInProgress) {
      final currentState = state as ExamInProgress;
      emit(ExamSubmitting());

      final List<Answer> answers = currentState.selectedAnswers.entries
          .map((entry) =>
              Answer(questionId: entry.key, selectedOptionIndex: entry.value))
          .toList();

      final submitRequest =
          SubmitAnswersRequest(answers: answers, examId: currentState.exam.id);
      final result = await _examRepository.submitExamAnswers(submitRequest);

      result.fold(
        (failure) => emit(ExamSubmissionError(message: failure.response!.data["message"]??"حدث خطأ ما")),
        (successMessage) =>
            emit(ExamSubmissionSuccess(message: successMessage)),
      );
    }
  }
}

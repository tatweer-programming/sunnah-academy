// exam_questions_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:sunnah_academy/src/core/routing/navigation_manager.dart';
import 'package:sunnah_academy/src/core/widgets/custom_app_bar.dart';

import '../../../subjects/ui/screens/subjects_screen.dart';
import '../../cubit/exam_cubit.dart';
import '../../data/models/exam.dart';
import '../../data/models/question.dart';
import '../widgets/navigation_question_button.dart';
import '../widgets/option_widget.dart';
import '../widgets/question_card.dart';

class ExamQuestionsScreen extends StatelessWidget {
  final Exam exam;

  const ExamQuestionsScreen({
    super.key,
    required this.exam,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: CustomAppBar(
          title: exam.title,
        ),
        body: BlocConsumer<ExamCubit, ExamState>(
          listener: _handleStateChanges,
          builder: _buildBody,
        ),
      ),
    );
  }

  void _handleStateChanges(BuildContext context, ExamState state) {
    if (state is ExamSubmissionSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
        ),
      );
      context.pushAndRemove(SubjectsScreen());
    } else if (state is ExamSubmissionError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
        ),
      );
      context.pushAndRemove(SubjectsScreen());
    }
  }

  Widget _buildBody(BuildContext context, ExamState state) {
    if (state is ExamInProgress) {
      return _ExamInProgressWidget(
        exam: exam,
        state: state,
      );
    } else if (state is ExamSubmitting) {
      return const _ExamSubmittingWidget();
    }

    return const SizedBox.shrink();
  }
}

class _ExamInProgressWidget extends StatelessWidget {
  final Exam exam;
  final ExamInProgress state;

  const _ExamInProgressWidget({
    required this.exam,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final Question currentQuestion = exam.questions[state.currentQuestionIndex];
    final int? selectedOptionIndex = state.selectedAnswers[currentQuestion.id];

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            QuestionProgressIndicator(
              currentIndex: state.currentQuestionIndex,
              totalQuestions: exam.questions.length,
            ),
            SizedBox(height: 3.h),
            QuestionCard(question: currentQuestion),
            SizedBox(height: 4.h),
            Expanded(
              child: OptionsListView(
                question: currentQuestion,
                state: state,
                selectedOptionIndex: selectedOptionIndex,
              ),
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: NavigationButton(
                      navigationType: _getBackNavigationType(state),
                      onPressed: () => _handleButtonPress(
                          context, _getBackNavigationType(state))),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: NavigationButton(
                      navigationType: _getNextNavigationType(state),
                      onPressed: () => _handleButtonPress(
                          context, _getNextNavigationType(state))),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleButtonPress(BuildContext context, NavigationType navigationType) {
    final cubit = context.read<ExamCubit>();
    if (navigationType == NavigationType.finish) {
      cubit.submitAnswers();
    } else {
      cubit.nextQuestion(navigationType);
    }
  }

  _getNextNavigationType(ExamInProgress state) {
    if (state.currentQuestionIndex == exam.questions.length - 1) {
      return NavigationType.finish;
    } else {
      return NavigationType.next;
    }
  }

  _getBackNavigationType(ExamInProgress state) {
    if (state.currentQuestionIndex == 0) {
      return null;
    } else {
      return NavigationType.previous;
    }
  }
}

class _ExamSubmittingWidget extends StatelessWidget {
  const _ExamSubmittingWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 15.w,
            height: 15.w,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
              strokeWidth: 0.8.w,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'يتم إرسال إجاباتك ...',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: Colors.blueGrey.shade600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'يرجى الانتظار',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.blueGrey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}

// exam_questions_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:sunnah_academy/src/core/widgets/custom_app_bar.dart';

import '../../cubit/exam_cubit.dart';
import '../../data/models/exam.dart';
import '../../data/models/question.dart';

class ExamQuestionsScreen extends StatelessWidget {
  final Exam exam;

  const ExamQuestionsScreen({
    super.key,
    required this.exam,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: exam.title),
      body: BlocConsumer<ExamCubit, ExamState>(
        listener: _handleStateChanges,
        builder: _buildBody,
      ),
    );
  }

  void _handleStateChanges(BuildContext context, ExamState state) {
    if (state is ExamSubmissionSuccess) {
      Navigator.of(context).pop();
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

// ===== EXAM IN PROGRESS WIDGET =====
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
            _QuestionProgressIndicator(
              currentIndex: state.currentQuestionIndex,
              totalQuestions: exam.questions.length,
            ),
            SizedBox(height: 3.h),
            _QuestionCard(question: currentQuestion),
            SizedBox(height: 4.h),
            Expanded(
              child: _OptionsListView(
                question: currentQuestion,
                selectedOptionIndex: selectedOptionIndex,
              ),
            ),
            SizedBox(height: 3.h),
            _NavigationButton(
              isLastQuestion:
                  state.currentQuestionIndex == exam.questions.length - 1,
              isAnswerSelected: selectedOptionIndex != null,
              onPressed: selectedOptionIndex != null
                  ? () => _handleButtonPress(context, state)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  void _handleButtonPress(BuildContext context, ExamInProgress state) {
    final cubit = context.read<ExamCubit>();

    if (state.currentQuestionIndex == exam.questions.length - 1) {
      cubit.submitAnswers();
    } else {
      cubit.nextQuestion();
    }
  }
}

// ===== QUESTION PROGRESS INDICATOR =====
class _QuestionProgressIndicator extends StatelessWidget {
  final int currentIndex;
  final int totalQuestions;

  const _QuestionProgressIndicator({
    required this.currentIndex,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (currentIndex + 1) / totalQuestions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Question ${currentIndex + 1} of $totalQuestions',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey.shade700,
              ),
            ),
            Text(
              '${(progress * 100).round()}%',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.blue.shade600,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey.shade200,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
          minHeight: 0.8.h,
        ),
      ],
    );
  }
}

// ===== QUESTION CARD =====
class _QuestionCard extends StatelessWidget {
  final Question question;

  const _QuestionCard({required this.question});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        question.questionText,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: Colors.deepPurple.shade800,
          height: 1.4,
        ),
      ),
    );
  }
}

// ===== OPTIONS LIST VIEW =====
class _OptionsListView extends StatelessWidget {
  final Question question;
  final int? selectedOptionIndex;

  const _OptionsListView({
    required this.question,
    required this.selectedOptionIndex,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: question.options.length,
      separatorBuilder: (context, index) => SizedBox(height: 1.5.h),
      itemBuilder: (context, index) {
        return _OptionTile(
          option: question.options[index],
          optionIndex: index,
          isSelected: selectedOptionIndex == index,
          onTap: () => _selectOption(context, index),
        );
      },
    );
  }

  void _selectOption(BuildContext context, int optionIndex) {
    context.read<ExamCubit>().selectAnswer(question.id, optionIndex);
  }
}

// ===== OPTION TILE =====
class _OptionTile extends StatelessWidget {
  final String option;
  final int optionIndex;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionTile({
    required this.option,
    required this.optionIndex,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final optionLetter = String.fromCharCode(65 + optionIndex); // A, B, C, D

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue.shade50 : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.blue.shade400 : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              _OptionIndicator(
                letter: optionLetter,
                isSelected: isSelected,
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  option,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.blue.shade800 : Colors.black87,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: Colors.blue.shade600,
                  size: 20.sp,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionIndicator extends StatelessWidget {
  final String letter;
  final bool isSelected;

  const _OptionIndicator({
    required this.letter,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 10.w,
      height: 10.w,
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.shade600 : Colors.grey.shade200,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          letter,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade600,
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }
}

// ===== NAVIGATION BUTTON =====
class _NavigationButton extends StatelessWidget {
  final bool isLastQuestion;
  final bool isAnswerSelected;
  final VoidCallback? onPressed;

  const _NavigationButton({
    required this.isLastQuestion,
    required this.isAnswerSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(
            isLastQuestion ? Icons.send_rounded : Icons.arrow_forward_rounded,
            color: Colors.white,
            size: 18.sp,
          ),
          label: Text(
            isLastQuestion ? 'Submit Exam' : 'Next Question',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: isAnswerSelected
                ? (isLastQuestion
                    ? Colors.green.shade600
                    : Colors.blue.shade600)
                : Colors.grey.shade400,
            padding: EdgeInsets.symmetric(
              horizontal: 8.w,
              vertical: 2.h,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: isAnswerSelected ? 4 : 0,
            shadowColor: isAnswerSelected
                ? (isLastQuestion
                    ? Colors.green.shade200
                    : Colors.blue.shade200)
                : Colors.transparent,
          ),
        ),
      ),
    );
  }
}

// ===== EXAM SUBMITTING WIDGET =====
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
            'Submitting your answers...',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: Colors.blueGrey.shade600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Please wait while we process your exam',
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

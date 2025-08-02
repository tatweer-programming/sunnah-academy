import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      appBar: AppBar(
        title: Text(exam.title),
      ),
      body: BlocConsumer<ExamCubit, ExamState>(
        listener: (context, state) {
          if (state is ExamSubmissionSuccess) {
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          if (state is ExamInProgress) {
            final Question currentQuestion =
                exam.questions[state.currentQuestionIndex];
            final int? selectedOptionIndex =
                state.selectedAnswers[currentQuestion.id];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Question ${state.currentQuestionIndex + 1} of ${exam.questions.length}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueGrey.shade700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        currentQuestion.questionText,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: ListView.builder(
                      itemCount: currentQuestion.options.length,
                      itemBuilder: (context, index) {
                        return RadioListTile<int>(
                          title: Text(
                            currentQuestion.options[index],
                            style: const TextStyle(fontSize: 18),
                          ),
                          value: index,
                          groupValue: selectedOptionIndex,
                          onChanged: (int? value) {
                            if (value != null) {
                              context
                                  .read<ExamCubit>()
                                  .selectAnswer(currentQuestion.id, value);
                            }
                          },
                          activeColor: Colors.blueAccent,
                          controlAffinity: ListTileControlAffinity.leading,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton.icon(
                      onPressed: selectedOptionIndex != null
                          ? () {
                              if (state.currentQuestionIndex ==
                                  exam.questions.length - 1) {
                                // Last question, submit answers
                                context.read<ExamCubit>().submitAnswers();
                              } else {
                                // Move to next question
                                context.read<ExamCubit>().nextQuestion();
                              }
                            }
                          : null, // Disable button if no option is selected
                      icon: Icon(
                        state.currentQuestionIndex == exam.questions.length - 1
                            ? Icons.send
                            : Icons.arrow_forward,
                        color: Colors.white,
                      ),
                      label: Text(
                        state.currentQuestionIndex == exam.questions.length - 1
                            ? 'Submit Exam'
                            : 'Next Question',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedOptionIndex != null
                            ? Colors.blueAccent
                            : Colors.grey,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 8,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is ExamSubmitting) {
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                ),
                SizedBox(height: 20),
                Text(
                  'Submitting your answers...',
                  style: TextStyle(fontSize: 18, color: Colors.blueGrey),
                ),
              ],
            );
          }
          // This case should ideally not be reached if navigation is handled correctly
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

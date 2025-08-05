import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sunnah_academy/src/core/routing/navigation_manager.dart';

import '../../cubit/exam_cubit.dart';
import '../../data/models/exam.dart';
import '../screens/exam_questions_screen.dart';

class ExamDetailsWidget extends StatelessWidget {
  final Exam exam;

  const ExamDetailsWidget({
    super.key,
    required this.exam,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    exam.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Divider(height: 30, thickness: 2, color: Colors.blueGrey),
                  const SizedBox(height: 10),
                  Text(
                    exam.description,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  _buildDetailRow(
                    icon: Icons.score,
                    label: 'Total Marks:',
                    value: '${exam.totalMarks}',
                  ),
                  _buildDetailRow(
                    icon: Icons.timer,
                    label: 'Time Limit:',
                    value: '${exam.timeLimit} minutes',
                  ),
                  _buildDetailRow(
                    icon: Icons.question_answer,
                    label: 'Questions Count:',
                    value: '${exam.questionsCount}',
                  ),
                  _buildDetailRow(
                    icon: Icons.check_circle_outline,
                    label: 'Attempted:',
                    value: exam.isAttempted ? 'Yes' : 'No',
                    valueColor: exam.isAttempted ? Colors.green : Colors.red,
                  ),
                  if (exam.isAttempted)
                    _buildDetailRow(
                      icon: Icons.emoji_events,
                      label: 'Last Score:',
                      value: '${exam.lastScore}',
                      valueColor: Colors.purple,
                    ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.read<ExamCubit>().startExam(exam);
                        context.push(ExamQuestionsScreen(exam: exam,));
                      },
                      icon: const Icon(Icons.play_arrow, color: Colors.white, size: 30),
                      label: const Text(
                        'Start Exam',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // A vibrant green for start
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 10,
                        shadowColor: Colors.green.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Helper method to build a consistent detail row.
  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blueAccent, size: 24),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.blueGrey,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: valueColor ?? Colors.black87,
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
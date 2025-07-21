// lib/src/modules/subjects/presentation/widgets/completion_button.dart
import 'package:flutter/material.dart';
import 'package:sunnah_academy/src/modules/subjects/data/models/lecture.dart';

class CompletionButton extends StatelessWidget {
  final Lecture lecture;
  final VoidCallback? onComplete;
  final bool isLoading;

  const CompletionButton({
    super.key,
    required this.lecture,
    this.onComplete,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (lecture.completionCondition == null || lecture.isComplete) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onComplete,
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            : const Text('تحديد كمكتملة'),
      ),
    );
  }
}

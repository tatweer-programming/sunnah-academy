import 'completion_condition.dart' show CompletionCondition;

final class ExamCondition extends CompletionCondition {
  final String examId;

  ExamCondition({required this.examId}) : super(type: 'exam');

  factory ExamCondition.fromJson(Map<String, dynamic> json) {
    return ExamCondition(examId: json['examId']);
  }

  static void register() {
    CompletionCondition.register('exam', ExamCondition.fromJson);
  }
}

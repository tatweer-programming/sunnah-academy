import 'completion_condition.dart' show CompletionCondition;

final class ExamCondition extends CompletionCondition {
  final String examId;
  final ExamConditionDetail? examConditionType;

  ExamCondition({required this.examId, this.examConditionType})
      : super(type: 'exam');

  factory ExamCondition.fromJson(Map<String, dynamic> json) {
    return ExamCondition(
      examId: json['examId'],
    );
  }

  static void register() {
    CompletionCondition.register('exam', ExamCondition.fromJson);
  }
}

enum ExamConditionType { lecture, subject }

class ExamConditionDetail {
  final String value;
  final ExamConditionType type;

  ExamConditionDetail({required this.value, required this.type});
}

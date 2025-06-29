import 'package:sunnah_academy/src/modules/subjects/data/completion_condition/completion_condition.dart';

final class ExamCondition extends CompletionCondition {
  final String examId;

  const ExamCondition({required this.examId, required super.type});
}

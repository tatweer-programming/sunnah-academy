import 'package:sunnah_academy/src/modules/subjects/data/completion_condition/exam_condition.dart';

abstract class CompletionCondition {
  final String type;

  const CompletionCondition({required this.type});

  static final Map<String, CompletionCondition Function(Map<String, dynamic>)>
      _registry = {
    'exam': (json) => ExamCondition.fromJson(json),
  };

  static void register<T extends CompletionCondition>(
      String type, CompletionCondition Function(Map<String, dynamic>) factory) {
    _registry[type] = factory;
  }

  static CompletionCondition fromJson(Map<String, dynamic> json) {
    final type = json['type'];
    final factory = _registry[type];
    if (factory != null) {
      return factory(json);
    }
    throw UnsupportedError('Unknown CompletionCondition type: $type');
  }
}

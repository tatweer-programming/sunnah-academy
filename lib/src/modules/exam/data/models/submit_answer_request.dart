import 'package:equatable/equatable.dart';

import 'answer.dart';

class SubmitAnswersRequest extends Equatable {
  final List<Answer> answers;
  final String examId;

  const SubmitAnswersRequest({
    required this.answers,
    required this.examId,
  });

  Map<String, dynamic> toJson() {
    return {
      'answers': answers.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object> get props => [answers];
}

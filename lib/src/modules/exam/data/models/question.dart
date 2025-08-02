import 'package:equatable/equatable.dart';

class Question extends Equatable {
  final String id;
  final String questionText;
  final List<String> options;

  const Question({
    required this.id,
    required this.questionText,
    required this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      questionText: json['questionText'] as String,
      options: List<String>.from(json['options'] as List<dynamic>),
    );
  }

  Question copyWith({
    String? id,
    String? questionText,
    List<String>? options,
  }) {
    return Question(
      id: id ?? this.id,
      questionText: questionText ?? this.questionText,
      options: options ?? this.options,
    );
  }

  @override
  List<Object> get props => [id, questionText, options];
}

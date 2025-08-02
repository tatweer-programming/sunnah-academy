import 'package:equatable/equatable.dart';
import 'package:sunnah_academy/src/modules/exam/data/models/question.dart';

class Exam extends Equatable {
  final String id;
  final String title;
  final String description;
  final int totalMarks;
  final int timeLimit;
  final int questionsCount;
  final bool isAttempted;
  final int? lastScore;
  final List<Question> questions;

  const Exam({
    required this.id,
    required this.title,
    required this.description,
    required this.totalMarks,
    required this.timeLimit,
    required this.questionsCount,
    required this.isAttempted,
    required this.lastScore,
    required this.questions,
  });

  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      totalMarks: json['totalMarks'] as int,
      timeLimit: json['timeLimit'] as int,
      questionsCount: json['questionsCount'] as int,
      isAttempted: json['isAttempted'] as bool,
      lastScore: json['lastScore'] ?? 0,
      questions: (json['questions'] as List<dynamic>)
          .map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
  Exam copyWith({
    String? id,
    String? title,
    String? description,
    int? totalMarks,
    int? timeLimit,
    int? questionsCount,
    bool? isAttempted,
    int? lastScore,
    List<Question>? questions,
  }) {
    return Exam(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      totalMarks: totalMarks ?? this.totalMarks,
      timeLimit: timeLimit ?? this.timeLimit,
      questionsCount: questionsCount ?? this.questionsCount,
      isAttempted: isAttempted ?? this.isAttempted,
      lastScore: lastScore ?? this.lastScore,
      questions: questions ?? this.questions,
    );
  }

  @override
  List<Object> get props => [
    id,
    title,
    description,
    totalMarks,
    timeLimit,
    questionsCount,
    isAttempted,
    questions,
  ];
}

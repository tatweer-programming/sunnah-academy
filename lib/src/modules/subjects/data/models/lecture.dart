import 'package:equatable/equatable.dart';
import 'package:sunnah_academy/src/modules/subjects/data/models/completion_condition/completion_condition.dart';

class Lecture extends Equatable {
  final String id;
  final String name;
  final String url;
  final String contentType;
  final CompletionCondition? completionCondition;
  final bool isComplete;
  const Lecture(
      {required this.id,
      required this.name,
      required this.url,
      required this.contentType,
      this.completionCondition,
      this.isComplete = false});
  factory Lecture.fromJson(Map<String, dynamic> json) {
    return Lecture(
      id: json['id'],
      name: json['name'],
      url: json['contentUrl'],
      contentType: json['contentType'],
      completionCondition: json["completionCondition"] != null
          ? CompletionCondition.fromJson(json['completionCondition'])
          : null,
      isComplete: json['isCompleted'] ?? false,
    );
  }

  @override
  List<Object?> get props => [id, name, url, contentType];
}

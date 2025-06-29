import 'package:equatable/equatable.dart';
import 'package:sunnah_academy/src/modules/subjects/data/completion_condition/completion_condition.dart';

class Lecture extends Equatable {
  final String id;
  final String title;
  final String url;
  final String contentType;
  final CompletionCondition completionCondition;
  bool isComplete;
  Lecture(
      {required this.id,
      required this.title,
      required this.url,
      required this.contentType,
      required this.completionCondition,
      this.isComplete = false});
  factory Lecture.fromJson(Map<String, dynamic> json) {
    return Lecture(
      id: json['id'],
      title: json['title'],
      url: json['url'],
      contentType: json['contentType'],
      completionCondition: json['completionCondition'],
    );
  }
  void markAsCompleted() {
    isComplete = true;
  }

  @override
  List<Object?> get props => [id, title, url, contentType];
}

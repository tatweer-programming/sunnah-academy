import 'package:equatable/equatable.dart';
import 'package:sunnah_academy/src/modules/subjects/data/lecture.dart';

import 'completion_condition/completion_condition.dart';

class Subject extends Equatable {
  final String name;
  final String description;
  final String imageUrl;
  int progress;
  List<Lecture> lectures = [];
  final CompletionCondition completionCondition;

  Subject({
    required this.name,
    required this.description,
    required this.imageUrl,
    this.progress = 0,
    required this.completionCondition,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      progress: json['progress'],
      completionCondition:
          CompletionCondition.fromJson(json['completionCondition']),
    );
  }

  void updateProgress(int newProgress) {
    progress = newProgress;
  }

  void setLectures(List<Lecture> lectures) {
    this.lectures = lectures;
  }

  @override
  List<Object?> get props => [name, description, imageUrl, progress];
}

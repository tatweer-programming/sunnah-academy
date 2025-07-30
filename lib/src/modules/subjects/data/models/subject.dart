import 'package:equatable/equatable.dart';
import 'package:sunnah_academy/src/modules/subjects/data/models/completion_condition/completion_condition.dart';
import 'package:sunnah_academy/src/modules/subjects/data/models/lecture.dart';

class Subject extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final int progress;
  final String? bookUrl;
  final bool isCompleted;
  final List<Lecture> lectures;
  final CompletionCondition completionCondition;

  const Subject({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    this.progress = 0,
    required this.completionCondition,
    this.bookUrl,
    this.isCompleted = false,
    this.lectures = const [],
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      progress: json['progress'],
      completionCondition:
          CompletionCondition.fromJson(json['completionCondition']),
      id: json['id'] ?? '',
      bookUrl: json["bookUrl"],
      isCompleted: json['isCompleted'] ?? false,
      lectures: (json['lectures'] as List<dynamic>?)
              ?.map((lecture) =>
                  Lecture.fromJson(lecture as Map<String, dynamic>))
              .toList() ??
          const <Lecture>[],
    );
  }

  Subject copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    int? progress,
    String? bookUrl,
    bool? isCompleted,
    List<Lecture>? lectures,
    CompletionCondition? completionCondition,
  }) {
    return Subject(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      progress: progress ?? this.progress,
      bookUrl: bookUrl ?? this.bookUrl,
      isCompleted: isCompleted ?? this.isCompleted,
      lectures: lectures ?? this.lectures,
      completionCondition: completionCondition ?? this.completionCondition,
    );
  }

  double get progressPercentage {
    return progress / 100.0;
  }

  @override
  List<Object?> get props => [name, description, imageUrl, progress];
}

import 'package:equatable/equatable.dart';

class Answer extends Equatable {
  final String questionId;
  final int selectedOptionIndex;

  const Answer({
    required this.questionId,
    required this.selectedOptionIndex,
  });


  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'selectedOptionIndex': selectedOptionIndex,
    };
  }

  Answer copyWith({
    String? questionId,
    int? selectedOptionIndex,
  }) {
    return Answer(
      questionId: questionId ?? this.questionId,
      selectedOptionIndex: selectedOptionIndex ?? this.selectedOptionIndex,
    );
  }

  @override
  List<Object> get props => [questionId, selectedOptionIndex];
}
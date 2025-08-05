import 'package:dartz/dartz.dart';
import 'package:sunnah_academy/src/modules/exam/data/models/exam.dart';

import '../models/submit_answer_request.dart';
import '../services/exam_remote_services.dart';

class ExamRepository {
  final ExamRemoteServices remoteServices;

  const ExamRepository({required this.remoteServices});

  Future<Either<Exception, Exam>> getExam(String id) async {
    return await remoteServices.getExamDetails(id);
  }

  Future<Either<Exception, String>> submitExamAnswers(
      SubmitAnswersRequest request) async {
    return await remoteServices.submitAnswers(request);
  }
}

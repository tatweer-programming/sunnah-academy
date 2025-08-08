import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sunnah_academy/src/modules/exam/data/models/exam.dart';

import '../models/submit_answer_request.dart';
import '../services/exam_services.dart';

class ExamRepository {
  final BaseExamServices _remoteServices;

  const ExamRepository(this._remoteServices);

  Future<Either<DioException, Exam>> getExam(String id) async {
    return await _remoteServices.getExamDetails(id);
  }

  Future<Either<DioException, String>> submitExamAnswers(
      SubmitAnswersRequest request) async {
    return await _remoteServices.submitAnswers(request);
  }
}

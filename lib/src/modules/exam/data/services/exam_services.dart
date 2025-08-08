import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sunnah_academy/src/modules/exam/data/models/exam.dart';

import '../../../../core/apis/dio_helper.dart';
import '../../../../core/apis/end_points.dart';
import '../models/submit_answer_request.dart';

abstract class BaseExamServices {
  Future<Either<DioException, Exam>> getExamDetails(String id);
  Future<Either<DioException, String>> submitAnswers(SubmitAnswersRequest request);
}

class ExamRemoteServices implements BaseExamServices {
  @override
  Future<Either<DioException, Exam>> getExamDetails(String id) async {
    try {
      final response = await DioHelper.getData(path: EndPoints.getExams + id);
      final data = response.data['data'];
      final Exam exam = Exam.fromJson(data);
      return Right(exam);
    } on DioException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<DioException, String>> submitAnswers(
      SubmitAnswersRequest request) async {
    try {
      final response = await DioHelper.postData(
          path: EndPoints.getExams + request.examId + EndPoints.submitExam, data: request.toJson());
      final String result = response.data['message'];
      return Right(result);
    } on DioException catch (e) {
      return Left(e);
    }
  }
}

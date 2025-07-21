import 'package:dartz/dartz.dart';
import 'package:sunnah_academy/src/core/apis/dio_helper.dart';
import 'package:sunnah_academy/src/core/apis/end_points.dart';
import 'package:sunnah_academy/src/modules/subjects/data/models/subject.dart';

abstract class BaseSubjectServices {
  Future<Either<Exception, List<Subject>>> getSubjects();

  Future<Either<Exception, Unit>> completeLecture({required int lectureId});
}

class SubjectServices implements BaseSubjectServices {
  @override
  Future<Either<Exception, List<Subject>>> getSubjects() async {
    try {
      final response = await DioHelper.getData(path: EndPoints.subjects);

      final List<dynamic> data = response.data['data'];
      final List<Subject> subjects =
          data.map((json) => Subject.fromJson(json)).toList();
      return Right(subjects);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, Unit>> completeLecture(
      {required int lectureId}) async {
    try {
      await DioHelper.postData(
        path: '${EndPoints.students}/lectures/$lectureId/complete',
      );
      return Right(unit);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:sunnah_academy/src/core/routing/navigation_manager.dart';
import 'package:sunnah_academy/src/modules/exam/cubit/exam_cubit.dart';
import 'package:sunnah_academy/src/modules/subjects/cubit/subjects_cubit.dart';
import 'package:sunnah_academy/src/modules/subjects/ui/screens/pdf_lecture_screen.dart';
import 'package:sunnah_academy/src/modules/subjects/ui/screens/video_lecture_screen.dart';

import '../../data/models/lecture.dart';
import 'audio_lecture_screen.dart';

class LectureDetailScreen extends StatelessWidget {
  final Lecture lecture;

  const LectureDetailScreen({super.key, required this.lecture});

  Widget _buildContentArea(BuildContext context) {
    switch (lecture.contentType.toLowerCase()) {
      case 'video':
        return VideoLectureScreen(
          lecture: lecture,
        );
      case 'audio':
        return AudioLectureScreen(
          lecture: lecture,
        );
      case 'pdf':
        return PdfLectureScreen(
          lecture: lecture,
        );
      default:
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Center(
            child: Text(
              'Unsupported content type: ${lecture.contentType}\nURL: ${lecture.url}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lecture.name),
        // showBack: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocListener<ExamCubit, ExamState>(
              listener: (context, state) {
                // TODO: Handle exam success state
                // call markLectureAsCompleted ya shafra
              },
              child: BlocListener<SubjectsCubit, SubjectsState>(
                listener: (context, state) {
                  if (state is CompleteLectureSuccess) {
                    context.pop();
                  }
                },
                child: _buildContentArea(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:sunnah_academy/src/core/routing/navigation_manager.dart';
import 'package:sunnah_academy/src/core/widgets/custom_app_bar.dart';
import 'package:sunnah_academy/src/modules/exam/ui/screens/exam_screen.dart';
import 'package:sunnah_academy/src/modules/subjects/ui/screens/pdf_lecture_screen.dart';
import 'package:sunnah_academy/src/modules/subjects/ui/screens/video_lecture_screen.dart';

import '../../data/models/completion_condition/completion_condition.dart';
import '../../data/models/completion_condition/exam_condition.dart';
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
      appBar: CustomAppBar(
        title: lecture.name,
        showBack: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildContentArea(context),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (lecture.completionCondition != null) ...[
                    SizedBox(height: 1.5.h),
                    _buildDetailRow(
                      context,
                      icon: Icons.rule_sharp,
                      label: 'لإنهاء المحاضرة:',
                      value: lecture.completionCondition! as ExamCondition,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context,
      {required IconData icon,
      required String label,
      required ExamCondition value,
      Color? valueColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 22.sp, color: Theme.of(context).primaryColorDark),
        SizedBox(width: 2.w),
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontSize: 18.sp),
        ),
        SizedBox(width: 1.w),
        Expanded(
          child: TextButton(
            onPressed: () {
              context.push(
                ExamScreen(examId: value.examId,)
              );
            },
            child: Text(
              value.type,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: valueColor ??
                        Theme.of(context).textTheme.bodyMedium?.color,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}


import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:sunnah_academy/src/core/routing/navigation_manager.dart';
import 'package:sunnah_academy/src/modules/subjects/data/models/lecture.dart';
import 'package:sunnah_academy/src/modules/subjects/ui/screens/lecture_details_screen.dart';

class LectureTile extends StatelessWidget {
  final Lecture lecture;
  final int lectureNumber;

  const LectureTile(
      {super.key, required this.lecture, required this.lectureNumber});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.8.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColorLight,
          child: Text(
            lectureNumber.toString(),
            style: TextStyle(
                color: Theme.of(context).primaryColorDark,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold),
          ),
        ),
        title:
        Text(lecture.name, style: Theme.of(context).textTheme.titleMedium),
        trailing: lecture.isComplete
            ? Icon(Icons.check_circle_outline, color: Colors.green, size: 18.sp)
            : Icon(Icons.radio_button_unchecked,
            color: Colors.grey, size: 18.sp),
        onTap: () {
          context.push(LectureDetailScreen(lecture: lecture));
        },
      ),
    );
  }
}

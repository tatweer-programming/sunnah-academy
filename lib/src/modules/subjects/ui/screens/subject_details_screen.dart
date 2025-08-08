import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sunnah_academy/src/core/routing/navigation_manager.dart';

import '../../data/models/lecture.dart';
import '../../data/models/subject.dart';
import 'lecture_details_screen.dart';

class SubjectDetailScreen extends StatelessWidget {
  final Subject subject;

  const SubjectDetailScreen({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 30.h, // Responsive height
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                subject.name,
                style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              background: Hero(
                tag: 'subjectImage_${subject.id}', // Unique tag
                child: CachedNetworkImage(
                  imageUrl: subject.imageUrl,
                  fit: BoxFit.cover,
                  color: Colors.black.withOpacity(0.3),
                  colorBlendMode: BlendMode.darken,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[400],
                    child: Center(
                        child: Icon(Icons.image,
                            size: 30.sp, color: Colors.grey[600])),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[400],
                    child: Center(
                        child: Icon(Icons.broken_image,
                            size: 30.sp, color: Colors.red[400])),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('', style: Theme.of(context).textTheme.headlineSmall),
                  SizedBox(height: 1.h),
                  Text(subject.description,
                      style: Theme.of(context).textTheme.bodyMedium),
                  SizedBox(height: 2.h),
                  _buildInfoRow(
                      context,
                      Icons.bar_chart,
                      'التقدم: ${subject.progress}%',
                      subject.isCompleted ? ' (تم)' : 'لم يتم'),
                  SizedBox(height: 1.h),
                  // _buildInfoRow(context, Icons.rule_sharp, 'الأمتحانات:',
                  //     subject.completionCondition.type),
                  if (subject.bookUrl != null &&
                      subject.bookUrl!.isNotEmpty) ...[
                    SizedBox(height: 1.h),
                    _buildInfoRow(
                      context,
                      Icons.menu_book,
                      'مراجع:',
                      subject.bookUrl!,
                      isLink: true,
                      onTap: () {
                        // await canLaunchUrl(Uri.parse(subject.bookUrl!))
                        //     ? await launchUrl(Uri.parse(subject.bookUrl!))
                        //     : throw 'Could not launch ${subject.bookUrl}';
                      },
                    ),
                  ],
                  SizedBox(height: 3.h),
                  Text('المحاضرات (${subject.lectures.length})',
                      style: Theme.of(context).textTheme.headlineSmall),
                ],
              ),
            ),
          ),
          subject.lectures.isEmpty
              ? SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: Center(
                      child: Text('لا يوجد محاضرات ',
                          style: Theme.of(context).textTheme.bodyMedium),
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final lecture = subject.lectures[index];
                      return LectureTile(
                          lecture: lecture, lectureNumber: index + 1);
                    },
                    childCount: subject.lectures.length,
                  ),
                ),
          SliverPadding(
              padding: EdgeInsets.only(bottom: 4.h)), // Add some bottom padding
        ],
      ),
    );
  }

  Widget _buildInfoRow(
      BuildContext context, IconData icon, String title, String value,
      {bool isLink = false, VoidCallback? onTap}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 20.sp, color: Theme.of(context).primaryColor),
        SizedBox(width: 2.w),
        Text('$title ', style: Theme.of(context).textTheme.titleMedium),
        Expanded(
          child: GestureDetector(
            onTap: isLink ? onTap : null,
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isLink
                        ? Colors.blueAccent
                        : Theme.of(context).textTheme.bodyMedium?.color,
                    decoration: isLink ? TextDecoration.underline : null,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}

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

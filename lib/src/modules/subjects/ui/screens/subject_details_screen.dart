import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../data/models/lecture.dart';
import '../../data/models/subject.dart';

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
                // Optional: for a nice transition if you use Hero animations
                tag: 'subjectImage_${subject.id}', // Unique tag
                child: CachedNetworkImage(
                  imageUrl: subject.imageUrl,
                  fit: BoxFit.cover,
                  color: Colors.black.withOpacity(
                      0.3), // Darken image slightly for text visibility
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
                  Text('Description',
                      style: Theme.of(context).textTheme.headlineSmall),
                  SizedBox(height: 1.h),
                  Text(subject.description,
                      style: Theme.of(context).textTheme.bodyMedium),
                  SizedBox(height: 2.h),
                  _buildInfoRow(
                      context,
                      Icons.bar_chart,
                      'Progress: ${subject.progress}%',
                      subject.isCompleted ? ' (Completed)' : ''),
                  SizedBox(height: 1.h),
                  _buildInfoRow(context, Icons.rule_sharp, 'Completion:',
                      subject.completionCondition.type??""),
                  if (subject.bookUrl != null &&
                      subject.bookUrl!.isNotEmpty) ...[
                    SizedBox(height: 1.h),
                    _buildInfoRow(
                      context,
                      Icons.menu_book,
                      'Reference Book:',
                      subject.bookUrl!,
                      isLink: true,
                      onTap: () {
                        // Implement opening the book URL (e.g., using url_launcher package)
                        print('Open book URL: ${subject.bookUrl}');
                        // await canLaunchUrl(Uri.parse(subject.bookUrl!))
                        //     ? await launchUrl(Uri.parse(subject.bookUrl!))
                        //     : throw 'Could not launch ${subject.bookUrl}';
                      },
                    ),
                  ],
                  SizedBox(height: 3.h),
                  Text('Lectures (${subject.lectures.length})',
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
                      child: Text('No lectures available for this subject.',
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16.sp, color: Theme.of(context).primaryColor),
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
          // Handle lecture tap - e.g., navigate to a video player screen
          print('Tapped lecture: ${lecture.name}, URL: ${lecture.url}');
          // Navigator.push(context, MaterialPageRoute(builder: (context) => VideoPlayerScreen(lecture: lecture)));
        },
      ),
    );
  }
}

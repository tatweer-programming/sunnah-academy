import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:sunnah_academy/src/core/routing/navigation_manager.dart';
import 'package:sunnah_academy/src/modules/subjects/cubit/subjects_cubit.dart'
    show
        SubjectsState,
        SubjectsCubit,
        CompleteLectureSuccess,
        GetSubjectByIdSuccess;
import 'package:sunnah_academy/src/modules/subjects/ui/widgets/lecture_tile.dart';

import '../../../../core/widgets/core_widgets.dart';
import '../../data/models/subject.dart';
import '../widgets/pdf_viewer.dart';

class SubjectDetailScreen extends StatefulWidget {
  final String subjectId;

  const SubjectDetailScreen({super.key, required this.subjectId});

  @override
  State<SubjectDetailScreen> createState() => _SubjectDetailScreenState();
}

class _SubjectDetailScreenState extends State<SubjectDetailScreen> {
  late Subject subject;
  late SubjectsCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<SubjectsCubit>();
    subject = cubit.getSubjectById(subjectId: widget.subjectId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          BlocListener<SubjectsCubit, SubjectsState>(
            listener: (context, state) {
              if (state is CompleteLectureSuccess) {
                // Refresh the subject data after lecture completion
                cubit.refreshSubjectById(subjectId: widget.subjectId);
              }
            },
            child: BlocBuilder<SubjectsCubit, SubjectsState>(
              buildWhen: (previous, current) {
                return current is GetSubjectByIdSuccess ||
                    current is CompleteLectureSuccess;
              },
              builder: (context, state) {
                if (state is GetSubjectByIdSuccess) {
                  subject = state.subject;
                } else if (state is CompleteLectureSuccess) {
                  // Get updated subject after lecture completion
                  subject = cubit.getSubjectById(subjectId: widget.subjectId);
                }

                return SliverAppBar(
                  leading: backButton(context),
                  expandedHeight: 30.h,
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
                      tag: subject.id,
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
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: BlocBuilder<SubjectsCubit, SubjectsState>(
              buildWhen: (previous, current) {
                return current is GetSubjectByIdSuccess ||
                    current is CompleteLectureSuccess;
              },
              builder: (context, state) {
                if (state is GetSubjectByIdSuccess) {
                  subject = state.subject;
                } else if (state is CompleteLectureSuccess) {
                  subject = cubit.getSubjectById(subjectId: widget.subjectId);
                }

                return Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(subject.description,
                          style: Theme.of(context).textTheme.bodyMedium),
                      SizedBox(height: 2.h),
                      _buildInfoRow(context,
                          icon: Icons.bar_chart,
                          title: 'التقدم:  ${subject.progress}%',
                          value: Text("")),
                      SizedBox(height: 1.h),
                      if (subject.bookUrl != null &&
                          subject.bookUrl!.isNotEmpty) ...[
                        SizedBox(height: 1.h),
                        if (subject.bookUrl != null)
                          InkWell(
                            child: _buildInfoRow(
                              context,
                              icon: Icons.menu_book,
                              title: 'مراجع:',
                              value: TextButton(
                                onPressed: () {
                                  context.push(PdfViewerScreen(
                                      pdfUrl: subject.bookUrl!));
                                },
                                child: Text("عرض الكتاب"),
                              ),
                            ),
                          ),
                      ],
                      SizedBox(height: 3.h),
                      Text('المحاضرات (${subject.lectures.length})',
                          style: Theme.of(context).textTheme.headlineSmall),
                    ],
                  ),
                );
              },
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
              : BlocBuilder<SubjectsCubit, SubjectsState>(
                  buildWhen: (previous, current) {
                    return current is GetSubjectByIdSuccess ||
                        current is CompleteLectureSuccess;
                  },
                  builder: (context, state) {
                    if (state is GetSubjectByIdSuccess) {
                      subject = state.subject;
                    } else if (state is CompleteLectureSuccess) {
                      subject =
                          cubit.getSubjectById(subjectId: widget.subjectId);
                    }

                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final lecture = subject.lectures[index];
                          return LectureTile(
                              lecture: lecture, lectureNumber: index + 1);
                        },
                        childCount: subject.lectures.length,
                      ),
                    );
                  },
                ),
          SliverPadding(padding: EdgeInsets.only(bottom: 4.h)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Icon(icon, size: 22.sp, color: Theme.of(context).primaryColor),
            SizedBox(width: 2.w),
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontSize: 18.sp),
            ),
          ],
        ),
        value,
      ],
    );
  }
}

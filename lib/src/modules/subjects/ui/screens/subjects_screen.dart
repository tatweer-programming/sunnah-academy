import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sunnah_academy/src/modules/subjects/ui/screens/subject_details_screen.dart';
import '../../cubit/subjects_cubit.dart';
import '../../data/models/subject.dart';

class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({super.key});

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  final List<Subject> subjects = [];
  @override
  initState() {
    context.read<SubjectsCubit>().getSubjects();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Subjects',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: BlocBuilder<SubjectsCubit, SubjectsState>(
        builder: (context, state) {
          if (state is GetSubjectsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetSubjectsSuccess) {
            subjects.addAll(state.subjects);
            return _buildSubjectsList(context);
          } else if (state is GetSubjectsError) {
            return Center(child: Text(state.exception.toString()));
          }
          return const Center(child: Text('Something went wrong'));
        },
      ),
    );
  }

  Widget _buildSubjectsList(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<SubjectsCubit>().getSubjects(),
      child: subjects.isEmpty
          ? Center(
              child: Text('No subjects available.',
                  style: Theme.of(context).textTheme.bodyMedium))
          : ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                final subject = subjects[index];
                return SubjectCard(subject: subject);
              },
            ),
    );
  }
}

class SubjectCard extends StatelessWidget {
  final Subject subject;

  const SubjectCard({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 2.h),
      child: InkWell(
        borderRadius: BorderRadius.circular(15.0), // Match card's shape
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubjectDetailScreen(subject: subject),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(3.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: CachedNetworkImage(
                      imageUrl: subject.imageUrl,
                      width: 25.w, // Responsive width
                      height: 12.h, // Responsive height
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 25.w,
                        height: 12.h,
                        color: Colors.grey[300],
                        child: Center(
                            child: Icon(Icons.image,
                                size: 20.sp, color: Colors.grey[500])),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 25.w,
                        height: 12.h,
                        color: Colors.grey[300],
                        child: Center(
                            child: Icon(Icons.broken_image,
                                size: 20.sp, color: Colors.red[400])),
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subject.name,
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          subject.description,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.grey[700]),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.5.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    // Wrap ProgressBar with Expanded
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Progress: ${subject.progress}%',
                            style: Theme.of(context).textTheme.labelSmall),
                        SizedBox(height: 0.5.h),
                        LinearProgressIndicator(
                          value: subject.progress / 100.0,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                              subject.isCompleted
                                  ? Colors.green
                                  : Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                  ),
                  if (subject.isCompleted)
                    Padding(
                      padding: EdgeInsets.only(left: 2.w),
                      child: Icon(Icons.check_circle,
                          color: Colors.green, size: 18.sp),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

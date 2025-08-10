import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sunnah_academy/src/core/routing/navigation_manager.dart';
import 'package:sunnah_academy/src/core/utils/assets_manager.dart';
import 'package:sunnah_academy/src/core/widgets/custom_app_bar.dart';
import 'package:sunnah_academy/src/modules/subjects/ui/screens/subject_details_screen.dart';
import '../../cubit/subjects_cubit.dart';
import '../../data/models/subject.dart';

class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({super.key});

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  late SubjectsCubit subjectsCubit = context.read<SubjectsCubit>();
  @override
  void initState() {
    super.initState();
    subjectsCubit.getSubjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "المواد الدراسية"),
      body: BlocBuilder<SubjectsCubit, SubjectsState>(
        builder: (context, state) {
          if (state is GetSubjectsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetSubjectsSuccess ||
              subjectsCubit.subjects.isNotEmpty) {
            return _buildSubjectsGrid(subjectsCubit.subjects);
          } else if (state is GetSubjectsError) {
            return Center(child: Text(state.exception.toString()));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSubjectsGrid(List<Subject> subjects) {
    return RefreshIndicator(
      onRefresh: () => context.read<SubjectsCubit>().getSubjects(),
      child: subjects.isEmpty
          ? Center(
              child: Text(
                'لا يوجد مواد دراسية',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            )
          : GridView.builder(
              padding: EdgeInsets.all(3.w),
              itemCount: subjects.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 per row
                crossAxisSpacing: 3.w,
                mainAxisSpacing: 2.h,
                childAspectRatio: 0.75, // Adjust for mosque shape
              ),
              itemBuilder: (context, index) {
                return SubjectMosqueCard(subject: subjects[index]);
              },
            ),
    );
  }
}

class SubjectMosqueCard extends StatelessWidget {
  final Subject subject;

  const SubjectMosqueCard({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: subject.id,
      child: ClipPath(
        clipper: MosqueClipper(),
        child: Card(
          color: Colors.white,
          elevation: 3,
          child: InkWell(
            onTap: () {
              context.push(SubjectDetailScreen(subject: subject));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CachedNetworkImage(
                  imageUrl: subject.imageUrl,
                  height: 15.h,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 12.h,
                    color: Colors.grey[300],
                    child:
                        Icon(Icons.image, size: 20.sp, color: Colors.grey[500]),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 12.h,
                    color: Colors.grey[300],
                    child: Icon(Icons.broken_image,
                        size: 20.sp, color: Colors.red[400]),
                  ),
                ),

                // Card Content
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(2.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subject.name,
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          subject.description,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey[700]),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Expanded(
                              child: LinearProgressIndicator(
                                value: subject.progress / 100.0,
                                backgroundColor: Colors.grey[300],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  subject.isCompleted
                                      ? Colors.green
                                      : Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            if (subject.isCompleted)
                              Padding(
                                padding: EdgeInsetsDirectional.only(start: 2.w),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Icon(Icons.check_circle,
                                      color: Colors.green, size: 16.sp),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 0.5.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MosqueClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final width = size.width;
    final height = size.height;
    path.moveTo(0, height * 0.45);
    path.quadraticBezierTo(width / 2, -height * 0.3, width, height * 0.45);
    path.lineTo(width, height);
    path.lineTo(0, height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

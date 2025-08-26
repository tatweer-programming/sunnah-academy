import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:sunnah_academy/src/core/widgets/core_widgets.dart';
import 'package:sunnah_academy/src/modules/subjects/data/models/subject.dart';
import 'package:sunnah_academy/src/modules/subjects/ui/widgets/subject_card.dart';

import '../../../subjects/cubit/subjects_cubit.dart';

class SubjectsTab extends StatefulWidget {
  const SubjectsTab({super.key});

  @override
  State<SubjectsTab> createState() => _SubjectsTabState();
}

class _SubjectsTabState extends State<SubjectsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Load subjects when the tab is first created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubjectsCubit>().getSubjects();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh subjects data when coming back to this tab
    final cubit = context.read<SubjectsCubit>();
    cubit.getCurrentSubjects();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    return Scaffold(
      appBar: AppBar(
        title: const Text("المواد الدراسية"),
        automaticallyImplyLeading: false,
      ),
      body: BlocConsumer<SubjectsCubit, SubjectsState>(
        listener: (context, state) {
          if (state is CompleteLectureSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم إكمال المحاضرة بنجاح')),
            );
          } else if (state is CompleteLectureError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('خطأ في إكمال المحاضرة: ${state.exception}')),
            );
          } else if (state is CompleteSubjectSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم إكمال المادة بنجاح')),
            );
          }
        },
        buildWhen: (previous, current) {
          // Rebuild when subjects data changes
          return current is GetSubjectsLoading ||
              current is GetSubjectsSuccess ||
              current is GetSubjectsError ||
              current is CompleteLectureSuccess ||
              current is CompleteSubjectSuccess;
        },
        builder: (context, state) {
          final subjects = state.subjects ?? [];

          if (state is GetSubjectsLoading && subjects.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GetSubjectsError && subjects.isEmpty) {
            return Center(
              child: SizedBox(
                height: 30.h,
                width: 80.w,
                child: CustomErrorWidget(
                  exception: state.exception,
                ),
              ),
            );
          }

          // عرض البيانات
          return _buildSubjectsGrid(subjects, state);
        },
      ),
    );
  }

  Widget _buildSubjectsGrid(List<Subject> subjects, SubjectsState state) {
    return RefreshIndicator(
      onRefresh: () =>
          context.read<SubjectsCubit>().getSubjects(forceRefresh: true),
      child: Stack(
        children: [
          subjects.isEmpty
              ? CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.school_outlined,
                              size: 15.w,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'لا يوجد مواد دراسية',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.grey,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : GridView.builder(
                  padding: EdgeInsets.all(3.w),
                  itemCount: subjects.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 3.w,
                    mainAxisSpacing: 2.h,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    return SubjectMosqueCard(
                      subject: subjects[index],
                      key: ValueKey(subjects[index].id),
                    );
                  },
                ),

          // Loading overlay عند التحديث
          if (state is GetSubjectsLoading && subjects.isNotEmpty)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 4,
                child: const LinearProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}

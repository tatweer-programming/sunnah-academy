import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:sunnah_academy/src/modules/subjects/data/models/subject.dart';
import 'package:sunnah_academy/src/modules/subjects/ui/widgets/subject_card.dart';

import '../../../subjects/cubit/subjects_cubit.dart';

class SubjectsTab extends StatefulWidget {
  const SubjectsTab({super.key});

  @override
  State<SubjectsTab> createState() => _SubjectsTabState();
}

class _SubjectsTabState extends State<SubjectsTab> {
  List<Subject> subjects = [];

  @override
  void initState() {
    super.initState();
    if (subjects.isEmpty) {
      context.read<SubjectsCubit>().getSubjects();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("المواد الدراسية"),
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<SubjectsCubit, SubjectsState>(
        builder: (context, state) {
          if (state is GetSubjectsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetSubjectsSuccess || subjects.isNotEmpty) {
            subjects = context.read<SubjectsCubit>().subjects;
            return _buildSubjectsGrid(subjects);
          } else if (state is GetSubjectsError) {
            return Center(child: Text(state.exception.toString()));
          }
          return const Center(child: Text(""));
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

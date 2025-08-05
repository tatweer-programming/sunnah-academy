import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:sunnah_academy/src/core/routing/navigation_manager.dart';
import 'package:sunnah_academy/src/core/widgets/core_widgets.dart';
import 'package:sunnah_academy/src/modules/student/ui/screens/profile_page.dart';
import 'package:sunnah_academy/src/modules/subjects/cubit/subjects_cubit.dart';

import '../../../../core/services/dep_injection.dart';

class SubjectsScreen extends StatelessWidget {
  const SubjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubjectsCubit(sl())..getSubjects(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('المواد الدراسية'),
          leading: IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              context.push(ProfileScreen());
            },
          ),
        ),
        body: BlocBuilder<SubjectsCubit, SubjectsState>(
          builder: (context, state) {
            if (state is GetSubjectsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GetSubjectsSuccess) {
              return ListView.builder(
                itemCount: state.subjects.length,
                itemBuilder: (context, index) {
                  final subject = state.subjects[index];
                  return ListTile(
                    title: Text(subject.name),
                    subtitle: Text(subject.description),
                    onTap: () {
                      // context.push(SubjectScreen(subject: subject));
                    },
                  );
                },
              );
            } else if (state is GetSubjectsError) {
              return Center(
                child: CustomErrorWidget(
                  exception: state.exception,
                  height: 20.h,
                ),
              );
            } else {
              return Center(
                  child: CustomErrorWidget(
                exception: Exception(""),
              ));
            }
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sunnah_academy/src/core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../cubit/exam_cubit.dart';
import '../widgets/exam_details_widget.dart';

class ExamScreen extends StatefulWidget {
  const ExamScreen({super.key});

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ExamCubit>().getExamDetails('68812fc01b69f349d2e85cf4');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Exam Details',),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<ExamCubit, ExamState>(
            builder: (context, state) {
              if (state is ExamLoading) {
                return const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                );
              } else if (state is ExamLoaded) {
                return ExamDetailsWidget(exam: state.exam);
              } else if (state is ExamError) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        color: Colors.red, size: 60),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${state.message}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      text: "Retry",
                      onPressed: () {
                        context
                            .read<ExamCubit>()
                            .getExamDetails('68812fc01b69f349d2e85cf4');
                      },
                    ),
                  ],
                );
              }
              return const SizedBox
                  .shrink();
            },
          ),
        ),
      ),
    );
  }
}

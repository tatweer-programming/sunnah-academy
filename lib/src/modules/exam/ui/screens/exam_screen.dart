import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sunnah_academy/src/core/widgets/custom_button.dart';

import '../../cubit/exam_cubit.dart';
import '../widgets/exam_details_widget.dart';

class ExamScreen extends StatefulWidget {
  final String examId;
  const ExamScreen({super.key, required this.examId});

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ExamCubit>().getExamDetails(widget.examId);
  }

  @override
  void didUpdateWidget(covariant ExamScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    context.read<ExamCubit>().getExamDetails(widget.examId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("تفاصيل الامتجان"),
      ),
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
                      'حدث خطأ ما',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      text: 'إعادة المحاولة',
                      onPressed: () {
                        print(widget.examId);
                        context
                            .read<ExamCubit>()
                            .getExamDetails("68812fc01b69f349d2e85cf4");
                      },
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

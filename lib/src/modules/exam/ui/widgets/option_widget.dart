import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../cubit/exam_cubit.dart';
import '../../data/models/question.dart';

class OptionsListView extends StatelessWidget {
  final Question question;
  final int? selectedOptionIndex;
  final ExamInProgress state;

  const OptionsListView({
    super.key,
    required this.question,
    required this.selectedOptionIndex,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: question.options.length,
      separatorBuilder: (context, index) => SizedBox(height: 1.5.h),
      itemBuilder: (context, index) {
        return OptionTile(
          option: question.options[index],
          optionIndex: index,
          isSelected: state.selectedAnswers[question.id] == index,
          onTap: () => _selectOption(context, index),
        );
      },
    );
  }

  void _selectOption(BuildContext context, int optionIndex) {
    context.read<ExamCubit>().selectAnswer(question.id, optionIndex);
  }
}

// ===== OPTION TILE =====
class OptionTile extends StatelessWidget {
  final String option;
  final int optionIndex;
  final bool isSelected;
  final VoidCallback onTap;

  const OptionTile({
    super.key,
    required this.option,
    required this.optionIndex,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final optionLetter = String.fromCharCode(49 + optionIndex);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue.shade50 : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.blue.shade400 : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              OptionIndicator(
                letter: optionLetter,
                isSelected: isSelected,
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  option,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.blue.shade800 : Colors.black87,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: Colors.blue.shade600,
                  size: 20.sp,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class OptionIndicator extends StatelessWidget {
  final String letter;
  final bool isSelected;

  const OptionIndicator({
    super.key,
    required this.letter,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 10.w,
      height: 10.w,
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.shade600 : Colors.grey.shade200,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          letter,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade600,
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }
}

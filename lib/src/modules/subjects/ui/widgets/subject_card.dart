import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:sunnah_academy/src/modules/subjects/data/models/completion_condition/exam_condition.dart';
import 'package:sunnah_academy/src/modules/subjects/data/models/subject.dart';

class SubjectCard extends StatelessWidget {
  final Subject subject;
  const SubjectCard({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      width: 92.w,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          spacing: 1.h,
          children: [
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(
                    subject.imageUrl,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            )),
            Expanded(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
              child: Column(
                spacing: 1.h,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 2,
                    fit: FlexFit.loose,
                    child: Text(
                      subject.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    fit: FlexFit.tight,
                    child: Text(
                      subject.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Spacer(
                    flex: 2,
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.loose,
                    child: LinearProgressIndicator(
                      value: subject.progressPercentage,
                    ),
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}

class TestSubjectCardScreen extends StatelessWidget {
  const TestSubjectCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Subject Card'),
      ),
      body: Center(
        child: SubjectCard(
          subject: Subject(
              id: '1',
              name: 'علوم الحديث ',
              description:
                  'دروة علوم الحديث المستوى الاول يقدمها فضيلة الشيخ عبد الله المنصور حسنين ويتناول فيها مقدمة عن علوم لحديث وأساسياته',
              imageUrl:
                  'https://m7et.com/wp-content/uploads/2022/01/%D8%AA%D8%B9%D8%B1%D9%8A%D9%81-%D8%B9%D9%84%D9%85-%D8%A7%D9%84%D8%AD%D8%AF%D9%8A%D8%AB-%D8%AF%D8%B1%D8%A7%D9%8A%D8%A9-%D9%88%D8%B1%D9%88%D8%A7%D9%8A%D8%A9-1.jpg', // Replace with a valid image URL
              completionCondition: ExamCondition(examId: "1"),
              bookUrl:
                  'https://example.com/book.pdf', // Replace with a valid book URL
              isCompleted: false,
              progress: 66,
              lectures: []),
        ),
      ),
    );
  }
}

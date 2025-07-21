import 'package:flutter/material.dart';
import 'package:sunnah_academy/src/modules/subjects/data/models/lecture.dart';

class LectureHeader extends StatelessWidget {
  final Lecture lecture;
  final Widget? actionButton;

  const LectureHeader({
    Key? key,
    required this.lecture,
    this.actionButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getContentIcon(),
                color: Theme.of(context).iconTheme.color,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  lecture.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  lecture.contentType.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              const Spacer(),
              if (lecture.isComplete)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Theme.of(context).colorScheme.primary,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'مكتملة',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          if (actionButton != null) ...[
            const SizedBox(height: 16),
            actionButton!,
          ],
        ],
      ),
    );
  }

  IconData _getContentIcon() {
    switch (lecture.contentType.toLowerCase()) {
      case 'video':
        return Icons.play_circle_filled;
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'audio':
        return Icons.audiotrack;
      default:
        return Icons.library_books;
    }
  }
}

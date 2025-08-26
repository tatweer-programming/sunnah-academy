import 'package:cached_network_image/cached_network_image.dart'
    show CachedNetworkImage;
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:sunnah_academy/src/core/routing/navigation_manager.dart';
import 'package:sunnah_academy/src/modules/subjects/data/models/subject.dart';
import 'package:sunnah_academy/src/modules/subjects/ui/screens/subject_details_screen.dart';

class SubjectCard extends StatelessWidget {
  final Subject subject;

  const SubjectCard({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      child: Stack(
        children: [
          // Main Card Container
          Container(
            height: 16.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  colorScheme.surface,
                  colorScheme.primary.withOpacity(0.03),
                ],
              ),
              border: Border.all(
                color: colorScheme.primary.withOpacity(0.08),
                width: 1.5,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20.0),
                onTap: () {
                  context.push(SubjectDetailScreen(subjectId: subject.id));
                },
                child: Padding(
                  padding: EdgeInsets.all(5.w),
                  child: Row(
                    children: [
                      // Left side - Image with overlay
                      Container(
                        width: 20.w,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.primary.withOpacity(0.15),
                              offset: const Offset(2, 4),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16.0),
                              child: CachedNetworkImage(
                                imageUrl: subject.imageUrl,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.0),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        colorScheme.secondary.withOpacity(0.2),
                                        colorScheme.primary.withOpacity(0.1),
                                      ],
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.auto_stories_rounded,
                                      size: 24.sp,
                                      color: colorScheme.secondary,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.0),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        colorScheme.error.withOpacity(0.1),
                                        colorScheme.surface,
                                      ],
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.library_books_rounded,
                                      size: 24.sp,
                                      color: colorScheme.error.withOpacity(0.7),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Overlay gradient
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    colorScheme.primary.withOpacity(0.05),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(width: 4.w),

                      // Right side - Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Top section
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  subject.name,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: colorScheme.onSurface,
                                    fontSize: 16.sp,
                                    height: 1.2,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  subject.description,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color:
                                        colorScheme.onSurface.withOpacity(0.65),
                                    fontSize: 12.sp,
                                    height: 1.3,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),

                            // Bottom section - Progress
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 1.w,
                                          height: 3.h,
                                          decoration: BoxDecoration(
                                            color: subject.isCompleted
                                                ? colorScheme.primary
                                                : colorScheme.secondary,
                                            borderRadius:
                                                BorderRadius.circular(2),
                                          ),
                                        ),
                                        SizedBox(width: 2.w),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'مستوى التقدم',
                                              style: theme.textTheme.labelSmall
                                                  ?.copyWith(
                                                color: colorScheme.onSurface
                                                    .withOpacity(0.5),
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(height: 0.2.h),
                                            Text(
                                              '${subject.progress}%',
                                              style: theme.textTheme.titleMedium
                                                  ?.copyWith(
                                                color: subject.isCompleted
                                                    ? colorScheme.primary
                                                    : colorScheme.secondary,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    // Circular progress
                                    SizedBox(
                                      width: 12.w,
                                      height: 12.w,
                                      child: Stack(
                                        children: [
                                          CircularProgressIndicator(
                                            value: subject.progress / 100.0,
                                            backgroundColor: colorScheme.primary
                                                .withOpacity(0.1),
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              subject.isCompleted
                                                  ? colorScheme.primary
                                                  : colorScheme.secondary,
                                            ),
                                            strokeWidth: 3,
                                          ),
                                          Center(
                                            child: subject.isCompleted
                                                ? Icon(
                                                    Icons.done_all_rounded,
                                                    color: colorScheme.primary,
                                                    size: 16.sp,
                                                  )
                                                : Icon(
                                                    Icons.play_arrow_rounded,
                                                    color:
                                                        colorScheme.secondary,
                                                    size: 16.sp,
                                                  ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Floating completion badge
          if (subject.isCompleted)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 3.w,
                  vertical: 0.5.h,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withOpacity(0.3),
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.verified_rounded,
                      color: colorScheme.onPrimary,
                      size: 12.sp,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'مكتمل',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class SubjectMosqueCard extends StatelessWidget {
  final Subject subject;

  const SubjectMosqueCard({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Hero(
      tag: subject.id,
      child: ClipPath(
        clipper: MosqueClipper(),
        child: Card(
          color: colorScheme.surface,
          elevation: theme.cardTheme.elevation ?? 3,
          child: InkWell(
            onTap: () {
              context.push(SubjectDetailScreen(subjectId: subject.id));
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
                    color: colorScheme.surfaceVariant,
                    child: Icon(
                      Icons.image,
                      size: 20.sp,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 12.h,
                    color: colorScheme.surfaceVariant,
                    child: Icon(
                      Icons.broken_image,
                      size: 20.sp,
                      color: colorScheme.error,
                    ),
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
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          subject.description,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Expanded(
                              child: LinearProgressIndicator(
                                value: subject.progress / 100.0,
                                backgroundColor: colorScheme.surfaceVariant,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  subject.isCompleted
                                      ? theme.colorScheme
                                          .secondary // استخدام اللون الثانوي (الذهبي) للمكتمل
                                      : colorScheme.primary,
                                ),
                              ),
                            ),
                            if (subject.isCompleted)
                              Padding(
                                padding: EdgeInsetsDirectional.only(start: 2.w),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Icon(
                                    Icons.check_circle,
                                    color: theme.colorScheme
                                        .secondary, // اللون الذهبي للأيقونة
                                    size: 16.sp,
                                  ),
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

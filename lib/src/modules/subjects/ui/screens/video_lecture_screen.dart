import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sunnah_academy/src/core/routing/navigation_manager.dart';
import 'package:sunnah_academy/src/modules/exam/ui/screens/exam_screen.dart';
import 'package:sunnah_academy/src/modules/subjects/cubit/subjects_cubit.dart';
import 'package:sunnah_academy/src/modules/subjects/data/models/completion_condition/exam_condition.dart';
import 'package:sunnah_academy/src/modules/subjects/ui/widgets/completion_button.dart';
import 'package:sunnah_academy/src/modules/subjects/ui/widgets/lecture_header.dart';
import 'package:video_player/video_player.dart';

import '../../data/models/lecture.dart';

class VideoLectureScreen extends StatefulWidget {
  final Lecture lecture;

  const VideoLectureScreen({super.key, required this.lecture});

  @override
  State<VideoLectureScreen> createState() => _VideoLectureScreenState();
}

class _VideoLectureScreenState extends State<VideoLectureScreen> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isLoading = true;
  bool _hasError = false;
  bool _isCompletionLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.lecture.url),
      );

      await _videoPlayerController!.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: false,
        looping: false,
        showControls: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: Theme.of(context).colorScheme.primary,
          handleColor: Theme.of(context).colorScheme.primary,
          backgroundColor:
              Theme.of(context).colorScheme.primary.withOpacity(0.3),
          bufferedColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
        ),
        placeholder: Container(
          color: Colors.black,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error,
                  color: Theme.of(context).colorScheme.error,
                  size: 64,
                ),
                const SizedBox(height: 16),
                Text(
                  'خطأ في تحميل الفيديو',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  errorMessage,
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      );

      setState(() {
        _isLoading = false;
        _hasError = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  Future<void> _markAsCompleted() async {
    if (widget.lecture.completionCondition != null) {
      ExamCondition examCondition =
          widget.lecture.completionCondition as ExamCondition;
      context.push(ExamScreen(
        examId: examCondition.examId,
      ));
    } else {
      context
          .read<SubjectsCubit>()
          .completeLecture(lectureId: widget.lecture.id);
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          LectureHeader(
            lecture: widget.lecture,
            actionButton: BlocBuilder<SubjectsCubit, SubjectsState>(
              builder: (context, state) {
                return BlocBuilder<SubjectsCubit, SubjectsState>(
                  builder: (context, state) {
                    if (widget.lecture.isComplete) {
                      return const SizedBox.shrink();
                    }
                    return CompletionButton(
                        lecture: widget.lecture,
                        onComplete: _markAsCompleted,
                        isLoading: state is CompleteLectureLoading);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _buildVideoPlayer(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error,
              color: Theme.of(context).colorScheme.error,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'خطأ في تحميل الفيديو',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                  ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _hasError = false;
                });
                _initializeVideo();
              },
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    if (_chewieController != null) {
      return Chewie(controller: _chewieController!);
    }

    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

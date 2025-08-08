import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../data/models/lecture.dart';
import '../widgets/completion_button.dart';
import '../widgets/lecture_header.dart';

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
    setState(() {
      _isCompletionLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // widget.lecture.markAsCompleted();

    setState(() {
      _isCompletionLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم تحديد المحاضرة كمكتملة'),
        ),
      );
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
            actionButton: CompletionButton(
              lecture: widget.lecture,
              onComplete: _markAsCompleted,
              isLoading: _isCompletionLoading,
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

// Dependencies to add to pubspec.yaml:
/*
dependencies:
  chewie: ^1.7.4
  video_player: ^2.8.2
  url_launcher: ^6.2.4
  audioplayers: ^5.2.1
*/

// Usage Example:
/*
// Navigate to different lecture screens based on content type
void navigateToLectureScreen(BuildContext context, Lecture lecture) {
  Widget screen;

  switch (lecture.contentType.toLowerCase()) {
    case 'video':
      screen = VideoLectureScreen(lecture: lecture);
      break;
    case 'pdf':
      screen = PdfLectureScreen(lecture: lecture);
      break;
    case 'audio':
      screen = AudioLectureScreen(lecture: lecture);
      break;
    default:
      // Handle unknown content type
      return;
  }

  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => screen),
  );
}
*/

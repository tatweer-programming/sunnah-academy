// lib/src/modules/subjects/presentation/screens/audio_lecture_screen.dart
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../../data/models/lecture.dart';
import '../widgets/completion_button.dart';
import '../widgets/lecture_header.dart';

class AudioLectureScreen extends StatefulWidget {
  final Lecture lecture;

  const AudioLectureScreen({super.key, required this.lecture});

  @override
  State<AudioLectureScreen> createState() => _AudioLectureScreenState();
}

class _AudioLectureScreenState extends State<AudioLectureScreen> {
  AudioPlayer? _audioPlayer;
  bool _isPlaying = false;
  bool _isLoading = false;
  bool _hasError = false;
  bool _isCompletionLoading = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  double _playbackRate = 1.0;

  @override
  void initState() {
    super.initState();
    _initializeAudio();
  }

  Future<void> _initializeAudio() async {
    _audioPlayer = AudioPlayer();

    _audioPlayer!.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });

    _audioPlayer!.onPositionChanged.listen((position) {
      setState(() {
        _position = position;
      });
    });

    _audioPlayer!.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });
  }

  Future<void> _playPause() async {
    if (_audioPlayer == null) return;

    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      if (_isPlaying) {
        await _audioPlayer!.pause();
      } else {
        await _audioPlayer!.play(UrlSource(widget.lecture.url));
        await _audioPlayer!.setPlaybackRate(_playbackRate);
      }
    } catch (e) {
      setState(() {
        _hasError = true;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في تشغيل الصوت: $e')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _stop() async {
    if (_audioPlayer == null) return;
    await _audioPlayer!.stop();
  }

  Future<void> _seekTo(Duration position) async {
    if (_audioPlayer == null) return;
    await _audioPlayer!.seek(position);
  }

  Future<void> _changePlaybackRate(double rate) async {
    if (_audioPlayer == null) return;
    setState(() {
      _playbackRate = rate;
    });
    await _audioPlayer!.setPlaybackRate(rate);
  }

  void _seekForward() {
    final newPosition = _position + const Duration(seconds: 10);
    if (newPosition < _duration) {
      _seekTo(newPosition);
    }
  }

  void _seekBackward() {
    final newPosition = _position - const Duration(seconds: 10);
    if (newPosition > Duration.zero) {
      _seekTo(newPosition);
    } else {
      _seekTo(Duration.zero);
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

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _audioPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            const SizedBox(height: 32),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Audio Icon
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(75),
                      ),
                      child: Icon(
                        Icons.headphones,
                        size: 80,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Progress Bar
                    Column(
                      children: [
                        Slider(
                          value: _position.inSeconds.toDouble(),
                          max: _duration.inSeconds.toDouble(),
                          onChanged: (value) {
                            _seekTo(Duration(seconds: value.toInt()));
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatDuration(_position),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Text(
                                _formatDuration(_duration),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Control Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: _seekBackward,
                          icon: const Icon(Icons.replay_10),
                          iconSize: 32,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: IconButton(
                            onPressed: _isLoading ? null : _playPause,
                            icon: _isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Icon(
                                    _isPlaying ? Icons.pause : Icons.play_arrow,
                                    color: Colors.white,
                                  ),
                            iconSize: 32,
                          ),
                        ),
                        IconButton(
                          onPressed: _seekForward,
                          icon: const Icon(Icons.forward_10),
                          iconSize: 32,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Stop Button
                    OutlinedButton.icon(
                      onPressed: _stop,
                      icon: const Icon(Icons.stop),
                      label: const Text('إيقاف'),
                    ),

                    const SizedBox(height: 24),

                    // Playback Speed
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'السرعة: ',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        DropdownButton<double>(
                          value: _playbackRate,
                          items: [0.5, 0.75, 1.0, 1.25, 1.5, 2.0]
                              .map((rate) => DropdownMenuItem(
                                    value: rate,
                                    child: Text('${rate}x'),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              _changePlaybackRate(value);
                            }
                          },
                        ),
                      ],
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

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class YourVideoPlayerWidget extends StatefulWidget {
  const YourVideoPlayerWidget({super.key});

  @override
  State<YourVideoPlayerWidget> createState() => _YourVideoPlayerWidgetState();
}

class _YourVideoPlayerWidgetState extends State<YourVideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('lib/assets/pull_up.mp4')
      ..initialize().then((_) {
        setState(() {}); // ensure video initialized before displaying
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _playPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const Center(child: CircularProgressIndicator()),

        // Play button overlay
        if (!_controller.value.isPlaying)
          IconButton(
            icon: const Icon(Icons.play_circle_fill,
                size: 64, color: Colors.white),
            onPressed: _playPause,
          ),
      ],
    );
  }
}

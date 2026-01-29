import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoCard extends StatefulWidget {
  final String videoUrl; // URL or local path

  const VideoCard({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {}); // Refresh UI once video is loaded
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black, // fallback background
        borderRadius: BorderRadius.circular(12),
      ),
      child: _controller.value.isInitialized
          ? Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: VideoPlayer(_controller),
          ),
          Center(
            child: GestureDetector(
              onTap: _togglePlayPause,
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.black54,
                child: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

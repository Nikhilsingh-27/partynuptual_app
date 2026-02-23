import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoCard extends StatefulWidget {
  final String videoId;

  const VideoCard({super.key, required this.videoId});

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  YoutubePlayerController? _controller;
  bool _isPlaying = false;

  void _initializePlayer() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
    );

    setState(() {
      _isPlaying = true;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final thumbnail =
        "https://img.youtube.com/vi/${widget.videoId}/hqdefault.jpg";

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: _isPlaying && _controller != null
          ? YoutubePlayer(
              controller: _controller!,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.red,
            )
          : GestureDetector(
              onTap: _initializePlayer,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.network(
                    thumbnail,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.black12,
                        child: const Center(child: Icon(Icons.broken_image)),
                      );
                    },
                  ),
                  const Icon(
                    Icons.play_circle_fill,
                    size: 70,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
    );
  }
}

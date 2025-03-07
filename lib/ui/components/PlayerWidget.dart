import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PlayerWidget extends StatefulWidget {
  final String url;
  const PlayerWidget(this.url,{super.key});

  @override
  State<PlayerWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  bool _isVideoInitialized = false;

  
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

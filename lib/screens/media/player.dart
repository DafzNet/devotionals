import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlayerScreen extends StatefulWidget {
  final String videoId;
  const PlayerScreen({
    required this.videoId,
    super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {

  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    );

    _controller.addListener(() {
      if (_controller.value.playerState == PlayerState.ended) {
        // Video playback has ended
        // Hide the YouTube logo and loading indicator
        _controller.pause();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),

      body: YoutubePlayer(
        onEnded: (t){
          
        },
        controller: _controller
      ),
  );
  }
}
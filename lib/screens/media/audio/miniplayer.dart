import 'package:devotionals/screens/media/audio/services/manager.dart';
import 'package:devotionals/utils/widgets/cards/music.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:page_transition/page_transition.dart';
import 'package:podcast_search/podcast_search.dart';

final GetIt getIt = GetIt.instance;

class MiniAudioPlayer extends StatefulWidget {
  final Episode? episode;
  final bool isPlaying;
  final bool isPaused;

  MiniAudioPlayer({
    this.episode,
    this.isPaused = false,
    this.isPlaying = true
  });

  @override
  State<MiniAudioPlayer> createState() => _MiniAudioPlayerState();
}

class _MiniAudioPlayerState extends State<MiniAudioPlayer> {
  AudioManager audioManager = getIt<AudioManager>();

  @override
  void initState() {
    audioManager.audioPlayer.positionStream.listen((event) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
          PageTransition(child: MusicPlayerTile(), type: PageTransitionType.bottomToTop)
        );
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.episode != null?widget.episode!.title:'Title',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.episode != null?widget.episode!.author!:'Artist',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.skip_previous),
                  onPressed: ()async{
                    
                  },
                ),
                IconButton(
                  icon: Icon(audioManager.isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: ()async{
                    audioManager.isPlaying ? await audioManager.pause():await audioManager.resume();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.skip_next),
                  onPressed: (){},
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatDuration(audioManager.currentPosition),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(formatDuration(audioManager.totalDuration)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }
}


import 'package:audio_service/audio_service.dart';
import 'package:devotionals/screens/media/audio/services/manager.dart';
import 'package:devotionals/utils/widgets/cards/music.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:page_transition/page_transition.dart';


final GetIt getIt = GetIt.instance;

class MiniAudioPlayer extends StatefulWidget {
  final bool isPlaying;
  final bool isPaused;

  MiniAudioPlayer({
    this.isPaused = false,
    this.isPlaying = true
  });

  @override
  State<MiniAudioPlayer> createState() => _MiniAudioPlayerState();
}

class _MiniAudioPlayerState extends State<MiniAudioPlayer> {
  final AudioManager audioManager = getIt<AudioManager>();
  final audioHandler = getIt<AudioHandler>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MediaItem?>(
      stream: audioHandler.mediaItem,
      builder: (context, snapshot) {
        final MediaItem? mediaItem = snapshot.data;

        return InkWell(
          onTap: () {
            // Navigator.push(
            //   context,
            //   PageTransition(child: MusicPlayerTile(), type: PageTransitionType.bottomToTop),
            // );
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
                        mediaItem?.title ?? 'Unknown',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        mediaItem?.artist ?? 'Unknown',
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
                      onPressed: () {
                        audioHandler.skipToPrevious();
                      },
                    ),
                    StreamBuilder<bool>(
                      stream: audioHandler.playbackState.map((state) => state.playing).distinct(),
                      builder: (context, snapshot) {
                        final bool isPlaying = snapshot.data ?? false;
                        return IconButton(
                          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                          onPressed: () {
                            if (isPlaying) {
                              audioHandler.pause();
                            } else {
                              audioHandler.play();
                            }
                          },
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.skip_next),
                      onPressed: () {
                        audioHandler.skipToNext();
                      },
                    ),
                  ],
                ),
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.end,
                //   children: [
                //     Text(
                //       formatDuration(audioManager.currentPosition),
                //       style: TextStyle(fontWeight: FontWeight.bold),
                //     ),
                //     Text(formatDuration(audioManager.totalDuration)),
                //   ],
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }
}

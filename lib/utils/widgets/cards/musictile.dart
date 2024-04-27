import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:devotionals/screens/media/audio/services/manager.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../screens/media/audio/services/my_audio.dart';



final GetIt getIt = GetIt.instance;
AudioManager audioManager = getIt<AudioManager>();
final _audioHandler = getIt<AudioHandler>();
// final _playlist = getIt<Playlist>();

class PodcastTile extends StatefulWidget {
  final Episode podcast;
  final List<Episode> playlist;
  final int index;
  final Color? color;
  final Color? tcolor;
  final Function(TapUpDetails)? trailingAction;
  const PodcastTile({
    required this.podcast,
    required this.index,
    this.tcolor,
    required this.playlist,
    this.trailingAction,
    this.color,
  });

  @override
  State<PodcastTile> createState() => _PodcastTileState();
}

class _PodcastTileState extends State<PodcastTile> {
    String formatDuration(int seconds) {
      Duration duration = Duration(seconds: seconds);
      int hours = duration.inHours;
      int minutes = (duration.inMinutes % 60);
      int remainingSeconds = (duration.inSeconds % 60);

      String hoursString = hours.toString().padLeft(2, '0');
      String minutesString = minutes.toString().padLeft(2, '0');
      String secondsString = remainingSeconds.toString().padLeft(2, '0');

      return '$hoursString:$minutesString:$secondsString';
    }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async{
        await audioManager.setPlaylist(Playlist(title: 'All Messages', songs: widget.playlist, initIndex: widget.index), );
        await _audioHandler.play();
      },

      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color:widget.color??Colors.white,
          
        ),
    
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 60,
                height: 60,
            
                child: CachedNetworkImage(
                  imageUrl: widget.podcast.episodeImage??''
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.podcast.title,
                    style: TextStyle(
                      color: widget.tcolor?? Colors.grey.shade800,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                     formatDuration(widget.podcast.duration!.inSeconds),
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            if(widget.trailingAction!=null)
              GestureDetector(
                onTapUp: widget.trailingAction,
                child: Icon(MdiIcons.dotsVertical)
              )
          ],
        ),
      ),
    );
  }
}

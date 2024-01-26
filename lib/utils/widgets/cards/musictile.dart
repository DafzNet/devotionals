import 'package:cached_network_image/cached_network_image.dart';
import 'package:devotionals/screens/media/audio/services/manager.dart';
import 'package:devotionals/screens/media/audio/services/playing.dart';
import 'package:devotionals/utils/widgets/cards/music.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';

import '../../../screens/media/audio/services/audio.dart';



final GetIt getIt = GetIt.instance;
Playing playing = getIt<Playing>();
AudioManager audioManager = getIt<AudioManager>();

class PodcastTile extends StatefulWidget {
  final Episode podcast;
  final List<Episode> playlist;
  final Color? color;
  final Color? tcolor;
  final Function(TapUpDetails)? trailingAction;
  const PodcastTile({
    required this.podcast,
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
        playing.currentEpisode = widget.podcast;
        audioManager.playlist = widget.playlist;
        Navigator.push(
          context,
          PageTransition(child: MusicPlayerTile(true), type: PageTransitionType.bottomToTop)
        );
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

            if(playing.currentEpisode == widget.podcast)
              Icon(Icons.music_note_sharp),

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

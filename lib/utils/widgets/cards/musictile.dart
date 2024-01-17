import 'package:cached_network_image/cached_network_image.dart';
import 'package:devotionals/screens/media/audio/services/playing.dart';
import 'package:devotionals/utils/widgets/cards/music.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:page_transition/page_transition.dart';
import 'package:podcast_search/podcast_search.dart';



final GetIt getIt = GetIt.instance;

class PodcastTile extends StatefulWidget {
  final Episode podcast;
  const PodcastTile({
    required this.podcast
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

    Playing playing = getIt<Playing>();

    


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async{
        playing.currentEpisode = widget.podcast;
        Navigator.push(
          context,
          PageTransition(child: MusicPlayerTile(), type: PageTransitionType.bottomToTop)
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 12,
              offset:  Offset(0, 3),
            ),
          ],
        ),
    
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(widget.podcast.imageUrl??''),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.podcast.title,
                    style: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 18,
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
          ],
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:devotionals/dbs/sembast/generic.dart';
import 'package:devotionals/utils/models/vid.dart';
import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class VideoCard extends StatefulWidget {
  final String videoId;
  final List<VideoData> vids;

  const VideoCard({
    required this.videoId,
    required this.vids
  });

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {

  var yt = YoutubeExplode();
  final _store = DataStore('videos');

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

  Map<String, dynamic>? _video;

  void _getVideoFromBox()async{
    if (await _store.containsKey(widget.videoId)) {
      _video = await _store.get(widget.videoId);
    } else {
      _video = null;
    }

    setState(() {
      
    });
  }

  @override
  void initState() {
    _getVideoFromBox();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return _video == null? FutureBuilder(
      future: yt.videos.get('https://www.youtube.com/watch?v=${widget.videoId}'),
      builder: (context, snapshot) {
        if (snapshot.hasError || snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        final data = snapshot.data;
        _store.insert(widget.videoId,
          {
            'title': data!.title,
            'thumbNail':data.thumbnails.mediumResUrl, 
            'duration':data.duration!.inSeconds,
            'author':data.author
          }
        );
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color.fromARGB(255, 255, 255, 255),
            
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(data.thumbnails.mediumResUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                data.title,
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'by ${data.author} • ${formatDuration(data.duration!.inSeconds)}',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      }
    ):Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color.fromARGB(255, 255, 255, 255),
            
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(_video!['thumbNail']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                _video!['title'],
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'by ${_video!['author']} • ${formatDuration(_video!['duration'])}',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        )
    ;
  }
}

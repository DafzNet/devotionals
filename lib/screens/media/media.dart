import 'package:devotionals/screens/media/player.dart';
import 'package:devotionals/services/youtube_services.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
// import 'package:video_player/video_player.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MediaScreen extends StatefulWidget {
  const MediaScreen({super.key});

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {

  // https://www.youtube.com/watch?v=MiN3lUsne5U
  // https://youtu.be/DEoQcmjY-ug

  var yt = YoutubeExplode();

  final vids = ['DEoQcmjY-ug', 'MiN3lUsne5U','kEO7EenTuLY'];

  @override
  void initState() {
    super.initState();
  }
  // var title = video.title; // "Scamazon Prime"
  // var author = video.author; // "Jim Browning"
  // var duration = video.duration; // Instance of Duration - 0:19:48.00000

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mesages'),
      ),
      body: ListView.builder(
        itemCount: vids.length,
        itemBuilder: (context, index) {
          return FutureBuilder(
            future: yt.videos.get('https://www.youtube.com/watch?v=${vids[index]}'),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Container();
              }
              return ListTile(
                onTap: () {
                  Navigator.push(context,
                  PageTransition(child: PlayerScreen(videoId: vids[index]), type: PageTransitionType.fade));
                },
                title: Text(
                  snapshot.data!.title
                ),

                leading: Image.network(
                  snapshot.data!.thumbnails.mediumResUrl,
                ),


              );
          
              
            }
          );
        }
      ),
    );
  }
}
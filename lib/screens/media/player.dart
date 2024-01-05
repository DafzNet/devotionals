import 'package:devotionals/utils/helpers/functions/recommender.dart';
import 'package:devotionals/utils/models/vid.dart';
import 'package:devotionals/utils/widgets/cards/video_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:pod_player/pod_player.dart';
import 'package:marquee/marquee.dart';


class PlayerScreen extends StatefulWidget {
  final String videoId;
  final String title;
  final List<VideoData> vids;
  const PlayerScreen({
    required this.title,
    required this.vids,
    required this.videoId,
    super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {

  late YoutubePlayerController _controller;
  late PodPlayerController? podController;

  List<VideoData> relatedids = [];

  void related(){
    relatedids = VideoRecommendationService(widget.vids).getAllRecommendations(widget.vids.where((element) => element.id == widget.videoId).first, 25);
    setState(() {
      
    });
  }
  


  void y(){
    podController = PodPlayerController(
    playVideoFrom: PlayVideoFrom.youtube('https://www.youtu.be/${widget.videoId}'),
    podPlayerConfig: const PodPlayerConfig(
      autoPlay: true,
      isLooping: false,
      videoQualityPriority: [360]
    )
    )..initialise();

    setState(() {
        
      });
  }


  @override
  void initState() {
    super.initState();

    y();

    related();

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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        toolbarHeight: 10,

        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light
        ),
      ),

      body: Column(
        children: [
          if (podController != null)...
            [PodVideoPlayer(
              controller: podController!,
            ),
          ],

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width-10,
              height: 30,
              child: Marquee(
                  text: widget.title,
                  style: TextStyle(fontSize: 24.0),
                  scrollAxis: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  blankSpace: 20.0,
                  velocity: 50.0,
                  pauseAfterRound: Duration(seconds: 1),
                  startPadding: 10.0,
                  accelerationDuration: Duration(seconds: 1),
                  accelerationCurve: Curves.linear,
                  decelerationDuration: Duration(milliseconds: 500),
                  decelerationCurve: Curves.easeOut,
                ),
            ),
          ),

          SizedBox(height: 16,),

          Row(
            children: [
              Text('   Related Messages'),
            ],
          ),

          SizedBox(height: 10,),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: ListView.separated(
              itemCount: relatedids.length,
              itemBuilder: (context, index) {
                return VideoCard(videoId: relatedids[index].id, vids: widget.vids,);
              },
                  
              separatorBuilder: (context, index) {
                return SizedBox(height: 8,);
              },
                    ),
            ),
          ),
        ]
      
    ));
  }
}
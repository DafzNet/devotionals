import 'package:devotionals/screens/media/player.dart';
import 'package:devotionals/utils/constants/db_consts.dart';
import 'package:devotionals/utils/models/vid.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:card_loading/card_loading.dart';

class VideoCard extends StatefulWidget {
  final String videoId;
  final List<VideoData> vids;
  const VideoCard({
    required this.videoId,
    required this.vids,
    super.key});

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
// https://www.youtube.com/watch?v=${vids[index]}



  var yt = YoutubeExplode();

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


  openHBox()async{
    await Hive.openBox(videoIdsBox);

    setState(() {
      
    });
  }

  @override
  void initState() {
   openHBox(); 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool present = Hive.box(videoIdsBox).containsKey(widget.videoId);

    return !present ? Container(
      child: FutureBuilder(
        future: yt.videos.get('https://www.youtube.com/watch?v=${widget.videoId}'), 
        builder: (context, snapshot){
          if (snapshot.hasError || snapshot.connectionState == ConnectionState.waiting) {
            return CardLoading(
              height: 200,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              margin: EdgeInsets.only(bottom: 10),
            );
          }

          final data = snapshot.data;
          Hive.box(videoIdsBox).put(widget.videoId, {'title': data!.title, 'thumbNail':data.thumbnails.mediumResUrl, 'duration':data.duration});

          return GestureDetector(
            onTap: () {
                  Navigator.push(context,
                  PageTransition(child: PlayerScreen(videoId: widget.videoId, vids: widget.vids, title: data.title,), type: PageTransitionType.fade));
                },
            child: Column(
              children: [
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 16/9,
                      child: Image.network(
                        data.thumbnails.mediumResUrl,
                        fit: BoxFit.cover,
                      ),
                    ),

                    Positioned(
                      bottom: 5,
                      left: 8,

                      child: Container(
                        color: Color.fromARGB(110, 0, 0, 0),
                        child: SizedBox(
                          width: MediaQuery.sizeOf(context).width-26,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(10))
                              ),
                              child: Icon(Icons.play_arrow_outlined)),
                                              
                            Container(
                              width: 250,
                              height: 5,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(4))
                              ),),
                                              
                              Container(
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(10))
                              ),
                              child: Text(formatDuration(data.duration!.inSeconds))),
                          ],
                                            ),
                        ),
                      ))
                  ],
                ),
          
                Row(
                  children: [
                    IconButton(
                      iconSize: 15,
                      padding: EdgeInsets.symmetric(vertical: 1),
                      onPressed: (){

                      }, 
                      icon: Icon(MdiIcons.heart)),

                    Expanded(child: Text(
                      data.title,

                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,

                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),
                    ))
                  ],
                ),

                SizedBox(height: 5,),
              ]
            ),
          );
        }),
    )
    :
    GestureDetector(
      onTap: () {
            Navigator.push(context,
            PageTransition(child: PlayerScreen(videoId: widget.videoId, vids: widget.vids, title: Hive.box(videoIdsBox).get(widget.videoId)['title'],), type: PageTransitionType.fade));
          },
      child: Column(
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 16/9,
                child: Image.network(
                  Hive.box(videoIdsBox).get(widget.videoId)['thumbNail'],
                  fit: BoxFit.cover,
                ),
              ),

              Positioned(
                bottom: 5,
                left: 8,

                child: Container(
                  color: Color.fromARGB(110, 0, 0, 0),
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width-26,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        child: Icon(Icons.play_arrow_outlined)),
                                        
                      Container(
                        width: 250,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(4))
                        ),),
                                        
                        Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        child: Text(formatDuration(Hive.box(videoIdsBox).get(widget.videoId)['duration'].inSeconds,))),
                    ],
                                      ),
                  ),
                ))
            ],
          ),
    
          SizedBox(height: 2,),
    
          Row(
            children: [
              IconButton(
                iconSize: 20,
                padding: EdgeInsets.symmetric(vertical: 1),
                onPressed: (){

                }, 
                icon: Icon(MdiIcons.heart)),

              Expanded(child: Text(
                Hive.box(videoIdsBox).get(widget.videoId)['title'],

                maxLines: 1,
                overflow: TextOverflow.ellipsis,

                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              ))
            ],
          ),

          SizedBox(height: 5,),
        ]
      ),
    );
  }
}
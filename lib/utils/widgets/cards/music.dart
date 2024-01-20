import 'package:cached_network_image/cached_network_image.dart';
import 'package:devotionals/screens/media/audio/services/manager.dart';
import 'package:devotionals/screens/media/audio/services/playing.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marquee/marquee.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

final GetIt getIt = GetIt.instance;
class MusicPlayerTile extends StatefulWidget {
final bool play;
  const MusicPlayerTile(
    this.play
  );
  @override
  State<MusicPlayerTile> createState() => _MusicPlayerTileState();
}

class _MusicPlayerTileState extends State<MusicPlayerTile> {
  final AudioManager audioManager = getIt<AudioManager>();
  final Playing _playing = getIt<Playing>();

  void play()async{
    if (widget.play){await audioManager.play(_playing.currentEpisode!);} 
    
    setState(() {
      
    });
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  late AudioPlayer _audioPlayer;
  bool _isBuffering = true;

  @override
  @override
  void initState() { // Initialize currentPos
    play();
    _audioPlayer = audioManager.audioPlayer;

    _audioPlayer.playerStateStream.listen((event) {
      if (event.playing) {
        _isBuffering = false;
      } else {
        switch (event.processingState) {
          case ProcessingState.idle: _isBuffering = false;
          case ProcessingState.loading: _isBuffering = true;
          case ProcessingState.buffering: _isBuffering = true;
          case ProcessingState.ready: _isBuffering = false;
          case ProcessingState.completed: _isBuffering = false;
        }
      }
    });

    _audioPlayer.positionStream.listen((Duration position) {
      setState(() {
        
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_outline, color: Colors.white,),
            onPressed: () {
              // Handle add to playlist
            },
          ),

          IconButton(
            icon: Icon(MdiIcons.dotsVertical, color: Colors.white,),
            onPressed: () {
              // Handle add to playlist
            },
          ),
        ],
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: (){Navigator.pop(context);}, 
          icon: Icon(MdiIcons.arrowLeft, color: Colors.white,)),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          
          children: [
            
            Expanded(
              child: Stack(
                children: [

                  Center(
                    child: ClipOval(
                      child: Container(
                        height: MediaQuery.sizeOf(context).width-100,
                        width: MediaQuery.sizeOf(context).width-100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(_playing.currentEpisode!.episodeImage!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.sizeOf(context).width-60,
                  height: 30,
                  child: Marquee(
                      text: _playing.currentEpisode!.title,
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
                Expanded(
                  child: Text(
                    _playing.currentEpisode!.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                IconButton(
                  icon: Icon(Icons.playlist_play_outlined, color: Colors.white,),
                  onPressed: () {
                    // Handle add to playlist
                  },
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              _playing.currentEpisode!.author??'ADWF',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text(
                  formatDuration(audioManager.currentPosition),
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),

                Expanded(
                  child: Slider(
                    value: audioManager.currentPosition.inSeconds.toDouble(),
                    max: audioManager.totalDuration.inSeconds.toDouble(),
                    onChanged: (value) async{
                      await audioManager.seek(Duration(seconds: value.toInt()));
                      setState(() {
                        
                      });
                    },
                    onChangeEnd: (double value) async {
                      await audioManager.seek(Duration(seconds: value.toInt()));
                      setState(() {
                        
                      });
                    },
                    activeColor: Colors.green,
                    inactiveColor: Colors.grey,
                  ),
                ),

                Text(
                  formatDuration(audioManager.totalDuration),
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                )
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                icon: Icon(Icons.repeat_one),
                onPressed: () {
                  // Handle repeat toggle
                },
              ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.skip_previous,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                IconButton(
                  onPressed: () async{
                    audioManager.isPlaying ?
                      await audioManager.pause():
                      await audioManager.resume();
                    setState(() {
                      
                    });
                  },
                  icon: Icon(
                    audioManager.isPlaying ?
                      Icons.pause_circle_filled : 
                      Icons.play_circle_filled,
                    color: Colors.green,
                    size: 64,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.skip_next,
                    color: Colors.white,
                    size: 36,
                  ),
                ),

                IconButton(
                icon: Icon(Icons.loop),
                onPressed: () {
                  // Handle loop toggle
                },
              ),
              ],
            ),

            SizedBox(height: 30,)
            
          ],
        ),
      ),
    );
  }
}

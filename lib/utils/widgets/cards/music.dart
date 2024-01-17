import 'package:cached_network_image/cached_network_image.dart';
import 'package:devotionals/screens/media/audio/services/manager.dart';
import 'package:devotionals/screens/media/audio/services/playing.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:podcast_search/podcast_search.dart';


final GetIt getIt = GetIt.instance;
class MusicPlayerTile extends StatefulWidget {
// final Episode episode;
  const MusicPlayerTile(
    // required this.episode
  );
  @override
  State<MusicPlayerTile> createState() => _MusicPlayerTileState();
}

class _MusicPlayerTileState extends State<MusicPlayerTile> {
  final AudioManager audioManager = getIt<AudioManager>();
  final Playing _playing = getIt<Playing>();

  void play()async{
    await audioManager.play(_playing.currentEpisode!.contentUrl!);
    setState(() {
      
    });
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  var _audioPlayer;

  @override
  @override
  void initState() { // Initialize currentPos
    play();
    _audioPlayer = audioManager.audioPlayer;

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
              child: Center(
                child: ClipOval(
                  child: Container(
                    height: MediaQuery.sizeOf(context).width-100,
                    width: MediaQuery.sizeOf(context).width-100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(_playing.currentEpisode!.imageUrl!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Text(
              _playing.currentEpisode!.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
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
              ],
            ),
            
          ],
        ),
      ),
    );
  }
}
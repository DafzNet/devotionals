
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:devotionals/dbs/sembast/generic.dart';
import 'package:devotionals/screens/media/audio/miniplayer.dart';
import 'package:devotionals/screens/media/audio/services/manager.dart';
import 'package:devotionals/screens/media/audio/services/playing.dart';
import 'package:devotionals/utils/widgets/cards/music.dart';
import 'package:devotionals/utils/widgets/cards/musictile.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';

import 'services/audio.dart';
// import 'package:video_player/video_player.dart';

final GetIt getIt = GetIt.instance;

class AudioScreen  extends StatefulWidget {
  const AudioScreen({super.key});

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  final _audioService = AudioService();

  final _store = DataStore('episodes');
  final Playing _playing = getIt<Playing>();
  final AudioManager audioManager = getIt<AudioManager>();
 

  void _showPopupMenu(BuildContext context, Offset position) async {
      double yOffset = position.dy - 20.0;

  // Ensure the yOffset is non-negative
      yOffset = yOffset < 0 ? 0 : yOffset;
      
      await showMenu(
        context: context,
        position: RelativeRect.fromLTRB(position.dx, yOffset, position.dx + 1, yOffset+ 1),
        items: [
          PopupMenuItem<String>(
            onTap: () async{
             
            },
            value: '',
            child: Row(
              children: [
                Icon(MdiIcons.cameraOutline, size: 18,),
                SizedBox(width: 10,),
                Text('Camera'),
              ],
            ),
          ),


          PopupMenuItem<String>(
            onTap: ()async {
              
            },
            value: '',
            child: Row(
              children: [
                Icon(MdiIcons.viewGalleryOutline, size: 18,),
                SizedBox(width: 10,),
                Text('Gallery'),
              ],
            ),
          ),
         
        ],
      );
    }



  @override
  void initState() {
    super.initState();
  }
  
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            // SafeArea(child: SizedBox()),

            AnimSearchBar(
              width: MediaQuery.sizeOf(context).width-30, 
              textController: _textController, 
              onSuffixTap: (){
                _textController.clear();
              }, 
              onSubmitted: (v){}
            ),


            Row(
              children: [
                Wrap(
                  spacing: 10,
                  children: [
                    GestureDetector(
                      onTap: (){}, 
                      child: Text('All')
                    ),

                    GestureDetector(
                      onTap: (){}, 
                      child: Text('Favorites')
                    ),

                     GestureDetector(
                      onTap: (){}, 
                      child: Text('Playlists')
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 5,),
            Expanded(
              child: FutureBuilder(
                future: _audioService.searchPods(),
                builder: (context, snapshot) {
                  if ( //snapshot.data == null || 
                  snapshot.hasError) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          MdiIcons.closeCircleOutline,
                          size: 40,
                          color: Colors.redAccent.shade100,
                        ),
                  
                        Center(
                          child: Text(
                            // 'No Messages to stream'
                            'Oops, ${snapshot.error}'
                         ),
                        )
                      ],
                    );
                  }else if(snapshot.connectionState == ConnectionState.waiting){
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        
                  
                        Center(
                          child: CircularProgressIndicator()
                        )
                      ],
                    );
                  }
                  
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index){
                      return InkWell(
                        onTap: ()async{
                          await Navigator.push(
                            context,
                            PageTransition(child: MusicPlayerTile(true), type: PageTransitionType.bottomToTop)
                          );
                  
                          setState(() {
                            
                          });
                        },
                        child: PodcastTile(
                         podcast: snapshot.data![index],
                         trailingAction: (t){
                          _showPopupMenu(context, t.globalPosition);
                         },


                        ),
                      );
                    },
                  );
                }
              ),
            ),

            if(_playing.currentEpisode != null && (audioManager.isPlaying || audioManager.isPaused))...[
              MiniAudioPlayer(episode: _playing.currentEpisode)
            ]
          ],
        ),
      ),

    );
  }
}
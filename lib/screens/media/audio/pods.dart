
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:devotionals/dbs/sembast/generic.dart';
import 'package:devotionals/screens/media/audio/miniplayer.dart';
import 'package:devotionals/screens/media/audio/services/manager.dart';
import 'package:devotionals/screens/media/audio/services/playing.dart';
import 'package:devotionals/utils/constants/colors.dart';
import 'package:devotionals/utils/widgets/cards/music.dart';
import 'package:devotionals/utils/widgets/cards/musictile.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';

import 'services/my_audio.dart';
// import 'package:video_player/video_player.dart';

final GetIt getIt = GetIt.instance;

class AudioScreen  extends StatefulWidget {
  const AudioScreen({super.key});

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  final _audioService = AudService();
  final _pageController = PageController();

  final _store = DataStore('episodes');
  final Playing _playing = getIt<Playing>();
  final AudioManager audioManager = getIt<AudioManager>();
  List<Episode> episodes = [];

  void getOfflineEpisodes()async{
    final eps = await _store.getList('offline_episodes');
    episodes = eps!.map((e) => Episode.fromMap(e)).toList(growable: false);

    setState(() {
      
    });
  }

  

  void _showPopupMenu(BuildContext context, Offset position, Episode episode) async {
      double yOffset = position.dy - 20.0;
      bool favorite = await audioManager.isFavorited(episode);

  // Ensure the yOffset is non-negative
      yOffset = yOffset < 0 ? 0 : yOffset;
      
      await showMenu(
        context: context,
        position: RelativeRect.fromLTRB(position.dx, yOffset, position.dx + 1, yOffset+ 1),
        items: [
          PopupMenuItem<String>(
            onTap: () async{
             await audioManager.addOrRemoveFavorite(episode);

             setState(() {
               
             });
            },
            value: '',
            child: Row(
              children: [
                Icon(favorite? MdiIcons.heart:MdiIcons.heartOutline, size: 18, color: favorite?Colors.red:null,),
                SizedBox(width: 10,),
                Text(
                  favorite? 'Remove favorite':'Favorite',
                ),
              ],
            ),
          ),


          PopupMenuItem<String>(
            onTap: ()async {
              
            },
            value: '',
            child: Row(
              children: [
                Icon(MdiIcons.playlistPlus, size: 18,),
                SizedBox(width: 10,),
                Text('Add to Playlist'),
              ],
            ),
          ),


          PopupMenuItem<String>(
            onTap: ()async {
              
            },
            value: '',
            child: Row(
              children: [
                Icon(MdiIcons.skipNextOutline, size: 18,),
                SizedBox(width: 10,),
                Text('Play next'),
              ],
            ),
          ),
         
        ],
      );
    }



  @override
  void initState() {
    getOfflineEpisodes();
    super.initState();
  }
  
  final _textController = TextEditingController();
  Map<int, bool> clicked = {0:true, 1:false, 2:false};


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      body: Column(
        children: [
          // SafeArea(child: SizedBox()),
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter,
                image: CachedNetworkImageProvider('https://d3t3ozftmdmh3i.cloudfront.net/production/podcast_uploaded_nologo/2584551/2584551-1615865658313-890f00870f672.jpg')
              ),
              
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  Colors.transparent,
                  Colors.transparent,
                  Colors.white
                ]
              ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: AnimSearchBar(
                      width: MediaQuery.sizeOf(context).width-30, 
                      textController: _textController, 
                      onSuffixTap: (){
                        _textController.clear();
                      }, 
                      onSubmitted: (v){}
                    ),
                  ),
                      
                      
                  Row(
                    children: [
                      SizedBox(width: 10,),
                      Wrap(
                        spacing: 5,
                        children: [
                          TextButton(
                            onPressed: (){
                              _pageController.jumpToPage(0);
                              clicked[0]=true;
                              clicked[1]=clicked[2]=false;

                              setState(() {
                                
                              });
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: clicked[0]!? cricColor[400]: Color.fromARGB(125, 238, 238, 238)
                            ),
                            child: Text('All',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16
                              ),
                            )
                          ),
                      
                          TextButton(
                            onPressed: (){
                              _pageController.jumpToPage(1);
                              clicked[1]=true;
                              clicked[0]=clicked[2]=false;

                              setState(() {
                                
                              });
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: clicked[1]!? cricColor[400]: Color.fromARGB(125, 238, 238, 238)
                            ),
                            child: Text('Favorites',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16
                              ),)
                          ),
                      
                           TextButton(
                            onPressed: (){
                              _pageController.jumpToPage(2);
                              clicked[2]=true;
                              clicked[1]=clicked[0]=false;

                              setState(() {
                                
                              });
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: clicked[2]!? cricColor[400]: Color.fromARGB(125, 238, 238, 238)
                            ),
                            child: Text(
                              'Playlists',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16
                              ),
                            )
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                FutureBuilder(
              future: _audioService.searchPods(),
              initialData: episodes,
              builder: (context, snapshot) {
                if ( snapshot.data == null || snapshot.connectionState == ConnectionState.waiting ||
                snapshot.hasError) {
                  return episodes.isNotEmpty?
                  ListView.builder(
                  itemCount: episodes.length,
                  itemBuilder: (context, index){
                    return InkWell(
                      onTap: ()async{
                        // await Navigator.push(
                        //   context,
                        //   PageTransition(child: MusicPlayerTile(true), type: PageTransitionType.bottomToTop)
                        // );
                      },
                      child: PodcastTile(
                       podcast: episodes[index],
                       index: index,
                       playlist: episodes,
                       trailingAction: (t){
                        _showPopupMenu(context, t.globalPosition, episodes[index]);
                       },


                      ),
                    );
                  },
                ):
                  
                  Column(
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
                          'Oops, Something went wrong'
                       ),
                      )
                    ],
                  );
                }

                List<Map<String,dynamic>> _data = snapshot.data!.map((e) => e.toMap()).toList(growable: false);
                // print(_data);
                _store.insertList('offline_episodes', _data);
                
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index){
                    return InkWell(
                      onTap: ()async{
                        // await Navigator.push(
                        //   context,
                        //   PageTransition(child: MusicPlayerTile(true), type: PageTransitionType.bottomToTop)
                        // );
                      },
                      child: PodcastTile(
                       index: index,
                       podcast: snapshot.data![index],
                       playlist: snapshot.data!,
                       trailingAction: (t){
                        _showPopupMenu(context, t.globalPosition, episodes[index]);
                       },


                      ),
                    );
                  },
                );
              }
            ),


                FutureBuilder(
                  future: audioManager.getFavorites(),
                  builder: (context, snapshot){
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index){
                        return PodcastTile(index: index, podcast: snapshot.data![index], playlist: snapshot.data!);
                      }
                    );
                  }
                )

              ],
            )
          ),

          MiniAudioPlayer()
        ],
      ),

    );
  }
}
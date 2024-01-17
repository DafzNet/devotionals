
import 'package:devotionals/dbs/sembast/generic.dart';
import 'package:devotionals/screens/media/audio/miniplayer.dart';
import 'package:devotionals/utils/widgets/cards/musictile.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:podcast_search/podcast_search.dart';

import 'services/audio.dart';
// import 'package:video_player/video_player.dart';

class AudioScreen  extends StatefulWidget {
  const AudioScreen({super.key});

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  final _audioService = AudioService();

  final _store = DataStore('episodes');
 

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Text(''),
        toolbarHeight: 20,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
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
            
            return ListView.separated(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index){
                return InkWell(
                  onTap: (){
                    // _episode = snapshot.data![index];
      
                    setState(() {
                      
                    });
                  },
                  child: PodcastTile(
                   podcast: snapshot.data![index]
                  ),
                );
              },
      
              separatorBuilder: (context, index) {
                return const SizedBox(height: 5,);
              },
            );
          }
        ),
      ),

    );
  }
}
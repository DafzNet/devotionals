import 'package:devotionals/firebase/dbs/video.dart';
import 'package:devotionals/screens/media/addvod.dart';
import 'package:devotionals/screens/media/player.dart';
import 'package:devotionals/services/youtube_services.dart';
import 'package:devotionals/utils/constants/colors.dart';
import 'package:devotionals/utils/models/vid.dart';
import 'package:devotionals/utils/widgets/cards/video_card.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
// import 'package:video_player/video_player.dart';

class MediaScreen extends StatefulWidget {
  const MediaScreen({super.key});

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {

  // https://www.youtube.com/watch?v=MiN3lUsne5U
  // https://youtu.be/DEoQcmjY-ug

   List<VideoData> vids = [];

  VideoService _vids = VideoService();

  void getVids()async{
    List<VideoData> videos = await _vids.getAllVideoData();

    if (vids != null || videos.isNotEmpty) {
      vids = videos;
    }

    setState(() {
      
    });
  }

  @override
  void initState() {
    super.initState();

    getVids();
  }
  // var title = video.title; // "Scamazon Prime"
  // var author = video.author; // "Jim Browning"
  // var duration = video.duration; // Instance of Duration - 0:19:48.00000

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('Mesages'),
        toolbarHeight: 5,

      ),

      body: DefaultTabController(
        length: 5, // Specify the number of tabs
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 80.0,
                toolbarHeight: 10,
                floating: false,
                pinned: true,
                bottom: TabBar(
                  isScrollable: false,
                  padding: EdgeInsets.all(2),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorColor: cricColor,
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  ),
                  
                  tabs: [
                    Tab(text: 'All'),
                    Tab(text: 'Equip'),
                    Tab(text: 'FoHP'),
                    Tab(text: 'MoH'),
                    Tab(text: 'Audio'),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
               Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ListView.separated(
                    itemCount: vids.length,
                    itemBuilder: (context, index) {
                      return VideoCard(videoId: vids[index].id, vids: vids,);
                    },
                
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 8,);
                    },
                  ),
                ),

              // Content for Tab 2
              Center(
                child: Text('Tab 2 Content'),
              ),

              Center(
                child: Text('Tab 2 Content'),
              ),

              Center(
                child: Text('Tab 2 Content'),
              ),

              Center(
                child: Text('Tab 2 Content'),
              ),
            ],
          ),
        ),
      ),
      
      
      
      
      
      // Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: 5),
      //   child: ListView.separated(
      //     itemCount: vids.length,
      //     itemBuilder: (context, index) {
      //       return VideoCard(videoId: vids[index].id, vids: vids,);
      //     },
      
      //     separatorBuilder: (context, index) {
      //       return SizedBox(height: 8,);
      //     },
      //   ),
      // ),


      floatingActionButton: FloatingActionButton(
        backgroundColor: cricColor,
        onPressed: (){
          Navigator.push(context,
          PageTransition(child: AddVideo(), type: PageTransitionType.bottomToTop));
        },

        child: Icon(
          MdiIcons.uploadOutline,
          color: Colors.white,
        ),
      ),
    );
  }
}
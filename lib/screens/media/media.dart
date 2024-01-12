import 'dart:math';

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
   List<VideoData> equipVids = [];
   List<VideoData> fohpVids = [];
   List<VideoData> mohVids = [];

  final VideoService _vids = VideoService();

  void getVids()async{
    List<VideoData> videos = await _vids.getAllVideoData();

    if (videos.isNotEmpty) {
      vids = videos;
      equipVids = vids.where((element) => element.category.toLowerCase()=='equip').toList();
      fohpVids = vids.where((element) => element.category.toLowerCase()=='fohp' || element.category.toLowerCase()=='fragrance of his presence').toList();
      mohVids= vids.where((element) => element.category.toLowerCase()=='moh' || element.category.toLowerCase()=='matters of the heart').toList();

    }

    setState(() {
      
    });
  }

  final ScrollController _scrollController = ScrollController();
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // Reach the bottom of the list, load more data
        _loadMoreData();
      }
    });

    getVids();
  }

  void _loadMoreData() {
    // Shuffle the existing video list
    vids.shuffle(_random);

    // Add the shuffled list to the end of the current list
    setState(() {
      vids.addAll(List.from(vids));
    });
  }

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
                  padding: const EdgeInsets.all(2),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorColor: cricColor,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  ),
                  
                  tabs: const [
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
                    controller: _scrollController,
                    itemCount: vids.length,
                    itemBuilder: (context, index) {
                      return VideoCard(videoId: vids[index].id, vids: vids,);
                    },
                
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 5,);
                    },
                  ),
                ),

              // Content for Tab 2
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ListView.separated(
                    controller: _scrollController,
                    itemCount: equipVids.length,
                    itemBuilder: (context, index) {
                      return VideoCard(videoId: equipVids[index].id, vids: vids,);
                    },
                
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 5,);
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ListView.separated(
                    controller: _scrollController,
                    itemCount: fohpVids.length,
                    itemBuilder: (context, index) {
                      return VideoCard(videoId: fohpVids[index].id, vids: vids,);
                    },
                
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 5,);
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ListView.separated(
                    controller: _scrollController,
                    itemCount: mohVids.length,
                    itemBuilder: (context, index) {
                      return VideoCard(videoId: mohVids[index].id, vids: vids,);
                    },
                
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 5,);
                    },
                  ),
                ),

              Center(
                child: Text('Tab 2 Content'),
              ),
            ],
          ),
        ),
      ),
      
      

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
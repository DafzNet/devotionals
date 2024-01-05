import 'package:card_loading/card_loading.dart';
import 'package:devotionals/firebase/auth.dart';
import 'package:devotionals/firebase/dbs/user.dart';
import 'package:devotionals/firebase/dbs/video.dart';
import 'package:devotionals/screens/devotional/add_dev.dart';
import 'package:devotionals/screens/devotional/all_devs.dart';
import 'package:devotionals/utils/models/models.dart';
import 'package:devotionals/utils/widgets/cards/devotional.dart';
import 'package:devotionals/utils/widgets/cards/next_event.dart';
import 'package:devotionals/utils/widgets/cards/video_card.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';

import '../../utils/constants/colors.dart';

class HomeScreen extends StatefulWidget {
  final String uid;
  const HomeScreen({
    required this.uid,
    super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final  ScrollController _scrollController = ScrollController();
  bool _isTitleVisible = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      setState(() {
        _isTitleVisible = _scrollController.offset > 100; // Adjust the offset as needed
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 300.0,
              floating: true,
              pinned: true,

              actions: [
                IconButton(onPressed: (){

                }, icon: Icon(
                  MdiIcons.bell,
                  color: Colors.white,
                ))
              ],
              
              flexibleSpace: HomeFlexiblebar(isTitleVisible: _isTitleVisible),
            ),
          ];
        },
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SingleChildScrollView(
            child: Column(
              children: [

                SizedBox(
                  height: 10,
                ),
          
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Latest Video'),
                    TextButton(
                      onPressed: (){
                        Navigator.push(
                          context,
                          PageTransition(child: AllDevotionals(uid: widget.uid,), type: PageTransitionType.fade)
                        );
                      },
                      child: Text('See all')
                    ),
                  ],
                ),
     

                FutureBuilder(
                  future: VideoService().getMostRecentVideos(1),
                  builder: (context, snapshot){
                    if (snapshot.hasError || snapshot.connectionState == ConnectionState.waiting) {
                      return CardLoading(
                        height: 200);
                    }

                    return VideoCard(videoId: snapshot.data!.first.id, vids: []);
                  }),
          
                SizedBox(
                  height: 10,
                ),
          
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('A Word in Due Season'),
                    TextButton(
                      onPressed: (){
                        Navigator.push(
                          context,
                          PageTransition(child: AllDevotionals(uid: widget.uid,), type: PageTransitionType.fade)
                        );
                      },
                      child: Text('See all')
                    ),
                  ],
                ),
          
                SizedBox(
                  height: 10,
                ),
          
                DevotionalCard(
                  model: todayDevetional(),
                  uid: widget.uid,
                ),
          
                
                SizedBox(
                  height: 15,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Next Meetings'),
                    TextButton(
                      onPressed: (){
                        /// `Navigator.push()` is a method in Flutter that allows you to navigate to a
                        /// new screen or page in your app. It takes two parameters: `context` and
                        /// `route`.
                        // Navigator.push(
                        //   context,
                        //   PageTransition(child: AllDevotionals(uid: widget.uid,), type: PageTransitionType.fade)
                        // );
                      },
                      child: Text('See all')
                    ),
                  ],
                ),

                SizedBox(height: 10,),

                NextEventDate(
          
                ),


                SizedBox(
                  height: 10,
                ),
          
                // NextMoHDate(
          
                // ),

                // SizedBox(
                //   height: 10,
                // ),
          
                // NextEquipDate(
          
                // )
          
          
              ],
            ),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
        Navigator.push(
          context,
          PageTransition(child: 
          AddDev(), type: PageTransitionType.bottomToTop)
        );
      }),
    );
  }
}












































class HomeFlexiblebar extends StatefulWidget {
  const HomeFlexiblebar({
    super.key,
    required bool isTitleVisible,
  }) : _isTitleVisible = isTitleVisible;

  final bool _isTitleVisible;

  @override
  State<HomeFlexiblebar> createState() => _HomeFlexiblebarState();
}

class _HomeFlexiblebarState extends State<HomeFlexiblebar> {
  

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      centerTitle: widget._isTitleVisible,
      title: widget._isTitleVisible ? Text('CRIC') : null,
      
      background: Stack(
        alignment: AlignmentDirectional.center,
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/welcome.png',
            fit: BoxFit.cover,
            
          ),
      
          Padding(
            padding: const EdgeInsets.only(left: 0, right: 0, top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 100,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      
                      colors: [
                        Colors.white, 
                        Color.fromARGB(52, 244, 246, 245),
                        Color.fromARGB(43, 238, 233, 233),
                        Color.fromARGB(4, 226, 221, 221),
                        Color.fromARGB(4, 226, 221, 221),   
                        Color.fromARGB(4, 226, 221, 221),                        
                      ])
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Color(0xFFE0E5EC), // Background color
                          borderRadius: BorderRadius.circular(100),
                          
                        ),
                        child: Center(
                          child: Icon(
                            MdiIcons.lightFloodDown,
                            color: Colors.amber,
                            size: 30,
                          ),
                        ),
                      ),


                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Color(0xFFE0E5EC), // Background color
                          borderRadius: BorderRadius.circular(100),
                          
                        ),
                        child: Center(
                          child: Icon(
                            Icons.event_note,
                            color: cricColor,
                            size: 30,
                          ),
                        ),
                      ),

                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Color(0xFFE0E5EC), // Background color
                          borderRadius: BorderRadius.circular(100),
                          
                        ),
                        child: Center(
                          child: Icon(
                            Icons.event_note,
                            color: cricColor,
                            size: 30,
                          ),
                        ),
                      ),
                    ]
                  ),
                )
              ],
            ),
          ),
      
          Center(
            child: Text(
              'Welcome To CRIC',

              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.white
              ),
            ),
          )
        ],
      ),
    );
  }
}
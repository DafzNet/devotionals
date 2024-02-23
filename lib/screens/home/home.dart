import 'package:card_loading/card_loading.dart';
import 'package:devotionals/dbs/sembast/generic.dart';
import 'package:devotionals/firebase/auth.dart';
import 'package:devotionals/firebase/dbs/devs.dart';
import 'package:devotionals/firebase/dbs/user.dart';
import 'package:devotionals/firebase/dbs/video.dart';
import 'package:devotionals/screens/devotional/add_dev.dart';
import 'package:devotionals/screens/devotional/all_devs.dart';
import 'package:devotionals/screens/home/screens/events/event.dart';
import 'package:devotionals/screens/home/screens/letters/letter.dart';
import 'package:devotionals/screens/home/screens/wwa/wwa.dart';
import 'package:devotionals/utils/models/models.dart';
import 'package:devotionals/utils/models/vid.dart';
import 'package:devotionals/utils/widgets/cards/devotional.dart';
import 'package:devotionals/utils/widgets/cards/next_event.dart';
import 'package:devotionals/utils/widgets/cards/video_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
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

  String _lvid = '';

  void _getLatestVid()async{
    if (await latestVidStore.containsKey('latestVidID')) {
      final d = await latestVidStore.get('latestVidID');
      final vd = VideoData.fromMap(d!);
      _lvid = vd.id;

      setState(() {
        
      });
    }

    final latest =await VideoService().getMostRecentVideos(1);
    _lvid = latest.first.id;
    latestVidStore.insert('latestVidID', latest.first.toMap());

    setState(() {
      
    });
  }

  final  ScrollController _scrollController = ScrollController();
  bool _isTitleVisible = false;

  final latestVidStore = DataStore('latestVid');

  @override
  void initState() {
    super.initState();
    _getLatestVid();
    _getDev();

    _scrollController.addListener(() {
      setState(() {
        _isTitleVisible = _scrollController.offset > 100; // Adjust the offset as needed
      });
    });
  }

  DevotionalModel? _model;

  void _getDev()async{
    _model = await DevotionalService().getLastDevotional();
    setState(() {
      
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
              
              flexibleSpace: HomeFlexiblebar(isTitleVisible: _isTitleVisible),
            ),
          ];
        },
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ListView(
            children: [
              const SizedBox(
                height: 10,
              ),

              if(_lvid.isNotEmpty)
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Latest Video'),
                  // TextButton(
                  //   onPressed: (){
                  //     Navigator.push(
                  //       context,
                  //       PageTransition(child: AllDevotionals(uid: widget.uid,), type: PageTransitionType.fade)
                  //     );
                  //   },
                  //   child: Text('See all')
                  // ),
                ],
              ),
     

              
            if(_lvid.isNotEmpty)      
              VideoCard(videoId: _lvid, vids: []),
               

            if(_model != null)...
              [
          
              const SizedBox(
                height: 10,
              ),
          
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('A Word in Due Season'),
                  TextButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        PageTransition(child: AllDevotionals(uid: widget.uid,), type: PageTransitionType.fade)
                      );
                    },
                    child: const Text('See all')
                  ),
                ],
              ),
          
              const SizedBox(
                height: 10,
              ),
          
              DevotionalCard(
                model: _model!,
                uid: widget.uid,
              ),],
          
              
              const SizedBox(
                height: 15,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Next Meetings'),
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
                    child: const Text('See all')
                  ),
                ],
              ),

              const SizedBox(height: 10,),

              const NextEventDate(
          
              ),


              const SizedBox(
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

      floatingActionButton: FloatingActionButton(
        onPressed: ()async{

          await showModalBottomSheet(
            backgroundColor: Color.fromARGB(73, 36, 15, 15),
            shape: RoundedRectangleBorder(),
            barrierColor: cricColor,
            context: context, 
            builder: (BuildContext context){
              return Container(
                padding: EdgeInsets.fromLTRB(2, 15, 2, 0),
                height: 149,

                child: ListView(
                  children: [
                    ListTile(
                      title: Text('Daily Devtional'),
                      onTap: () {
                         Navigator.push(
                          context,
                          PageTransition(child: 
                          const AddDev(), type: PageTransitionType.bottomToTop)
                        );
                      },
                    ),


                    ListTile(
                      title: Text('Verse of the Day'),
                      onTap: () {
                         Navigator.push(
                          context,
                          PageTransition(child: 
                          const AddDev(), type: PageTransitionType.bottomToTop)
                        );
                      },
                    )
                  ],
                ),
              );
            }
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
      title: widget._isTitleVisible ? const Text('CRIC') : null,
      
      background: Stack(
        alignment: AlignmentDirectional.center,
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/welcome.png',
            fit: BoxFit.cover,
            
          ),


          SizedBox(
            height: 100,
            child: CardSwiper(
              padding: EdgeInsets.zero,
              cardBuilder: (context, index, x, y){
                return Image.asset(
                  'assets/images/welcome.png',
                  fit: BoxFit.cover,
                );
              },
              cardsCount: 5
            ),
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
                      InkWell(
                        onTap: (){
                          Navigator.push(
                            context,
                            PageTransition(
                              child: const WWANavigation(), type: PageTransitionType.fade)
                          );
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: cricColor, // Background color
                            borderRadius: BorderRadius.circular(100),
                            
                          ),
                          child: Center(
                            child: Icon(
                              MdiIcons.lightbulbOn10,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ),


                      InkWell(
                        onTap: (){
                          Navigator.push(
                            context,
                            PageTransition(
                              child: const EventNavigation(), type: PageTransitionType.fade)
                          );
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: cricColor, // Background color
                            borderRadius: BorderRadius.circular(100),
                            
                          ),
                          child: Center(
                            child: Icon(
                              MdiIcons.calendarMultiple,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ),

                      InkWell(
                        onTap: (){
                          Navigator.push(
                            context,
                            PageTransition(
                              child: const Letters(), type: PageTransitionType.fade)
                          );
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: cricColor, // Background color
                            borderRadius: BorderRadius.circular(100),
                            
                          ),
                          child: Center(
                            child: Icon(
                              MdiIcons.emailNewsletter,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ]
                  ),
                )
              ],
            ),
          ),
      
          const Center(
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
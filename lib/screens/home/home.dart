import 'package:devotionals/firebase/auth.dart';
import 'package:devotionals/firebase/dbs/user.dart';
import 'package:devotionals/screens/devotional/add_dev.dart';
import 'package:devotionals/screens/devotional/all_devs.dart';
import 'package:devotionals/utils/models/models.dart';
import 'package:devotionals/utils/widgets/cards/devotional.dart';
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
              
              flexibleSpace: HomeFlexiblebar(isTitleVisible: _isTitleVisible),
            ),
          ];
        },
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [

              SizedBox(
                height: 20,
              ),
              DevotionalCard(
                model: todayDevetional(),
              ),

              TextButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    PageTransition(child: AllDevotionals(), type: PageTransitionType.fade)
                  );
                },
                child: Text('All Devotionals')
              ),
            ],
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
            'assets/images/adwf.png',
            fit: BoxFit.cover,
            
          ),
      
          Padding(
            padding: const EdgeInsets.only(left: 0, right: 0, top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      
                      colors: [
                        cricColor, 
                        Color.fromARGB(52, 18, 107, 57),
                        Color.fromARGB(43, 0, 0, 0),
                        Color.fromARGB(23, 0, 0, 0),                        
                      ])
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100)
                        )
                      ),


                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Color(0xFFE0E5EC), // Background color
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              offset: Offset(-3, -3),
                              blurRadius: 3,
                            ),
                            BoxShadow(
                              color: Color(0xFFB0B5C1),
                              offset: Offset(3, 3),
                              blurRadius: 3,
                            ),
                          ],
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
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100)
                        )
                      )
                    ]
                  ),
                )
              ],
            ),
          ),
      
          Icon(
            MdiIcons.playCircle,
            color: Colors.white,
            size: 50,
          )
        ],
      ),
    );
  }
}
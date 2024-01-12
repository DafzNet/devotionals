import 'package:devotionals/firebase/dbs/user.dart';
import 'package:devotionals/screens/chat/chat.dart';
import 'package:devotionals/screens/media/media.dart';
import 'package:devotionals/screens/profile/profile.dart';
import 'package:devotionals/utils/models/models.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../utils/constants/constants.dart';
import 'home/home.dart';


class AppBaseNavigation extends StatefulWidget {
  final String uid;
  const AppBaseNavigation({
    required this.uid,
    super.key});

  @override
  State<AppBaseNavigation> createState() => _AppBaseNavigationState();
}

class _AppBaseNavigationState extends State<AppBaseNavigation> with WidgetsBindingObserver {

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      // App is in the foreground
      UserService().setPresence(widget.uid, true);
    } else {
      // App is in the background or inactive
      UserService().setPresence(widget.uid, false);
    }
  }

  List<Widget> _pages = [
    Container(),
    Container(),
    const Center(child: Text('3rd Screen')),
    const Center(child: Text('4th Screen')),
  ];

  int _currentIndex = 0;



  void getCurrentPage(index){
    _currentIndex = index;
    setState(() {
      
    });
  }

  final pageController = PageController();

  @override
  void initState() {
    _pages = [
    HomeScreen(uid: widget.uid,),
    ChatScreen(uid: widget.uid,),
    MediaScreen(),
    Profile(user: widget.uid),
  ];
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: PageView(
        controller: pageController,
        onPageChanged: (int value){
          setState(() {
            _currentIndex = value;
          });
        },
        children: _pages,
      ),

      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: const Color.fromARGB(197, 39, 39, 39),
        selectedItemColor: cricColor.shade600,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        elevation: 0,
        type: BottomNavigationBarType.fixed,

        //backgroundColor: Color(0xffFAFAFF),
        currentIndex: _currentIndex,
        onTap: (index){
          getCurrentPage(index);

          pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.bounceIn
          );

          setState(() {
            
          });
        },
      
        items:  [
          
          BottomNavigationBarItem(
            icon: Icon(
              MdiIcons.homeOutline
            ),
      
            activeIcon: Icon(
              MdiIcons.home
            ),
      
            label: 'Home'
          ),


          /////Chat
          BottomNavigationBarItem(
            icon: Icon(
              MdiIcons.chatOutline
            ),
      
            activeIcon: Icon(
              MdiIcons.chat
            ),
      
            label: 'Chats'
          ),


          /////Chat
          BottomNavigationBarItem(
            icon: Icon(
              MdiIcons.playBoxMultipleOutline
            ),
      
            activeIcon: Icon(
              MdiIcons.playBoxMultiple
            ),
      
            label: 'Messages'
          ),

          BottomNavigationBarItem(
            icon: Icon(
              MdiIcons.accountCircleOutline
            ),
      
            activeIcon: Icon(
              MdiIcons.accountCircle
            ),
      
            label: 'More'
          ),
          
        ]
      ),
    );

  }
}
import 'package:devotionals/firebase/dbs/user.dart';
import 'package:devotionals/screens/home/screens/wwa/mission.dart';
import 'package:devotionals/screens/home/screens/wwa/ncc.dart';
import 'package:devotionals/utils/constants/colors.dart';
import 'package:devotionals/utils/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'vision.dart';

class WWANavigation extends StatefulWidget {
  const WWANavigation({
    super.key});

  @override
  State<WWANavigation> createState() => _WWANavigationState();
}

class _WWANavigationState extends State<WWANavigation> with WidgetsBindingObserver {

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  List<Widget> _pages = [
    Vision(),
    Mission(),
    NewCreationCreed()
  ];

  int _currentIndex = 0;
  Widget? _currentWidget;



  void getCurrentPage(index){
    _currentIndex = index;
    _currentWidget = _pages[_currentIndex];
    
    setState(() {
      
    });
  }

  final pageController = PageController();
  

  @override
  void initState() {
    _currentWidget = Vision();
  //   _pages = [
    
  // ];
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  final _controller = PageController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(


      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(logo),
            fit: BoxFit.contain,
            opacity: .3
          )
        ),
        child: PageView.builder(
          itemCount: _pages.length,
          controller: _controller,
          onPageChanged: (value) {
            getCurrentPage(value);
          },
          itemBuilder: (context, index){
            return _currentWidget;
          }),
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
          _controller.animateToPage(index, duration: Duration(milliseconds: 100), curve: Curves.bounceIn);

          setState(() {
            
          });
        },
      
        items:  [
          
          BottomNavigationBarItem(
            icon: Icon(
              MdiIcons.lightbulbOutline
            ),
      
            activeIcon: Icon(
              MdiIcons.lightbulb
            ),
      
            label: 'Vision'
          ),


          /////Chat
          BottomNavigationBarItem(
            icon: Icon(
              MdiIcons.runFast
            ),
      
            activeIcon: Icon(
              MdiIcons.runFast
            ),
      
            label: 'Mission'
          ),


          BottomNavigationBarItem(
            icon: Icon(
              MdiIcons.earth
            ),
      
            activeIcon: Icon(
              MdiIcons.earth
            ),
      
            label: 'New Creation'
          ),
          
          
        ]
      ),
    );

  }
}
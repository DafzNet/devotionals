import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Mission extends StatefulWidget {
  const Mission({super.key});

  @override
  State<Mission> createState() => _MissionState();
}

class _MissionState extends State<Mission> {
  @override
  Widget build(BuildContext context) {
   return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.transparent,

        appBar: AppBar(
            title: Text('Mission'),
            bottom: TabBar(
              tabs: [
                Tab(text: 'Localized Mission'),
                Tab(text: 'Globalized Mission'),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TabBarView(
              children: [
                Text(
                  'To reach every Individual in this World with the Gospel in Order to raise fully functioning followers of Christ in every Nation.',
                
                  style: TextStyle(
                    height: 2,
                  ),
                ),
                Text(
                  'To reach the world with the gospel in order to raise a people who are like Jesus.',
                
                style: TextStyle(
                  height: 2,

                ),
                ),
          
                
              ],
            ),
          ),
        ),
    );
  }
}
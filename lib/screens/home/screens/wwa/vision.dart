import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Vision extends StatefulWidget {
  const Vision({super.key});

  @override
  State<Vision> createState() => _VisionState();
}

class _VisionState extends State<Vision> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.transparent,

        appBar: AppBar(
            title: Text('Vision'),
            bottom: TabBar(
              tabs: [
                Tab(text: 'Localized Vision'),
                Tab(text: 'Globalized Vision'),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TabBarView(
              children: [
                Text(
                  'As we preach the full message of this new life, our goal is to raise a people who are like Jesus by exposing them to the influence of God’s word and His Spirit in an atmosphere of LOVE so that they may be able to take the LOVE of God, the WORD of God and the HEALING POWER of God to every individual within their sphere of contact.',
                
                style: TextStyle(
                  height: 2,

                ),
                ),
          
                Text(
                  'To take the LOVE of GOD, the WORD of GOD and the HEALING POWER of GOD to every INDIVIDUAL, every HOME, every CITY, every STATE, every NATION, every CONTINENT, everyday through every available means.',
                
                style: TextStyle(
                  height: 2,
                ),
                )
              ],
            ),
          ),
        ),
    );
  }
}
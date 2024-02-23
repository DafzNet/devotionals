import 'package:devotionals/utils/constants/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Letters extends StatefulWidget {
  const Letters({super.key});

  @override
  State<Letters> createState() => _LettersState();
}

class _LettersState extends State<Letters> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2, // Specify the number of tabs
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 50.0,
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
                  
                  tabs: [
                    Tab(text: 'Letters'),
                    Tab(text: 'Prayers'),
                    // Tab(text: 'Audio'),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [

            ],
          )
        )
      )
    );
  }
}
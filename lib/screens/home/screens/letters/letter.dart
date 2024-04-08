import 'package:devotionals/dbs/sembast/generic.dart';
import 'package:devotionals/firebase/dbs/letters.dart';
import 'package:devotionals/utils/constants/colors.dart';
import 'package:devotionals/utils/models/dailyverse.dart';
import 'package:devotionals/utils/models/letters.dart';
import 'package:devotionals/utils/widgets/click_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class MyLetters extends StatefulWidget {
  const MyLetters({super.key});

  @override
  State<MyLetters> createState() => _MyLettersState();
}

class _MyLettersState extends State<MyLetters> {

  
  final votd = ApostleLettersFirestoreService();
  DataStore _store = DataStore('letters');

  List<Letters> myletters = [];
  List<Letters> prayers = [];



  _getLetters()async{
    try{
      final letters =  await votd.getAllLetters();
      final _vs = letters
      .map((e) => e.toMap()).toList();
      _store.insertList('myLetters', _vs);

      for (var e in letters) {
        if (e.type=='letter'){
          myletters.add(e);
        } else {
          prayers.add(e);
        }
      }
    }catch(e){
      final _letters =await _store.getList('myLetters');

      if (_letters!.isNotEmpty) {
        final letters = _letters!.map((e) => Letters.fromMap(e)).toList();

        for (var e in letters) {
        if (e.type=='letter'){
          myletters.add(e);
        } else {
          prayers.add(e);
        }
      }

      }
    }

    setState(() {
      
    });
  }

  @override
  void initState() {
    _getLetters();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2, // Specify the number of tabs
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                toolbarHeight: 30,
                expandedHeight: 50.0,
                floating: false,
                pinned: true,
                bottom: TabBar(
                  isScrollable: false,
                  physics: NeverScrollableScrollPhysics(),
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
          body: Padding(
            padding: const EdgeInsets.all(12),
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                if(myletters.isNotEmpty)...[
                Column(
                  children: [
                    
                    Expanded(
                      child: CardSwiper(
                        padding: EdgeInsets.zero,
                        allowedSwipeDirection: AllowedSwipeDirection.only(right: true, left: true),
                        cardsCount: myletters.length,
                        numberOfCardsDisplayed: 1,
                        cardBuilder: (context, index, x, y){
                          return SingleChildScrollView(
                            child: ClickableText(
                               text:  myletters[index].text,
                               context: context,
                            ),
                          );
                        }
                      ),
                    )
                  ],
                )]else...[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    
                    Center(
                      child: Text(
                         'No Letters to show here',
                      ),
                    )
                  ],
                )
                ],

                if(prayers.isNotEmpty) ...[
                Column(
                  children: [
                    
                    Expanded(
                      child: CardSwiper(
                        padding: EdgeInsets.zero,
                        allowedSwipeDirection: AllowedSwipeDirection.only(right: true, left: true),
                        cardsCount: prayers.length,
                        numberOfCardsDisplayed: 1,
                        cardBuilder: (context, index, x, y){
                          return SingleChildScrollView(
                            child: ClickableText(
                               text:  prayers[index].text,
                               context: context,
                            ),
                          );
                        }
                      ),
                    )
                  ],
                )]else...[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    
                    Center(
                      child: Text(
                         'No prayers to show here'
                      ),
                    )
                  ],
                )
                ]
              ],
            ),
          )
        )
      )
    );
  }
}
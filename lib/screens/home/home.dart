// ignore_for_file: prefer_final_fields, no_leading_underscores_for_local_identifiers

import 'package:devotionals/dbs/sembast/generic.dart';
import 'package:devotionals/firebase/dbs/devs.dart';
import 'package:devotionals/firebase/dbs/prayerrequest.dart';
import 'package:devotionals/screens/devotional/add_dev.dart';
import 'package:devotionals/screens/devotional/all_devs.dart';
import 'package:devotionals/screens/home/screens/adders/cell.dart';
import 'package:devotionals/screens/home/screens/adders/sod.dart';
import 'package:devotionals/screens/home/screens/events/event.dart';
import 'package:devotionals/screens/home/screens/letters/add.dart';
import 'package:devotionals/screens/home/screens/letters/letter.dart';
import 'package:devotionals/screens/home/screens/request/acceptreq.dart';
import 'package:devotionals/screens/home/screens/request/allreq.dart';
import 'package:devotionals/screens/home/screens/tv.dart';
import 'package:devotionals/screens/home/screens/wwa/wwa.dart';
import 'package:devotionals/utils/constants/constants.dart';
import 'package:devotionals/utils/models/dailyverse.dart';
import 'package:devotionals/utils/models/models.dart';
import 'package:devotionals/utils/models/prayerreq.dart';
import 'package:devotionals/utils/widgets/cards/devotional.dart';
import 'package:devotionals/utils/widgets/cards/next_event.dart';
import 'package:devotionals/utils/widgets/cards/req.dart';
import 'package:devotionals/utils/widgets/tvbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import '../../firebase/dbs/verseoftheday.dart';
import 'screens/adders/department.dart';
import 'screens/events/addevents.dart';
import 'screens/request/addprayerreq.dart';

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
  final prayerStore = DataStore('requests');
  List<Map<String, dynamic>>? storePrayers;

  @override
  void initState() {
    super.initState();
    _getDev();
    _getReqs();

    _scrollController.addListener(() {
      setState(() {
        _isTitleVisible = _scrollController.offset > 100; // Adjust the offset as needed
      });
    });
  }

  DevotionalModel? _model;

  void _getReqs()async{
    final _all = await prayerStore.getList('prayers');
    storePrayers = _all??[];
    setState(() {
      
    });
  }

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
              expandedHeight: 330.0,
              floating: true,
              pinned: true,
              leading: Image.asset(
                logo,
                width: 20,
                height: 20,
              ),

              actions: [

                LiveTVButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      PageTransition(
                        child: LiveTv(),
                        type: PageTransitionType.fade)
                    );
                  },
                  buttonText: 'NVTv',
                ),

                TextButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      PageTransition(
                        child: AddPrayerRequestScreen(widget.uid),
                        type: PageTransitionType.fade)
                    );
                  },
                  
                  child: Text(
                    'Pray for Me',
                    style: TextStyle(
                      color: _isTitleVisible?Colors.grey[800]:Colors.white
                    ),
                  )
                )
              ],
              
              flexibleSpace: HomeFlexiblebar(widget.uid, isTitleVisible: _isTitleVisible),
            ),
          ];
        },
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ListView(
            children: [
              FutureBuilder(
                future: PrayerFire().getPrayerRequests(),
                builder: (context, snapshot) {
              
                  if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty || snapshot.connectionState == ConnectionState.waiting){
                    
                    if (storePrayers!=null && storePrayers!.isNotEmpty) {
                      final _myPrayers = storePrayers!.map((e) => PrayerRequest.fromMap(e)).toList();
              
                      return SizedBox(
                        height: 245,
                        child: Column(
                          children: [
                            Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Prayer Request'),
                            TextButton(
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  PageTransition(child: AllPrayerRequests(widget.uid,), type: PageTransitionType.fade)
                                );
                              },
                              child: const Text('See all')
                            ),
                          ],
                        ),
                            SizedBox(
                              height: 193,
                              child: CardSwiper(
                                padding: EdgeInsets.zero,
                                cardsCount:  _myPrayers.length,
                                numberOfCardsDisplayed: 1,
                                cardBuilder: (context, index, x, y){
                                  return PrayerRequestCard(
                                    uid: widget.uid,
                                    req: _myPrayers[index],
                                    
                                  );
                                }
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return Container();             
                  }
              
                  final _data = snapshot.data;
                  print(_data);
              
                  prayerStore.insertList('prayers', List<Map<String, dynamic>>.from(_data!.map((e) =>e.toMap()).toList()));
              
                  return SizedBox(
                    height: 245,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Prayer Request'),
                            TextButton(
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  PageTransition(child: AllPrayerRequests(widget.uid,), type: PageTransitionType.fade)
                                );
                              },
                              child: const Text('See all')
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 193,
                          child: CardSwiper(
                            padding: EdgeInsets.zero,
                            cardsCount:  _data.length,
                            numberOfCardsDisplayed: 1,
                            cardBuilder: (context, index, x, y){
                              return PrayerRequestCard(
                                uid: widget.uid,
                                req: _data[index],
                                
                              );
                            }
                          ),
                        ),
                      ],
                    ),
                  );
                }
              ),

              const SizedBox(
                height: 10,
              ),

               

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
        child: Icon(
          MdiIcons.plus,
          color: Colors.white,
        ),

        backgroundColor: cricColor,
        onPressed: ()async{

          await showModalBottomSheet(
            backgroundColor: const Color.fromARGB(73, 36, 15, 15),
            context: context, 
            builder: (BuildContext context){
              return Container(
                padding: const EdgeInsets.fromLTRB(2, 15, 2, 0),
                

                height: 450,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    20
                  )
                ),


                child: ListView(
                  children: [
                    ListTile(
                      title: const Text('Daily Devtional'),
                      trailing: Icon(
                        MdiIcons.plus
                      ),
                      onTap: () {
                        Navigator.pop(context);
                         Navigator.push(
                          context,
                          PageTransition(child: 
                          const AddDev(), type: PageTransitionType.bottomToTop)
                        );
                      },
                    ),


                    ListTile(
                      title: const Text('Word for the Day'),
                      trailing: Icon(
                        MdiIcons.plus
                      ),
                      onTap: () {
                        Navigator.pop(context);
                         Navigator.push(
                          context,
                          PageTransition(child: 
                          const ScriptureOftheDay(), type: PageTransitionType.bottomToTop)
                        );
                      },
                    ),


                    ListTile(
                      title: const Text('Apostle Letter'),
                      trailing: Icon(
                        MdiIcons.plus
                      ),
                      onTap: () {
                        Navigator.pop(context);
                         Navigator.push(
                          context,
                          PageTransition(child: 
                          const AddLetter(), type: PageTransitionType.bottomToTop)
                        );
                      },
                    ),


                    ListTile(
                      title: const Text('Event'),
                      trailing: Icon(
                        MdiIcons.plus
                      ),
                      onTap: () {
                        Navigator.pop(context);
                         Navigator.push(
                          context,
                          PageTransition(child: 
                          const AddEvent(), type: PageTransitionType.bottomToTop)
                        );
                      },
                    ),



                    ListTile(
                      title: const Text('Cell'),
                      trailing: Icon(
                        MdiIcons.plus
                      ),
                      onTap: () {
                        Navigator.pop(context);
                         Navigator.push(
                          context,
                          PageTransition(child: 
                          const AddCell(), type: PageTransitionType.bottomToTop)
                        );
                      },
                    ),


                    ListTile(
                      title: const Text('Department'),
                      trailing: Icon(
                        MdiIcons.plus
                      ),
                      onTap: () {
                        Navigator.pop(context);
                         Navigator.push(
                          context,
                          PageTransition(child: 
                          const AddDepartment(), type: PageTransitionType.bottomToTop)
                        );
                      },
                    ),


                    ListTile(
                      title: const Text('Accept Prayer Request'),
                      trailing: Icon(
                        MdiIcons.plus
                      ),
                      onTap: () {
                        Navigator.pop(context);
                         Navigator.push(
                          context,
                          PageTransition(child: 
                          PendingPrayerRequests(widget.uid), type: PageTransitionType.bottomToTop)
                        );
                      },
                    ),
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
  final String uid;
  const HomeFlexiblebar(
    this.uid,{
    super.key,
    required bool isTitleVisible,
  }) : _isTitleVisible = isTitleVisible;

  final bool _isTitleVisible;

  @override
  State<HomeFlexiblebar> createState() => _HomeFlexiblebarState();
}

class _HomeFlexiblebarState extends State<HomeFlexiblebar> {



  final votd = VerseofDayFirestoreService();
  DataStore _store = DataStore('dailyverse');

  List<DailyVerse> verses = [DailyVerse(id: '12', verseText: 'Word for the day loading...', reference: '', date: DateTime.now())];



  _getVofDay()async{
    try{
      verses =  await votd.getAllDailyVerses();
      final _vs = verses
      .map((e) => e.toMap()).toList();
      _store.insertList('myverses', _vs);
    }catch(e){
      final _verses =await _store.getList('myverses');
      if (_verses!.isNotEmpty) {
        verses = _verses.map((e) => DailyVerse.fromMap(e)).toList();
      } else {
         verses = [DailyVerse(id: '12', verseText: 'Scripture of the day', reference: '', date: DateTime.now())];

      }
    }

    setState(() {
      
    });
  }

  @override
  void initState() {
    _getVofDay();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      title: widget._isTitleVisible ? const Text('CRIC') : null,
      
      background: Stack(
        alignment: AlignmentDirectional.center,
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/welcome.png',
            fit: BoxFit.cover,
            
          ),


          Container(
            color: const Color.fromARGB(150, 0, 0, 0)
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
                        Color.fromARGB(103, 34, 34, 34), 
                        Color.fromARGB(123, 3, 3, 3),
                        Color.fromARGB(43, 12, 9, 9), 
                        Color.fromARGB(3, 10, 8, 8),                    
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
                              child: AllDevotionals(uid: widget.uid,), type: PageTransitionType.fade)
                          );
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: cricColor.shade100, // Background color
                            borderRadius: BorderRadius.circular(100),
                            
                          ),
                          child: Center(
                            child: Icon(
                              MdiIcons.bookOpenPageVariantOutline,
                              color: cricColor.shade800,
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
                              child: const WWANavigation(), type: PageTransitionType.fade)
                          );
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: cricColor.shade100, // Background color
                            borderRadius: BorderRadius.circular(100),
                            
                          ),
                          child: Center(
                            child: Icon(
                              MdiIcons.lightbulbOn10,
                              color: cricColor.shade800,
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
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: cricColor.shade100,// Background color
                            borderRadius: BorderRadius.circular(100),
                            
                          ),
                          child: Center(
                            child: Icon(
                              MdiIcons.calendarMultiple,
                              color: cricColor.shade800,
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
                              child: const MyLetters(), type: PageTransitionType.fade)
                          );
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: cricColor.shade100, // Background color
                            borderRadius: BorderRadius.circular(100),
                            
                          ),
                          child: Center(
                            child: Icon(
                              MdiIcons.bookOutline,
                              color: cricColor.shade800,
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
      
          Center(
            child: SizedBox(
            height: 200,
            child: CardSwiper(
              padding: EdgeInsets.zero,
              numberOfCardsDisplayed: 1,
              cardBuilder: (context, index, x, y){
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(

                    children: [

                      const SizedBox(height: 10,),
                      
                      Center(
                        child: Text(
                          verses[index].verseText,
                          textAlign: TextAlign.center,
                        
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white
                          ),
                        ),
                      ),

                      const SizedBox(height: 10,),

                      


                      Text(
                          verses[index].reference,
                          textAlign: TextAlign.center,
                        
                          style: TextStyle(
                            fontSize: 15,
                            backgroundColor: cricColor.shade50,
                            fontWeight: FontWeight.w600,
                            color: cricColor.shade800
                          ),
                        ),

                        const SizedBox(height: 5,),

                        Text(
                          DateFormat.yMMMEd().format(verses[index].date),
                          textAlign: TextAlign.center,
                        
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: cricColor.shade50
                          ),
                        ),

                        
                      
                    ],
                  ),
                );
              },
              cardsCount: verses.length
            ),
          ),
            
            
            
            // Text(
            //   'Welcome To CRIC',

            //   style: TextStyle(
            //     fontSize: 24,
            //     fontWeight: FontWeight.w600,
            //     color: Colors.white
            //   ),
            // ),
          )
        ],
      ),
    );
  }
}
import 'dart:io';

import 'package:devotionals/utils/constants/constants.dart';
import 'package:devotionals/utils/models/devotional.dart';
import 'package:devotionals/utils/widgets/click_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';

import '../profile/screens/notes/note_taker.dart';

class DevotionalDetailScreen extends StatefulWidget {
  final DevotionalModel model;
  const DevotionalDetailScreen(
    {
      required this.model,
      super.key});

  @override
  State<DevotionalDetailScreen> createState() => _DevotionalDetailScreenState();
}

class _DevotionalDetailScreenState extends State<DevotionalDetailScreen> {

  final  ScrollController _scrollController = ScrollController();
  bool _isTitleVisible = false;
  double devotionalFontSize = 14;
  Color bgColor = Colors.white;
  Color fontColor = Colors.black;

  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  String? _newVoiceText;
  int? _inputLength;


  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isWindows => !kIsWeb && Platform.isWindows;
  bool get isWeb => kIsWeb;

  initTts() {
    flutterTts = FlutterTts();

    if (isAndroid) {
      _getDefaultEngine();
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
      });
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        print("Cancel");
      });
    });

    flutterTts.setPauseHandler(() {
      setState(() {
        print("Paused");
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
      });
    });
  }

  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future<dynamic> _getEngines() async => await flutterTts.getEngines;

  Future _getDefaultEngine() async {
    var engine = await flutterTts.getDefaultEngine;
    if (engine != null) {
      print(engine);
    }
  }

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  bool _isPlaying = false;

  Future _speak() async {
    await flutterTts.setVolume(1);
    await flutterTts.setSpeechRate(0.3);
    await flutterTts.setPitch(0.8);



    await flutterTts.speak(
     widget.model.instruction != null && widget.model.instruction!.length>5?"topic: "+widget.model.title+
      "... opening scripture... "+widget.model.openingScriptureReference+"... "+widget.model.openingScriptureText+
      ".............."+widget.model.body+
      '.......instruction.......'+widget.model.instruction!+
      '..........further scriptures....'+widget.model.furtherScriptures!+
      '.......doing the word.......'+widget.model.doingTheWord!+
      '......daily scripture reading........'+widget.model.dailyScriptureReading!:

      widget.model.confession != null && widget.model.confession!.length>5?"topic: "+widget.model.title+
      "... opening scripture... "+widget.model.openingScriptureReference+"... "+widget.model.openingScriptureText+
      ".............."+widget.model.body+
      '..... Confession.........'+widget.model.confession!+
      '.........further scriptures.....'+widget.model.furtherScriptures!+
      '......doing the word........'+widget.model.doingTheWord!+
      '........daily scripture reading......'+widget.model.dailyScriptureReading!:

      "topic: "+widget.model.title+
      "... opening scripture... "+widget.model.openingScriptureReference+"... "+widget.model.openingScriptureText+
      ".............."+widget.model.body+
      '.......prayer.......'+widget.model.prayer!+
      '.........further scriptures.....'+widget.model.furtherScriptures!+
      '.....doing the word.........'+widget.model.doingTheWord!+
      '.....daily scripture reading.........'+widget.model.dailyScriptureReading!
    );

    setState(() {
      _isPlaying = true;
    });
  }




  double _height=300;


  @override
  void initState() {
    super.initState();
    
    initTts();
    _scrollController.addListener(() {
      setState(() {
        _isTitleVisible = _scrollController.offset > 100; // Adjust the offset as needed
      });
    });
  }

  @override
  Widget build(BuildContext context){
    
    return Scaffold(

      backgroundColor: bgColor,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar.medium(
              backgroundColor: bgColor,
              floating: true,
              pinned: true,
              title: Text(widget.model.title),

              actions: [
                IconButton(
                  onPressed: ()async{
                    await _speak();

                    await showModalBottomSheet(
                      isDismissible: false,
                      context: context, 
                      builder: (ctx){

                        return Container(
                          height: 250,

                          child: Stack(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      IconButton(
                                        onPressed: ()async{
                                          _isPlaying? await flutterTts.pause():await _speak();
                                            
                                          setState(() {
                                            _isPlaying = !_isPlaying;
                                          });
                                        }, 
                                        icon: Icon(
                                          _isPlaying? MdiIcons.pause:MdiIcons.play,
                                          size: 40,
                                          color: cricColor,
                                        )
                                      )
                                    ],
                                  ),                                  
                                ],
                              ),

                              Positioned(
                                right: 5,
                                top: 5,
                                child: IconButton(
                                  onPressed: ()async{
                                    await flutterTts.stop();
                                    Navigator.pop(ctx);}, 
                                  icon: Icon(
                                    MdiIcons.close
                                  ))
                              )
                            ],
                          ),
                        );
                      }
                    );
                  }, 
                  icon: Icon(
                    MdiIcons.headset
                  )
                ),
                IconButton(
                  onPressed: ()async{
                    await showModalBottomSheet(
                      context: context, 
                      builder: (ctx){
                        return Container(
                          padding: EdgeInsets.all(15),
                          height: MediaQuery.of(context).size.height/2.5,
                          decoration: BoxDecoration(

                          ),

                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Font Size',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),

                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: (){
                                          if (devotionalFontSize > 10) {
                                            devotionalFontSize -= 2;
                                            setState(() {
                                              
                                            });
                                          }
                                        },
                                        icon: Icon(
                                          MdiIcons.minusCircleOutline
                                        )),

                                      IconButton(
                                        onPressed: (){
                                          if (devotionalFontSize < 24) {
                                            devotionalFontSize += 2;
                                            setState(() {
                                              
                                            });
                                          }
                                        },
                                        icon: Icon(
                                          MdiIcons.plusCircleOutline
                                        )),
                                    ],
                                  )
                                ],
                              ),

                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Background Color',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ],
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: (){
                                            bgColor = cricColor;

                                            setState(() {
                                              
                                            });
                                          },
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: cricColor,
                                              borderRadius: BorderRadius.circular(5)
                                            ),
                                          )
                                        ),
                                                                    
                                                                    
                                        GestureDetector(
                                          onTap: (){
                                            bgColor = Colors.black;

                                            setState(() {
                                              
                                            });
                                          },
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius: BorderRadius.circular(5)
                                            ),
                                          )
                                        ),
                                                                    
                                                                    
                                        GestureDetector(
                                          onTap: (){
                                            bgColor = Colors.white;

                                            setState(() {
                                              
                                            });
                                          },
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(width: .2),
                                              borderRadius: BorderRadius.circular(5)
                                            ),
                                          )
                                        ),
                                                                    
                                                                    
                                        GestureDetector(
                                          onTap: (){
                                            bgColor = Colors.amber;

                                            setState(() {
                                              
                                            });
                                          },
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.amber,
                                              borderRadius: BorderRadius.circular(5)
                                            ),
                                          )
                                        ),
                                                                    
                                                                    
                                        GestureDetector(
                                          onTap: (){
                                            bgColor = Colors.blue;

                                            setState(() {
                                              
                                            });
                                          },
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius: BorderRadius.circular(5)
                                            ),
                                          )
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        );
                      });
                  }, icon: const Icon(Icons.settings)
                )
              ],
              
              
            ),
          ];
        },
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Text(
                              widget.model.openingScriptureText,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: devotionalFontSize
                              ),
                            ),
                          ),


                          Padding(
                            padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                            child: Text(
                              widget.model.openingScriptureReference,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: devotionalFontSize
                              ),
                            ),
                          )
                        ],
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10,),
                      child: ClickableText(
                        context: context,
                        text: widget.model.body,

                        defaultTextStyle: TextStyle(
                          fontSize: devotionalFontSize,
                          color: Colors.black,
                          height: 1.5
                        ),

                        matchTextStyle: TextStyle(
                          fontSize: devotionalFontSize,
                          color: Colors.black,
                          decorationStyle: TextDecorationStyle.dotted,
                          decorationColor: Colors.black,

                          height: 1.5
                        ),
                        // onTap: (p0) {
                        //   BibleReference r = parseBibleReference(p0);
                        //   print(r);
                        // },
                        // textAlign: TextAlign.left,
                        // style: TextStyle(
                        //   height: 1.8
                        // ),
                      ),
                    ),

                    

                    if(widget.model.instruction != null && widget.model.instruction!.length>5)...[
                      const SizedBox(
                        height: 10,
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 10,),
                        child: Row(
                          children: [
                            Text(
                              'Instruction',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                height: 1.5,
                                fontSize: devotionalFontSize*1.3,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 10,),
                        child: Row(
                          children: [
                            Expanded(
                              child: ClickableText(
                                text: widget.model.instruction!,
                                context: context,
                                defaultTextStyle: TextStyle(
                                fontSize: devotionalFontSize,
                                color: Colors.black,
                                height: 1.5
                              ),
                            
                              matchTextStyle: TextStyle(
                                fontSize: devotionalFontSize,
                                color: Colors.black,
                                decorationStyle: TextDecorationStyle.dotted,
                                decorationColor: Colors.black,
                            
                                height: 1.5
                              ),
                                // onTap: (p0) {
                                //   print(p0);
                                // },
                                // textAlign: TextAlign.left,
                                // style: TextStyle(
                                //   height: 1.8
                                // ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    ////////////////////////////////////
                    /////////////////////////////////////

                    if(widget.model.confession != null && widget.model.confession!.length>5)...[
                      const SizedBox(
                        height: 10,
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 10,),
                        child: Row(
                          children: [
                            Text(
                              'Confession',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                height: 1.5,
                                fontSize: devotionalFontSize*1.3,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 10,),
                        child: Row(
                          children: [
                            Expanded(
                              child: ClickableText(
                                text: widget.model.confession!,
                                context: context,
                            
                                defaultTextStyle: TextStyle(
                                fontSize: devotionalFontSize,
                                color: Colors.black,
                                height: 1.5
                              ),
                            
                              matchTextStyle: TextStyle(
                                fontSize: devotionalFontSize,
                                color: Colors.black,
                                decorationStyle: TextDecorationStyle.dotted,
                                decorationColor: Colors.black,
                            
                                height: 1.5
                              ),
                                // onTap: (p0) {
                                //   print(p0);
                                // },
                                // textAlign: TextAlign.left,
                                // style: TextStyle(
                                //   height: 1.8
                                // ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    /////////////////////////////////
                    ///
                    if(widget.model.prayer != null && widget.model.prayer!.length>5)...[
                      const SizedBox(
                        height: 10,
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 10,),
                        child: Row(
                          children: [
                            Text(
                              'Prayer',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                height: 1.5,
                                fontSize: devotionalFontSize*1.3,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 10,),
                        child: Row(
                          children: [
                            Expanded(
                              child: ClickableText(
                                text: widget.model.prayer!,
                                context: context,
                            
                                defaultTextStyle: TextStyle(
                                fontSize: devotionalFontSize,
                                color: Colors.black,
                                height: 1.5
                              ),
                            
                              matchTextStyle: TextStyle(
                                fontSize: devotionalFontSize,
                                color: Colors.black,
                                decorationStyle: TextDecorationStyle.dotted,
                                decorationColor: Colors.black,
                            
                                height: 1.5
                              ),
                                // onTap: (p0) {
                                //   print(p0);
                                // },
                                // textAlign: TextAlign.left,
                                // style: TextStyle(
                                //   height: 1.8
                                // ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    

                    const SizedBox(
                        height: 10,
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 10,),
                        child: Row(
                          children: [
                            Text(
                              'Further Study',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                height: 1.5,
                                fontSize: devotionalFontSize*1.3,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 10,),
                        child: Row(
                          children: [
                            Expanded(
                              child: ClickableText(
                                text: widget.model.furtherScriptures!,
                                context: context,
                            
                                defaultTextStyle: TextStyle(
                                fontSize: devotionalFontSize,
                                color: Colors.black,
                                height: 1.5
                              ),
                            
                              matchTextStyle: TextStyle(
                                fontSize: devotionalFontSize,
                                color: Colors.black,
                                decorationStyle: TextDecorationStyle.dotted,
                                decorationColor: Colors.black,
                            
                                height: 1.5
                              ),
                                // onTap: (p0) {
                                //   print(p0);
                                //   BibleReference r = parseBibleReference(p0);
                                //   print(r);
                                // },
                                // textAlign: TextAlign.left,
                                // style: TextStyle(
                                //   height: 1.8
                                // ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 10,),
                        child: Row(
                          children: [
                            Text(
                              'Doing the Word',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                height: 1.5,
                                fontSize: devotionalFontSize*1.3,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 10,),
                        child: Row(
                          children: [
                            Expanded(
                              child: ClickableText(
                                text: widget.model.doingTheWord!,
                                context: context,

                                defaultTextStyle: TextStyle(
                          fontSize: devotionalFontSize,
                          color: Colors.black,
                          height: 1.5
                        ),

                        matchTextStyle: TextStyle(
                          fontSize: devotionalFontSize,
                          color: Colors.black,
                          decorationStyle: TextDecorationStyle.dotted,
                          decorationColor: Colors.black,

                          height: 1.5
                        ),
                                // onTap: (p0) {
                                //   print(p0);
                            
                                // },
                                // textAlign: TextAlign.left,
                                // style: TextStyle(
                                //   height: 1.8
                                // ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 10,),
                        child: Row(
                          children: [
                            Text(
                              'Daily Scripture',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                height: 1.5,
                                fontSize: devotionalFontSize*1.3,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 10,),
                        child: Row(
                          children: [
                            Expanded(
                              child: ClickableText(
                                text: widget.model.dailyScriptureReading!,
                                context: context,
                                defaultTextStyle: TextStyle(
                                                  fontSize: devotionalFontSize,
                                                  color: Colors.black,
                                                  height: 1.5
                                                ),
                            
                                                matchTextStyle: TextStyle(
                                                  fontSize: devotionalFontSize,
                                                  color: Colors.black,
                                                  decorationStyle: TextDecorationStyle.dotted,
                                                  decorationColor: Colors.black,
                            
                                                  height: 1.5
                                                ),
                                
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20,),

                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: (){

                              },
                              icon: Icon(
                                MdiIcons.heartOutline
                              )
                            ),

                            IconButton(
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    child: NoteTaker(

                                    ), 
                                    type: PageTransitionType.fade)
                                );
                              },
                              icon: Icon(
                                MdiIcons.pencilPlusOutline
                              )
                            ),

                            IconButton(
                              onPressed: (){

                              },
                              icon: Icon(
                                MdiIcons.shareVariantOutline
                              )
                            ),
                          ],
                        ),

                    const SizedBox(height: 100,)
                  ],
                ),
              ),
            ),

            Positioned(
                right: 14,
                bottom: 10,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    height: 50,
                    width: 200,
                    color: Colors.white,
                    
    
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            MdiIcons.calendar,
                            color: Color.fromARGB(255, 228, 179, 3),
                          ),
                          Text(
                            ' '+DateFormat('EEE d, MMM y').format(widget.model.date),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: cricColor,
                            ),
                          ),
    
                          
                        ],
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
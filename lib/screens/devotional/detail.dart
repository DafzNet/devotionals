// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_const_constructors

import 'dart:io';

import 'package:devotionals/firebase/dbs/devs.dart';
import 'package:devotionals/firebase/dbs/user.dart';
import 'package:devotionals/screens/devotional/add_dev.dart';
import 'package:devotionals/utils/constants/constants.dart';
import 'package:devotionals/utils/models/comment.dart';
import 'package:devotionals/utils/models/devotional.dart';
import 'package:devotionals/utils/models/models.dart';
import 'package:devotionals/utils/widgets/cards/comment_card.dart';
import 'package:devotionals/utils/widgets/click_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:share_plus/share_plus.dart';

import '../profile/screens/notes/note_taker.dart';

class DevotionalDetailScreen extends StatefulWidget {
  final DevotionalModel model;
  final String uid;
  const DevotionalDetailScreen(
    {
      required this.uid,
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


    setState(() {
      _isPlaying = true;
    });

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

    // flutterTts.setProgressHandler((text, start, end, word) { });

    setState(() {
      _isPlaying = false;
    });
  }




  double _height=300;
  Map<String, bool> reactions = {};


  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        loadComments();
        
      }
    });
    reactions = widget.model.reactions;
    
    initTts();
  }

  List<CommentModel> _comments = [];

  void loadComments()async{
    final c = await DevotionalService().getComments(widget.model.id);

    c.sort((a, b){
      return b.date.compareTo(a.date);
    });

    _comments = c;
    
    print(_comments);

    setState(() {
      
    });
  }


  double commentTextFieldHeight = 0;
  final _commentFocus = FocusNode();
  final commentController = TextEditingController();
  CommentModel? replyingComment;


  @override
  Widget build(BuildContext context){
    
    return Scaffold(

      backgroundColor: bgColor,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: NestedScrollView(
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
      
      
                    }, 
                    icon: Icon(
                      _isPlaying? MdiIcons.stop: MdiIcons.play,
                      color: _isPlaying? Colors.redAccent:cricColor
                    )
                  ),
                  IconButton(
                    onPressed: ()async{
                      await showModalBottomSheet(
                        context: context, 
                        builder: (ctx){
                          return Container(
                            padding: const EdgeInsets.all(15),
                            height: MediaQuery.of(context).size.height/2.5,
                            decoration: const BoxDecoration(
      
                            ),
      
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
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
                                    const Row(
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
          body: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: SingleChildScrollView(
                        // controller: devScrollController,
                        physics: AlwaysScrollableScrollPhysics(),
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
                                        fontSize: devotionalFontSize+2
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
                                padding: const EdgeInsets.only(top: 10,),
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
                                padding: const EdgeInsets.only(top: 10,),
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
                                padding: const EdgeInsets.only(top: 10,),
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
                                padding: const EdgeInsets.only(top: 10,),
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
                                padding: const EdgeInsets.only(top: 10,),
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
                                padding: const EdgeInsets.only(top: 10,),
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

                              const SizedBox(height: 20,),

                              Row(
                                children: [
                                  Text(
                                    'User Insights',

                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20,),

                              ...List.generate(
                                _comments.length,
                                (index){
                                  return CommentCard(
                                    width: MediaQuery.sizeOf(context).width-20,
                                    dev: widget.model,
                                    comment: _comments[index], 
                                    uid: widget.uid,
                                    onReply: (){
                                      commentTextFieldHeight = 70;
                                      replyingComment = _comments[index];

                                      setState(() {
                                        
                                      });
                                    },
                                    onLike: () async{
                                      List<String> _likes = _comments[index].likes;
                                      List<String> _dislikes = _comments[index].dislikes;

                                      if(!_likes.contains(widget.uid)) {
                                        _likes.add(widget.uid);
                                        _dislikes.remove(widget.uid);
                                        await DevotionalService().updateComment(widget.model.id, 
                                          _comments[index].copyWith(
                                            dislikes: _dislikes
                                          )
                                        );
                                      }else{
                                        _likes.remove(widget.uid);
                                        _dislikes.remove(widget.uid);
                                        await DevotionalService().updateComment(widget.model.id, 
                                          _comments[index].copyWith(
                                            likes: _likes,
                                            dislikes: _dislikes
                                          )
                                        );
                                      }

                                      setState(() {
                                        
                                      });
                                    },

                                    onDislike: () async{
                                      List<String> _dislikes = _comments[index].dislikes;
                                       List<String> _likes = _comments[index].likes;

                                      if(!_dislikes.contains(widget.uid)) {

                                        _dislikes.add(widget.uid);
                                         _likes.remove(widget.uid);
                                        

                                        await DevotionalService().updateComment(widget.model.id, 
                                          _comments[index].copyWith(
                                            dislikes: _dislikes,
                                            likes: _likes
                                          )
                                        );
                                      }else{
                                        _dislikes.remove(widget.uid);
                                        _likes.remove(widget.uid);
                                        
                                        await DevotionalService().updateComment(widget.model.id, 
                                          _comments[index].copyWith(
                                            dislikes: _dislikes,
                                            likes: _likes
                                          )
                                        );
                                      }

                                      setState(() {
                                        
                                      });
                                    },
                                  );
                                }
                              ),

                            const SizedBox(height: 100,),

                            
                          ],
                        ),
                      ),
                    ),
                    if(commentTextFieldHeight == 0)...
                    [
                      Positioned(
                        right: 0,
                        bottom: 2,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 50,
                            width: MediaQuery.sizeOf(context).width-10,
                            color: Colors.white,
                            
                
                            child: Center(
                              child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: ()async{
                    
                                    Map<String, bool> _l = widget.model.reactions;
                                    if (widget.model.reactions.containsKey(widget.uid)) {
                                      _l.remove(widget.uid);
                                      
                                    } else {
                                      _l[widget.uid] = true;
                                    }
                    
                                    final dev = widget.model.copyWith(
                                      reactions: _l
                                    );
                    
                                    await DevotionalService().updateDevotional(dev);
                    
                                    reactions = _l;
                    
                                    setState(() {
                                      
                                    });
                                  },
                    
                                  icon: Row(
                                    children: [
                                      Icon(
                                        reactions.containsKey(widget.uid)? MdiIcons.heart: MdiIcons.heartOutline,
                                        color: reactions.containsKey(widget.uid)?Colors.redAccent: null
                                      ),
                    
                                      Text(
                                        reactions.isNotEmpty? reactions.length.toString():''
                                      )
                                    ],
                                  )
                                ),


                                IconButton(
                                  onPressed: ()async{
                                    commentTextFieldHeight = 70;
                                    

                                    FocusScope.of(context).requestFocus(_commentFocus);

                                    setState(() {
                                      
                                    });
                                  },
                                  icon: Row(
                                    children: [
                                      Icon(
                                        MdiIcons.commentOutline
                                      ),

                                      Text(
                                        widget.model.numberOfComment>0?' '+widget.model.numberOfComment.toString():'',
                                        style: TextStyle(
                                          fontSize: 16
                                        ),
                                      )
                                    ],
                                  )
                                ),
                    
                                IconButton(
                                  onPressed: (){
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        child: NoteTaker(
                                          devotional: widget.model,
                                        ), 
                                        type: PageTransitionType.fade)
                                    );
                                  },
                                  icon: Icon(
                                    MdiIcons.notebookPlusOutline
                                  )
                                ),
                    
                                IconButton(
                                  onPressed: (){
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        child: AddDev(
                                          model: widget.model,
                                        ), 
                                        type: PageTransitionType.fade)
                                    );
                                  },
                                  icon: Icon(
                                    MdiIcons.pencilPlusOutline
                                  )
                                ),
                    
                                IconButton(
                                  onPressed: ()async{
                                    await Share.share(
                                      widget.model.instruction != null && widget.model.instruction!.length>5?"A Word in Due Season\nBy Apostle David Wale Feso\n\n${DateFormat('EEE d, MMM y').format(widget.model.date)}\n\n\""+widget.model.title+
                                          "\"\n\n\""+widget.model.openingScriptureText+"\" - "+widget.model.openingScriptureReference+
                                          "\n\n"+widget.model.body+
                                          '\n\nInstruction\n'+widget.model.instruction!+
                                          '\n\nFurther Scriptures\n'+widget.model.furtherScriptures!+
                                          '\n\nDoing the word\n'+widget.model.doingTheWord!+
                                          '\n\nDaily Scriptural reading\n'+widget.model.dailyScriptureReading!:
                    
                                          widget.model.confession != null && widget.model.confession!.length>5?"A Word in Due Season\nBy Apostle David Wale Feso\n\n${DateFormat('EEE d, MMM y').format(widget.model.date)}\n\n\""+widget.model.title+
                                          "\"\n\n\""+widget.model.openingScriptureText+"\" - "+widget.model.openingScriptureReference+
                                          "\n\n"+widget.model.body+
                                          '\n\nConfession\n'+widget.model.confession!+
                                          '\n\nFurther Scriptures\n'+widget.model.furtherScriptures!+
                                          '\n\nDoing the word\n'+widget.model.doingTheWord!+
                                          '\n\nDaily Scriptural reading\n'+widget.model.dailyScriptureReading!:
                    
                                          "A Word in Due Season\nBy Apostle David Wale Feso\n\n${DateFormat('EEE d, MMM y').format(widget.model.date)}\n\n\""+widget.model.title+
                                          "\"\n\n\""+widget.model.openingScriptureText+"\" - "+widget.model.openingScriptureReference+
                                          "\n\n"+widget.model.body+
                                          '\n\nPrayer\n'+widget.model.prayer!+
                                          '\n\nFurther Scriptures\n'+widget.model.furtherScriptures!+
                                          '\n\nDoing the word\n'+widget.model.doingTheWord!+
                                          '\n\nDaily Scriptural reading\n'+widget.model.dailyScriptureReading!
                                    );
                                  },
                                  icon: Icon(
                                    MdiIcons.shareVariantOutline
                                  )
                                ),
                              ],
                            ),
                            ),
                          ),
                        )),
                      ]
                  ],
                ),
              ),

              Focus(
                  onFocusChange: (focus){
                    if(focus){
                      setState(() {
                        commentTextFieldHeight = 70;
                      });
                    }else{
                      
                      setState(() {
                        commentTextFieldHeight = 0;
                      });
                    }
                  },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      height: commentTextFieldHeight,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 243, 247, 244)
                      ),
                      child: Row(
                        children: [
                          Icon(
                            MdiIcons.lightbulbOutline,
                            color: Colors.amber,
                            size: 25,
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                border: Border.all(width: .4),
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: TextField(
                                  textCapitalization: TextCapitalization.sentences,
                                  maxLines: 3,
                                  minLines: 2,
                                  focusNode: _commentFocus,
                                  autocorrect: true,
                                  controller: commentController,
                                  
                                  decoration: InputDecoration.collapsed(
                                    hintText: replyingComment != null? 'reply @${replyingComment!.user.firstName} ${replyingComment!.user.lastName}' : 'share your insight on ${widget.model.title}',
                                    hintStyle: TextStyle(
                                      
                                    )
                                    
                                  ),
                                ),
                            ),
                          ),

                          IconButton(
                            onPressed:()async{
                              commentTextFieldHeight = 0;
                              setState(() {
                                
                              });

                              if (commentController.text.isNotEmpty && commentController.text.trim().length>4 && replyingComment == null) {
                                User? user = await UserService().getUser(widget.uid);
                                final comment = CommentModel(id: DateTime.now().millisecondsSinceEpoch.toString()+widget.uid, comment: commentController.text, user: user!, date: DateTime.now());
                                await DevotionalService().createComment(widget.model.id, comment);
                                await DevotionalService().updateDevotional(widget.model.copyWith(
                                  numberOfComments: widget.model.numberOfComment+1
                                ));
                              }


                              if (commentController.text.isNotEmpty && commentController.text.trim().length>4 && replyingComment != null) {
                                User? user = await UserService().getUser(widget.uid);
                                var _r = replyingComment!.replies;
                                _r.add(CommentModel(id: DateTime.now().millisecondsSinceEpoch.toString()+widget.uid, comment: commentController.text, user: user!, repliedUser: replyingComment!.user, date: DateTime.now()));
                                final comment = replyingComment!.copyWith(
                                  replies: _r
                                );
                                await DevotionalService().updateComment(widget.model.id, comment);
                                replyingComment = null;

                                setState(() {
                                  
                                });
                                
                              }

                              commentController.text = '';
                            } , 
                            icon: Icon(
                              MdiIcons.sendVariantOutline
                            ))

                        ],
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
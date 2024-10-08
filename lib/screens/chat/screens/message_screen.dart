// import 'package:chat_bubbles/bubbles/bubble_special_two.dart';
import 'dart:async';

import 'package:devotionals/screens/chat/screens/bubble.dart';
import 'package:record/record.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:devotionals/dbs/sembast/userdb.dart';
import 'package:just_audio/just_audio.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rxdart/rxdart.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:devotionals/dbs/sembast/generic.dart';
import 'package:devotionals/firebase/dbs/user.dart';
import 'package:devotionals/firebase/dbs/messages.dart';
import 'package:devotionals/utils/constants/colors.dart';
import 'package:devotionals/utils/models/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../utils/models/models.dart';
import '../../../utils/widgets/bubble.dart';
import '../../profile/screens/user_view.dart';


class MessageDisplayScreen extends StatefulWidget {

  final User buddy;
  final String curUser;
  const MessageDisplayScreen({
    required this.buddy,
    required this.curUser,
      super.key
    });

  @override
  State<MessageDisplayScreen> createState() => _MessageDisplayScreenState();
}

class _MessageDisplayScreenState extends State<MessageDisplayScreen> {

  final ChatService _chatService = ChatService();
  final messageController = TextEditingController();
  Chat? _replyingChat;
  bool autoFocus = false;

  bool _isRecording = false;
  String _recordedFilePath = ''; // Path to the recorded audio file
  AudioPlayer _audioPlayer = AudioPlayer();



  Future<void> _startRecording() async {
  if (!_isRecording) {
    try {
      bool hasPermission = await AudioRecorder().hasPermission();
      if (hasPermission) {
        await AudioRecorder().start(const RecordConfig(), path:_recordedFilePath);
        setState(() {
          _isRecording = true;
        });
      } else {
        // Handle permissions not granted
      }
    } catch (e) {
      print('Error starting recording: $e');
      // Handle recording start error
    }
  }
}

Future<void> _stopRecording() async {
  if (_isRecording) {
    try {
      String? path = await AudioRecorder().stop();
      setState(() {
        _isRecording = false;
        _recordedFilePath = path!;
      });
    } catch (e) {
      print('Error stopping recording: $e');
      // Handle recording stop error
    }
  }
}

Future<void> _playRecordedAudio() async {
  if (_recordedFilePath.isNotEmpty) {
    await _audioPlayer.play();
    
  }
}



  String calculateTimeAgo(DateTime messageTime) {
    final now = DateTime.now();
    final difference = now.difference(messageTime);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'm' : 'm'}';
    } else if (difference.inHours < 24 && now.day == messageTime.day) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'h' : 'h'}';
    } else if (difference.inDays == 1 || (difference.inDays < 2 && now.day != messageTime.day)) {
      return 'yesterday';
    } else if (difference.inDays > 1 && difference.inDays <= 5) {
      return '${_getWeekdayName(messageTime)} at ${messageTime.hour}:${messageTime.minute}';
    } else {
      return '${messageTime.day}-${messageTime.month}-${messageTime.year}';
    }
  }

  String _getWeekdayName(DateTime dateTime) {
    final weekdayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return weekdayNames[dateTime.weekday - 1];
  }

  final _store = DataStore('buddy_chats');
  late BehaviorSubject<List<Chat>> msgsSubject;

  List<Chat>? _cahedChats = [];

   void _cacheChats(List<Chat> chats)async{
      final myChats = chats.map((e) => e.toMap()).toList();
      await _store.insertList(widget.curUser+widget.buddy.userID, myChats);
   }

   void _getBuddyChat() async {
    
    final _chats = await _store.getList(widget.curUser+widget.buddy.userID);
    _cahedChats = _chats!.map((e) => Chat.fromMap(e)).toList(growable: false);
    msgsSubject.add(_cahedChats??[]);
    msgsSubject.addStream(ChatService().getChats(widget.curUser, widget.buddy.userID),);

    
  }

  @override
  void initState() {
    
    msgsSubject = BehaviorSubject<List<Chat>>.seeded([]);
    _getBuddyChat();
    _getUser();
    
    super.initState();
  }

  @override
  void dispose() {
    msgsSubject.close();
    super.dispose();
  }


  User? _me;

  _getUser()async{
    if (await UserRepo().containsKey(widget.curUser)){
      _me = await UserRepo().get(widget.curUser);
    }else{
      _me = await UserService().getUser(widget.curUser);
      await UserRepo().insert(_me!);
    }
  }

  final _replyFocus= FocusNode();



  @override
  Widget build(BuildContext context) {
    // bool isOnline = Provider.of<bool>(context);
    // bool isTyping = Provider.of<bool>(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        // automaticallyImplyLeading: false,
        flexibleSpace: FlexibleSpaceBar(
          background: Container(
            decoration: BoxDecoration(
              gradient: SweepGradient(
                colors: [
                  cricColor.shade200,
                  cricColor.shade100,
                  cricColor.shade200,
                  cricColor.shade100,
                  cricColor.shade200,
                  cricColor.shade100,
                  cricColor.shade200,
                  cricColor.shade100,
                  cricColor.shade200,
                  cricColor.shade100,
                  cricColor.shade200,
                  cricColor.shade100
                ]
              )
            ),
          ),
        ),
        

        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark
          ),
        title: ListTile(
          dense: true,
          onTap: () {
            Navigator.push(
              context,
              PageTransition(child: UserView(user: widget.buddy, currentUserID: widget.curUser,), type: PageTransitionType.topToBottom)
            );
          },
          leading: SizedBox(
          width: 40,
          height: 40,
          child: ClipOval(
            child: Hero(tag: widget.buddy.email!, child: CachedNetworkImage(imageUrl: widget.buddy.photoUrl??'https://www.freepik.com/icon/user_1177568#fromView=keyword&term=User&page=1&position=9&uuid=694cc40b-b89d-4277-bad4-f630ee961d26')),
            ),
          ),
          title: Text(
            widget.buddy.firstName+' '+widget.buddy.lastName
          ),

          subtitle: StreamBuilder(
              stream: UserService().getIsTyping(widget.curUser, widget.buddy.userID),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Container();
                }
                return snapshot.data == true? Text(
                  'typing...',
                  style: TextStyle(
                    fontSize: 12,
                    color: cricColor,
                  )
                ):Text(
                  'department: '+widget.buddy.department.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    color: cricColor,
                  )
                ) ;
              }
            ),


        ),

        actions: [
          StreamBuilder(
            stream: UserService().getPresence(widget.buddy.userID),
            builder: (context, snapshot) {
              return snapshot.data ==true? Icon(
                MdiIcons.circle,
                size: 15,
                color: Colors.greenAccent,
              ):Icon(
                MdiIcons.circle,
                size: 15,
                color: Colors.blueGrey,
              );
            }
          ),

          SizedBox(width: 12,)
        ],
      ),
      
      

      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(cricColor.shade100, BlendMode.screen),
            // opacity: .2,
            image: AssetImage('assets/images/texture.png'), // Your texture image asset
            fit: BoxFit.cover,
          ),
        ),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5, left: 1, right: 1),
                  child: StreamBuilder(
                    stream: msgsSubject.stream,
                    initialData: _cahedChats,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('');
                      } else {
                        
                        List<Chat> chatMessages = snapshot.data?? [];
        
                        chatMessages.sort(
                          (a, b){
                            return b.timestamp!.compareTo(a.timestamp!);
                          }
                        );
        
                        _cacheChats(chatMessages);
                        print(chatMessages);
        
                        return ListView.builder(
                          reverse: true,
                          itemCount: chatMessages.length,
                          itemBuilder: (context, index) {
                            Chat chat = chatMessages[index];
                            Chat chatN = index < chatMessages.length-1?chatMessages[index+1]:chatMessages[index];
                            
                            return Column(
                              children: [
                                if (chat.timestamp!.day != chatN.timestamp!.day)... [
                                    DateChip(
                                      date: chat.timestamp!,
                                    )
                                ],
                                SwipeTo(
                                  animationDuration: Duration(milliseconds: 300),
                                  onRightSwipe: (details) {
                                    if (chat.senderId == widget.buddy.userID) {
                                      autoFocus = true;
                                       if (chat.isReply != null) {
                                        _replyingChat = Chat.fromMap(
                                          {'id': chat.id,'text': chat.text, 'timestamp': chat.timestamp!.millisecondsSinceEpoch,
                                          'senderId': chat.senderId, 'isReply':null, 'audio':chat.audio, 'isSeen':chat.isSeen,
                                          'image':chat.image }
                                        );
                                      }else if(chat.isReply == null){_replyingChat = chat;} 
                                      
        
                                      FocusScope.of(context).requestFocus(_replyFocus);
        
                                      setState(() {
                                        
                                      });
                                    }
                                  },
        
                                  onLeftSwipe: (details) {
                                    if (chat.senderId == widget.curUser) {
                                      autoFocus = true;
                                      if (chat.isReply != null) {
                                        _replyingChat = Chat.fromMap(
                                          {'id': chat.id,'text': chat.text, 'timestamp': chat.timestamp!.millisecondsSinceEpoch,
                                          'senderId': chat.senderId, 'isReply':null, 'audio':chat.audio, 'isSeen':chat.isSeen,
                                          'image':chat.image }
                                        );
                                      }else if(chat.isReply == null){_replyingChat = chat;}
        
                                      FocusScope.of(context).requestFocus(_replyFocus);
        
                                      setState(() {
                                        
                                      });
                                    }
                                  },
                                  child: Column(
        
                                    children: [
                                      // if(chat.isReply != null)...[
                                      //   Row(
                                      //     mainAxisAlignment: chat.senderId == widget.curUser?MainAxisAlignment.end:MainAxisAlignment.start,
                                      //     children: [
                                            
                                      //       Padding(
                                      //         padding: chat.senderId == widget.curUser?EdgeInsets.only(left: 100, right: 20):EdgeInsets.only(right: 100, left: 20),
                                      //         child: Container(
                                      //           padding: EdgeInsets.all(5),
                                      //           decoration: BoxDecoration(
                                      //             borderRadius: BorderRadius.circular(10),
                                      //             color: Colors.grey.shade200.withOpacity(.7)
                                      //           ),
                                      //           child: Column(
                                      //             crossAxisAlignment: CrossAxisAlignment.start,
                                      //             children: [
                                      //               Text(
                                      //                 chat.isReply?.senderId == widget.curUser?'You':widget.buddy.firstName,
                                      //                 maxLines: 3,
                                      //                 overflow: TextOverflow.ellipsis,
                                      //                 style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 70, 15, 182))
                                      //               ),
                                      //               Padding(
                                      //                 padding: const EdgeInsets.all(8.0),
                                      //                 child: Text(
                                      //                 chat.isReply!.text,
                                      //                 maxLines: 3,
                                      //                 style: TextStyle(fontSize: 12),
                                                    
                                      //                 overflow: TextOverflow.ellipsis,
                                      //                 ),
                                      //               ),
                                      //             ],
                                      //           ),
                                      //         ),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ],

                                      BubbleSpecialC(
                                        text: chat.text,
                                        reply: chat.isReply,
                                        replyTo: chat.isReply?.senderId == widget.curUser?'You':widget.buddy.firstName,
                                        isSender: chat.senderId == widget.curUser,
                                        tail: chat.senderId != chatN.senderId,
                                        color: chat.senderId == widget.curUser?cricColor.shade100:cricColor.shade50,
                                        seen: chat.senderId == widget.curUser? chat.isSeen:false,
                                        sent: chat.senderId == widget.curUser?true:false,
                                        timestamp: chat.timestamp,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                  )
                ),
              ),
        
              Container(
                
                decoration: BoxDecoration(
                  color: Color.fromARGB(37, 95, 94, 94),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  )
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    children: [
                      if(_replyingChat != null)...[
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(12),
                              border: Border(
                                right: BorderSide(color: cricColor, width: 3)),
                              
                            ),
                                              
                            child: Stack(
                              children: [
                                Positioned(
                                  right: 5,
                                  top: 1,
                                  child: InkWell(
                                    onTap: () {
                                      _replyingChat = null;
                                      setState(() {
                                        
                                      });
                                    },
                                    child: Icon(
                                      MdiIcons.close,
                                      color: Colors.red,
                                      size: 18,
                                    ),
                                  ),
                                ),
                                Row(
                                  
                                  children: [
                                    
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _replyingChat!.senderId == widget.curUser?'You':widget.buddy.firstName,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 70, 15, 182))
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            constraints: BoxConstraints(
                                              maxWidth: MediaQuery.sizeOf(context).width-50
                                            ),
                                            child: Text(
                                            _replyingChat!.text,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 12
                                            ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                      Row(
                        children: [
                          
                          Flexible(
                            flex: 9,
                            fit: FlexFit.tight,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white12,
                                borderRadius: BorderRadius.circular(25)
        
                              ),
                              child: Focus(
            
                            onFocusChange: (focus){
                              final _user = UserService();
                              if(focus){
                                  _user.setIsTyping(widget.buddy.userID, widget.curUser,  true);
                                  
                              }else{
                                _user.setIsTyping(widget.buddy.userID, widget.curUser, false);
                                
                              }
                            },
                                child: TextField(
                                  onChanged: (value) {
                                    setState(() {
                                      
                                    });
                                  },
                                  textCapitalization: TextCapitalization.sentences,
                                  maxLines: 5,
                                  minLines: 1,
                                  autofocus: autoFocus,
                                  controller: messageController,
                                  focusNode: _replyFocus,
                                  
                                  decoration: InputDecoration.collapsed(
                                    hintText: 'Type message',
                                    
                                  ),
                                ),
                              ),
                            ),
                          ),
                
                          Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child:
                            // messageController.text.trim().isEmpty?
                            // IconButton(
                            //   onPressed: () {
                            //     if (!_isRecording) {
                            //       _startRecording();
                            //     } else {
                            //       _stopRecording();
                            //     }
                            //   },
                            //   icon: Icon(
                            //     _isRecording ? Icons.stop : Icons.mic,
                            //   ),
                            
                            // )
                            // :
                          IconButton(
                              onPressed:messageController.text.trim().isEmpty?null:(){
                                if (_replyingChat != null && _replyingChat!.isReply != null) {
                                  _replyingChat = _replyingChat!.copyWith(isReply: null);
                                }

                                final chat = Chat( 
                                  senderId: widget.curUser, 
                                  text: messageController.text,
                                  isReply: _replyingChat,
                                  id: DateTime.now().microsecondsSinceEpoch.toString(),
                                  image: '',
                                  audio: '',
                                  isDelivered: false,
                                );
                           
        
                                  _chatService.createChatDocument(widget.curUser, widget.buddy.userID, chat);
                                  _chatService.updateBuddiesLastChat(widget.curUser, widget.buddy.userID, chat);
                                  messageController.text = '';
                                  _replyingChat = null;
        
                                  setState(() {
                                    
                                  });
                                
                              },
        
                              icon: Icon(
                                // messageController.text.trim().isEmpty? MdiIcons.microphone: 
                                MdiIcons.sendOutline
                              ),
                            ),
                          ),
                        ]
                      ),
                    ],
                  ),
                ),
              )
            ]
          ),
        ),
      ),
    );
  }
}


// import 'package:chat_bubbles/bubbles/bubble_special_two.dart';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:devotionals/dbs/sembast/userdb.dart';
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
  final _controller = StreamController<List<Chat>>.broadcast();
  List<Chat>? _cahedChats = [];

   void _cacheChats(List<Chat> chats)async{
      final myChats = chats.map((e) => e.toMap()).toList();
      await _store.insertList(widget.curUser+widget.buddy.userID, myChats);
   }

   void _getBuddyChat() async {
    final _chats = await _store.getList(widget.curUser+widget.buddy.userID);
    _cahedChats = _chats!.map((e) => Chat.fromMap(e)).toList();

    // _controller.add(_cahedChats!); // Add the initial data to the stream
  }

  @override
  void initState() {
    _getBuddyChat();
    _getUser();
    _controller.addStream(ChatService().getChats(widget.curUser, widget.buddy.userID),);
    super.initState();
  }

  @override
  void dispose() {
    _controller.close();
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
    setState(() {
      
    });

  }

  final _replyFocus= FocusNode();



  @override
  Widget build(BuildContext context) {
    // bool isOnline = Provider.of<bool>(context);
    // bool isTyping = Provider.of<bool>(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        leadingWidth: 28,

        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark
          ),
        title: ListTile(
          leading: SizedBox(
          width: 40,
          height: 40,
          child: ClipOval(
            child: CachedNetworkImage(imageUrl: widget.buddy.photoUrl??'https://www.freepik.com/icon/user_1177568#fromView=keyword&term=User&page=1&position=9&uuid=694cc40b-b89d-4277-bad4-f630ee961d26'),
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

      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5, left: 1, right: 1),
                child: StreamBuilder(
                  stream: _controller.stream,
                  initialData: _cahedChats,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      
                      List<Chat> chatMessages = snapshot.data?? [];

                      chatMessages.sort(
                        (a, b){
                          return b.timestamp!.compareTo(a.timestamp!);
                        }
                      );

                      _cacheChats(chatMessages);

                      return ListView.builder(
                        reverse: true,
                        itemCount: chatMessages.length,
                        itemBuilder: (context, index) {
                          Chat chat = chatMessages[index];
                          Chat chatP = index>0? chatMessages[index-1]:chatMessages[index];
                        

                          

                          
                          return Column(
                            children: [
                              if (chat.timestamp!.day != chatP.timestamp!.day)... [
                                  DateChip(
                                    date: chat.timestamp!,
                                  )
                              ],
                              SwipeTo(
                                animationDuration: Duration(milliseconds: 300),
                                onRightSwipe: (details) {
                                  if (chat.senderId == widget.buddy.userID) {
                                    autoFocus = true;
                                    _replyingChat = chat;

                                    FocusScope.of(context).requestFocus(_replyFocus);

                                    setState(() {
                                      
                                    });
                                  }
                                },

                                onLeftSwipe: (details) {
                                  if (chat.senderId == widget.curUser) {
                                    autoFocus = true;
                                    _replyingChat = chat;

                                    FocusScope.of(context).requestFocus(_replyFocus);

                                    setState(() {
                                      
                                    });
                                  }
                                },
                                child: Column(

                                  children: [
                                    if(chat.isReply != null)...[
                                      Container(
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(255, 255, 255, 255),
                                          border: Border(
                                            right: BorderSide(color: cricColor, width: 3)),
                                          // borderRadius: BorderRadius.circular(10)
                                        ),
                                                          
                                        child: Row(

                                          children: [
                                            
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  chat.isReply?.senderId == widget.curUser?'You':widget.buddy.firstName,
                                                  maxLines: 3,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 70, 15, 182))
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text(
                                                  chat.isReply!.text,
                                                  maxLines: 3,
                                                  overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                    BubbleNormal(
                                      text: chat.text,
                                      isSender: chat.senderId == widget.curUser,
                                      tail: chatP.senderId != chat.senderId,
                                      color: chat.senderId == widget.curUser?cricColor.shade100:cricColor.shade50,
                                      seen: chat.senderId == widget.curUser? chat.isSeen:false,
                                      sent: chat.senderId == widget.curUser?true:false
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
              
              color: Color.fromARGB(17, 95, 94, 94),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  children: [
                    if(_replyingChat != null)...[
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 255, 255),
                            border: Border(
                              right: BorderSide(color: cricColor, width: 3)),
                            // borderRadius: BorderRadius.circular(10)
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
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 70, 15, 182))
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                        _replyingChat!.text,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
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
                          flex: 1,
                          fit: FlexFit.tight,
                          child: IconButton(

                            onPressed: () {
                              
                            },
                            icon: Icon(
                              MdiIcons.plus
                            ),
                          ),
                        ),
                        
                        Flexible(
                          flex: 8,
                          fit: FlexFit.tight,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
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
                          child: IconButton(
                            onPressed: messageController.text.trim().isEmpty?()async{}:  (){
                              final chat = Chat( 
                                senderId: widget.curUser, 
                                text: messageController.text,
                                isReply: _replyingChat,
                                id: DateTime.now().millisecondsSinceEpoch.toString()
                              );

                                _chatService.createChatDocument(widget.curUser, widget.buddy.userID, chat);
                                _chatService.updateBuddiesLastChat(widget.curUser, widget.buddy.userID, chat);
                                messageController.text = '';
                                _replyingChat = null;

                                setState(() {
                                  
                                });
                              
                            },

                            icon: Icon(
                              messageController.text.trim().isEmpty? MdiIcons.microphone: MdiIcons.sendOutline
                            ),
                          ),
                        ),
                      ]
                    ),
                  ],
                ),
              ),
            )
      
          ]),
      ),
    );
  }
}


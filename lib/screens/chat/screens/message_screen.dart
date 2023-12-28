// import 'package:chat_bubbles/bubbles/bubble_special_two.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:devotionals/firebase/dbs/user.dart';
import 'package:devotionals/firebase/dbs/messages.dart';
import 'package:devotionals/utils/constants/colors.dart';
import 'package:devotionals/utils/models/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../utils/models/models.dart';


class MessageDisplayScreen extends StatefulWidget {

  final User user;
  final String curUser;
  const MessageDisplayScreen({
    required this.user,
    required this.curUser,
      super.key
    });

  @override
  State<MessageDisplayScreen> createState() => _MessageDisplayScreenState();
}

class _MessageDisplayScreenState extends State<MessageDisplayScreen> {

  final ChatService _chatService = ChatService();
  final messageController = TextEditingController();



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



  @override
  Widget build(BuildContext context) {
    // bool isOnline = Provider.of<bool>(context);
    // bool isTyping = Provider.of<bool>(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,

        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark
          ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.user.firstName+' '+widget.user.lastName
            ),

            StreamBuilder(
              stream: UserService().getIsTyping(widget.curUser, widget.user.userID),
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
                  'department: '+widget.user.department.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    color: cricColor,
                  )
                ) ;
              }
            ),
          ],
        ),

        actions: [
          StreamBuilder(
            stream: UserService().getPresence(widget.user.userID),
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
                  stream: ChatService().getChats(widget.curUser, widget.user.userID),
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

                      return ListView.builder(
                        reverse: true,
                        itemCount: chatMessages.length,
                        itemBuilder: (context, index) {
                          Chat chat = chatMessages[index];
                          Chat chatP = index>0? chatMessages[index-1]:chatMessages[index];

                          //DateTime dateTime = chat.timestamp!.toDate();

                          
                          return Column(
                            children: [
                              BubbleSpecialTwo(
                                text: chat.text,
                                isSender: chat.senderId == widget.curUser,
                                tail: chatP != chat && chatP.senderId == widget.curUser,
                                color: chat.senderId == widget.curUser?cricColor.shade200:cricColor.shade100,
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

      //////
      ///Message Composer
      ///
            Container(
              
              color: cricColor.shade100,
      
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
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
                            _user.setIsTyping(widget.user.userID, widget.curUser,  true);
                            
                        }else{
                          _user.setIsTyping(widget.user.userID, widget.curUser, false);
                          
                        }
                      },
                          child: TextField(
                            textCapitalization: TextCapitalization.sentences,
                            maxLines: 5,
                            minLines: 1,
                            controller: messageController,
                            
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
                        onPressed: (){
                          final chat = Chat( 
                            senderId: widget.curUser, 
                            text: messageController.text
                          );

                            _chatService.createChatDocument(widget.curUser, widget.user.userID, chat);
                            _chatService.updateBuddiesLastChat(widget.curUser, widget.user.userID, chat);
                            messageController.text = '';

                            // setState(() {
                              
                            // });
                          
                        },

                        icon: Icon(
                          MdiIcons.sendOutline
                        ),
                      ),
                    ),
                  ]
                ),
              ),
            )
      
          ]),
      ),
    );
  }
}


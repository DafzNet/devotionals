import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:devotionals/dbs/sembast/generic.dart';
import 'package:devotionals/firebase/dbs/messages.dart';
import 'package:devotionals/firebase/dbs/user.dart';
import 'package:devotionals/utils/models/chat.dart';
import 'package:devotionals/utils/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';

import '../../../utils/constants/colors.dart';
import '../../dbs/sembast/userdb.dart';
import 'screens/buddies.dart';
import 'screens/message_screen.dart';




class ChatScreen extends StatefulWidget {
  final String uid;
  const ChatScreen({
    required this.uid,
    super.key
    });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  List<Map<String, dynamic>> buddies = [];

  final _store = DataStore('buddies');
  final _controller = StreamController<List<Map<String, dynamic>>>.broadcast();
  List<Map<String, dynamic>>? _myBudddies = [];

   void _getBuddiesFromStore() async {
    _myBudddies = await _store.getList(widget.uid);
    _controller.add(_myBudddies!);

  }

  @override
  void initState() {
    _getBuddiesFromStore();
    _controller.addStream(ChatService().listenForNewBuddies(widget.uid), cancelOnError: true);
    super.initState();
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,

        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark
          ),

        toolbarHeight: 70,
        elevation: 0,
        
        title: Text('Conversations'),
      ),

      body:StreamBuilder(
        stream: _controller.stream,
        // initialData: _myBudddies,
        // initialData: Hive.box('buddies').containsKey(widget.uid)?  List<Map<String, dynamic>>.from(Hive.box('buddies').get(widget.uid)) : <Map<String, dynamic>>[] ,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<Map<String, dynamic>> mybuddies = snapshot.data!; 
            buddies = mybuddies;
            
            buddies.sort((a, b) {

              return b['chat'].timestamp.compareTo(a['chat'].timestamp!);
            },);

            _store.insertList(widget.uid, buddies);
            return ListView.builder(
              itemCount: buddies.length,
              itemBuilder: (context, index){
                return ConverseTile(
                  buddies[index]['buddyId'],
                  myId: widget.uid,
                  chat: buddies[index]['chat'],
                );
              }
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            
            children: [
              const Center(
                child: Text(
                  'No active conversations Yet',
      
                  style: TextStyle(
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
      
              const Center(
                child: Text(
                  'Reach out and start a conversation',
      
                  style: TextStyle(
                    //fontWeight: FontWeight.w600
                  ),
                ),
              )
            ],
          );
        }
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            PageTransition(
              child: BuddyList(
                uid: widget.uid,
              ),

              type: PageTransitionType.bottomToTop
            )
          );
        },

        backgroundColor: cricColor.shade600,
        elevation: 3,

        shape: const CircleBorder(

        ),

         child: Icon(
          MdiIcons.plus,
          color: Colors.white,
        ),
      ),

    );
  }
}








class ConverseTile extends StatefulWidget {
  final String buddyUid;
  final String myId;
  final Chat chat;
  const ConverseTile(this.buddyUid, {required this.chat, required this.myId, super.key});

  @override
  State<ConverseTile> createState() => _ConverseTileState();
}

class _ConverseTileState extends State<ConverseTile> {
  User? _user;
  
    void getUser()async{
      if (await UserRepo().containsKey(widget.buddyUid)) {
        _user = await UserRepo().get(widget.buddyUid);
        print('yes');
      } else {
        _user = await UserService().getUser(widget.buddyUid);
        await UserRepo().insert(_user!);
        print('no');
      }
      setState(() {
        
      });
    }


    String getFormattedDate() {
    DateTime now = DateTime.now();
    DateTime commentDate = widget.chat.timestamp!;

    if (now.difference(commentDate).inSeconds < 60) {
      return 'just now';
    } else if (now.difference(commentDate).inMinutes < 60) {
      return '${now.difference(commentDate).inMinutes}m';
    } else if (commentDate.day == now.day) {
      return DateFormat('h:mm a').format(commentDate);
    } else if (commentDate.isAfter(now.subtract(Duration(days: 1)))) {
      return 'yesterday @ ${DateFormat('h:mm a').format(commentDate)}';
    } else {
      return DateFormat('d, MMM y | HH:mm').format(commentDate);
    }
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _user!=null? ListTile(
      onTap: (){
        Navigator.push(context,
        PageTransition(
          child: MessageDisplayScreen(buddy: _user!, curUser: widget.myId), 
          type: PageTransitionType.fade));
      },
      leading: SizedBox(
        width: 40,
        height: 40,
        child: ClipOval(
          child: CachedNetworkImage(imageUrl: _user!.photoUrl??'https://www.freepik.com/icon/user_1177568#fromView=keyword&term=User&page=1&position=9&uuid=694cc40b-b89d-4277-bad4-f630ee961d26'),
        ),
      ),

      trailing: Text(
        getFormattedDate()
      ),

      subtitle: StreamBuilder(
        stream: UserService().getIsTyping(widget.myId, widget.buddyUid),
        builder: (context, snapshot) {
          if (snapshot.data == true) {
            return Text(
              'typing...',

            style: TextStyle(
              fontSize: 12,
              color: cricColor
            ),
            );
          }
          return Text(
            widget.chat.text,
            style: TextStyle(
              fontSize: 12
            ),
          );
        }
      ),

      

      title: Text(
        _user!.firstName +' '+_user!.lastName
      ),
    ):
    ListTile(
      leading: const CircleAvatar(backgroundColor: Colors.blueGrey,),
      title: Container(color: Colors.blueGrey, height: 3, width: 100,),
      subtitle: SizedBox(width: 50, child: Container(color: Colors.blueGrey, height: 3, width: 50,)),

    )
    ;
  }
}
import 'package:devotionals/firebase/dbs/messages.dart';
import 'package:devotionals/firebase/dbs/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';

import '../../../utils/constants/colors.dart';
import 'screens/buddies.dart';




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
        stream: ChatService().listenForNewBuddies(widget.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Map<String, dynamic>> buddies = snapshot.data!;
            buddies.sort((a, b) {
              return b['chat'].timestamp!.compareTo(a['chat'].timestamp!);
            },);
            return ListView.builder(
              itemCount: buddies.length,
              itemBuilder: (context, index){
                return ListTile(
                  title: FutureBuilder(
                    future: UserService().getUser(buddies[index]['buddyId']), 
                    builder: (context, snapshot){
                      return Text(snapshot.data!.firstName + ' '+ snapshot.data!.lastName);
                    }),
                );
              }
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            
            children: [
              const Center(
                child: Text(
                  'No active conversations Yes',
      
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
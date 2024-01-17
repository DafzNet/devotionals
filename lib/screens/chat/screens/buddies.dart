
import 'package:cached_network_image/cached_network_image.dart';
import 'package:devotionals/firebase/dbs/user.dart';
import 'package:devotionals/screens/chat/screens/message_screen.dart';
import 'package:devotionals/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../../utils/models/models.dart';


class BuddyList extends StatefulWidget {
  final String uid;

  const BuddyList({
    required this.uid,
    super.key
    });

  @override
  State<BuddyList> createState() => _BuddyListState();
}

class _BuddyListState extends State<BuddyList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All Users'
        ),

        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark
          ),
      ),


      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child:FutureBuilder(
          future: UserService().getUsersFuture(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: CircularProgressIndicator()),
                ],
              );
            } else if (snapshot.hasError) {
              // There was an error in retrieving the data
              return Text('Something went wrong');
            } else {
              // Data has been successfully loaded
              List<User> allUsers = snapshot.data ?? [];

              return ListView.builder(
                itemCount: allUsers.length,
                itemBuilder: (context, index) {
                  User user = allUsers[index];
                  Hive.box('users').put(user.userID, user.toMap());
                  return user.userID != widget.uid? ListTile(
                    title: Text(user.firstName + ' '+ user.lastName),
                    subtitle: StreamBuilder(
                      stream: UserService().getIsTyping(widget.uid, user.userID),
                      builder: (context, snapshot) {
                        if (snapshot.data == true) {
                          return Text(
                            'typing...',

                          style: TextStyle(
                            fontSize: 10,
                            color: cricColor
                          ),
                          );
                        }
                        return Text(
                          user.memberOfhurch ==true?'Member of Church':'Not a Member of Church',
                          style: TextStyle(
                            fontSize: 10
                          ),
                        );
                      }
                    ),
                  
                    onTap: (){
                      Navigator.push(context,
                      PageTransition(
                        child: MessageDisplayScreen(buddy: user, curUser: widget.uid), 
                        type: PageTransitionType.fade));
                    },
                    trailing: Icon(
                      MdiIcons.chatOutline
                    ),
                    leading: SizedBox(
                      width: 40,
                      height: 40,
                      child: ClipOval(
                        child: FittedBox(child: CachedNetworkImage(imageUrl: user.photoUrl??'https://www.freepik.com/icon/user_1177568#fromView=keyword&term=User&page=1&position=9&uuid=694cc40b-b89d-4277-bad4-f630ee961d26')),
                      ),
                    ),
                  ):Container();
                },
              );
            }
          },
        ),

      ),
    );
  }
}
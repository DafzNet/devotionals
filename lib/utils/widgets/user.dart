import 'package:cached_network_image/cached_network_image.dart';
import 'package:devotionals/utils/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:devotionals/utils/models/models.dart'; // Import your User model

class UserWidget extends StatefulWidget {
  final User user;

  const UserWidget({Key? key, required this.user}) : super(key: key);

  @override
  State<UserWidget> createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(
            widget.user.photoUrl??''
          ),
        ),
        title: Text(
          widget.user.firstName + ' ' + widget.user.lastName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: bodyFontSmall,
            fontWeight: FontWeight.bold
          ),
        ),
        subtitle: Text(
          widget.user.department!= null? widget.user.department!.name:'No in a department',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: bodyFontSmall
          ),
        ),
        // You can add more details to display here
        onTap: () {
          // Perform any action when the user widget is tapped
        },
      ),
    );
  }
}

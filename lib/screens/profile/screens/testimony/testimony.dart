import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devotionals/utils/constants/colors.dart';
import 'package:devotionals/utils/models/testimony_model.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../utils/widgets/cards/testimony.dart';

class Testimony extends StatefulWidget {
  const Testimony({super.key});

  @override
  State<Testimony> createState() => _TestimonyState();
}

class _TestimonyState extends State<Testimony> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Testimonies')),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: ListView(
          children: [
            TestimonyCard(
              testimony: TestimonyModel(
                id: 'id', 
                user: 'hhhhhh',
                timestamp: Timestamp.fromDate(DateTime.now()),
                testimony: 'Pariatur anim amet veniam Pariatur amet ea officia occaecat nostrud est excepteur minim adipisicing. Voluptate duis nisi incididunt cillum Lorem esse cupidatat est incididunt anim est proident. Et amet quis laborum qui ad fugiat. Officia laboris voluptate irure sit aute commodo nostrud.adipisicing do. Duis ea mollit quis amet est aliquip anim ad do. Mollit aute commodo irure ipsum ex ipsum laboris.'),
            ),  
          ],
        ),
      ),


      floatingActionButton: FloatingActionButton(
        backgroundColor: cricColor,
        onPressed: ()async{
        
      },

      child: Icon(
        MdiIcons.fileDocumentPlusOutline,
        color: Colors.white,
      ),
      
      ),

    );



  }
}
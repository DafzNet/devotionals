import 'package:devotionals/screens/profile/screens/notes/note_taker.dart';
import 'package:devotionals/utils/constants/colors.dart';
import 'package:devotionals/utils/models/note_model.dart';
import 'package:devotionals/utils/models/testimony_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';

class TestimonyCard extends StatefulWidget {
  final TestimonyModel testimony;

  TestimonyCard({
    required this.testimony,
    super.key});

  @override
  State<TestimonyCard> createState() => _TestimonyCardState();
}

class _TestimonyCardState extends State<TestimonyCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            child: Container(), 
            type: PageTransitionType.rightToLeft
          )
        );
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 200,
    
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipOval(
                  child: Container(
                    height: 40,
                    width: 40,
                    color: cricColor,
                  ),
                )
              ],
            ),

            SizedBox(width:5),

            Container(
              padding: const EdgeInsets.all(10),
              width: MediaQuery.sizeOf(context).width-70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Color.fromARGB(149, 243, 243, 243)
              ),
    
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //mainAxisAlignment: MainAxisAlignment.sta,
                    children: [
                      Text(
                        'Daniel Ebiodo',
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),

                      SizedBox(height: 10,),
    
                      Expanded(
                        child: Text(
                          widget.testimony.testimony,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                                        
                          ),
                        ),
                      ),

                      const SizedBox(height: 10,),
                      
                    ],
                  ),
    
    
    
                  Positioned(
                    left: 0,
                    bottom: 0,
                    child: SizedBox(
                      height: 40,
                      width: 200,
                      // color: cricColor.shade900,
    
                      child: Center(
                        child: Row(
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
                              onPressed: (){},
                              icon: Icon(
                                MdiIcons.chatOutline,
                              )
                            ),

                            IconButton(
                              onPressed: null,
                              icon: Icon(
                                MdiIcons.circle,
                                color: Color.fromARGB(149, 243, 243, 243),
                              )
                            ),

                            
                          ],
                        ),
                      ),
                    )),


                    
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 30,
                      width: 100,
                      decoration: BoxDecoration(
                        color: cricColor.shade300,
                        borderRadius: BorderRadius.circular(15)
                      ),
    
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            
    
                            Text(
                              DateFormat('d, MMM y').format(widget.testimony.timestamp!.toDate()),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
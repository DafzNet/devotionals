import 'package:devotionals/screens/profile/screens/notes/note_taker.dart';
import 'package:devotionals/utils/constants/colors.dart';
import 'package:devotionals/utils/models/note_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';

class NoteCard extends StatefulWidget {
  final Note note;
  final VoidCallback onDel;
  const NoteCard({
    required this.note,
    required this.onDel,
    super.key});

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
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
    
        child: Container(
          padding: const EdgeInsets.all(10),
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
                  Row(
                    children: [
                      Icon(
                        MdiIcons.notebookOutline,
                        color: cricColor.shade800,
                        size: 14,
                      ),

                      const SizedBox(width: 10,),

                      Expanded(
                        child: Text(
                          widget.note.title,

                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),

                                           
                    ],
                  ),
                  const SizedBox(height: 5,),
    
                  Text(
                    widget.note.body,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
              
                    ),
                  ),

                  const SizedBox(height: 10,),

                  Row(
                    children: [
                      Icon(
                        MdiIcons.circle,
                        color: cricColor,
                        size: 10,
                      ),
                      Text(
                        ' '+widget.note.category,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold
              
                        ),
                      ),

                      SizedBox(width: 10,),

                      Icon(
                        MdiIcons.circle,
                        color: Colors.amber,
                        size: 10,
                      ),
                      
                      ...widget.note.tags.split(',').map((e) => Row(
                        children: [
                          SizedBox(width: 5,),
                          Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color.fromARGB(255, 246, 228, 176))
                            ),
                            child: Text(
                              e,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold
                                        
                              ),
                            ),
                          ),
                        ],
                      ),)

                    ],
                  ),
                ],
              ),
    
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
                          DateFormat('d, MMM y').format(widget.note.date),
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
                            Navigator.push(
                              context,
                              PageTransition(
                                child: NoteTaker(
                                  note: widget.note
                                ), 
                                type: PageTransitionType.fade)
                            );
                          },
                          icon: Icon(
                            MdiIcons.notebookEditOutline
                          )
                        ),

                        IconButton(
                          onPressed: widget.onDel,
                          icon: Icon(
                            MdiIcons.deleteOutline,
                            color: Colors.redAccent,
                          )
                        ),

                        IconButton(
                          onPressed: (){

                          },
                          icon: Icon(
                            MdiIcons.shareVariantOutline
                          )
                        ),
                      ],
                    ),
                  ),
                ))
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:devotionals/screens/devotional/detail.dart';
import 'package:devotionals/screens/profile/screens/notes/note_taker.dart';
import 'package:devotionals/utils/constants/constants.dart';
import 'package:devotionals/utils/models/models.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';

class DevotionalCard extends StatefulWidget {
  final DevotionalModel model;
  const DevotionalCard({
    required this.model,
    super.key});

  @override
  State<DevotionalCard> createState() => _DevotionalCardState();
}

class _DevotionalCardState extends State<DevotionalCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            child: DevotionalDetailScreen(model: widget.model), 
            type: PageTransitionType.rightToLeft
          )
        );
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 220,
    
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
                        MdiIcons.circle,
                        color: cricColor,
                        size: 10,
                      ),

                      const SizedBox(width: 10,),

                      Expanded(
                        child: Text(
                          widget.model.title,

                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),

                      Text(
                        widget.model.openingScriptureReference,
    
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                        ),
                      ),                        
                    ],
                  ),
                  const SizedBox(height: 5,),
    
                  Text(
                    widget.model.body,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
              
                    ),
                  ),

                  Text(
                    'Doing the word: ${widget.model.doingTheWord!}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.abel(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: cricColor
              
                    ),
                  ),
    
    
                ],
              ),
    
              Positioned(
                right: 10,
                bottom: 10,
                child: ClipOval(
                  child: Container(
                    height: 60,
                    width: 60,
                    color: cricColor.shade600,
    
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.model.date.day.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
    
                          Text(
                            DateFormat.MMM().format(widget.model.date),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
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

                          },
                          icon: Icon(
                            MdiIcons.heartOutline
                          )
                        ),

                        IconButton(
                          onPressed: (){
                            Navigator.push(
                              context,
                              PageTransition(
                                child: NoteTaker(

                                ), 
                                type: PageTransitionType.fade)
                            );
                          },
                          icon: Icon(
                            MdiIcons.pencilPlusOutline
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
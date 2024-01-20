import 'package:devotionals/firebase/dbs/devs.dart';
import 'package:devotionals/screens/devotional/add_dev.dart';
import 'package:devotionals/screens/devotional/detail.dart';
import 'package:devotionals/screens/profile/screens/notes/note_taker.dart';
import 'package:devotionals/utils/constants/constants.dart';
import 'package:devotionals/utils/models/models.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:share_plus/share_plus.dart';

class DevotionalCard extends StatefulWidget {
  final DevotionalModel model;
  final String uid;
  const DevotionalCard({
    required this.model,
    required this.uid,
    super.key});

  @override
  State<DevotionalCard> createState() => _DevotionalCardState();
}

class _DevotionalCardState extends State<DevotionalCard> {

  Map<String, bool> reactions = {};

  @override
  void initState() {
    reactions = widget.model.reactions;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            child: DevotionalDetailScreen(model: widget.model, uid: widget.uid,), 
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
                        MdiIcons.notebook,
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
                  ),

                  Text(
                    'Doing the word: ${widget.model.doingTheWord!}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.abel(
                      fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                      fontStyle: FontStyle.italic,
                      color: cricColor
              
                    ),
                  ),
    
    
                ],
              ),
    
              Positioned(
                right: 10,
                bottom: 10,
                child: Container(
                  height: 80,
                  width: 60,
                  decoration: BoxDecoration(
                    color: cricColor.shade600,
                    borderRadius: BorderRadius.circular(10)
                  ),
    
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

                        if(DateTime.now().year != widget.model.date.year)
                          Text(
                          DateFormat.y().format(widget.model.date),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
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
                          onPressed: ()async{

                            Map<String, bool> _l = widget.model.reactions;
                            if (widget.model.reactions.containsKey(widget.uid)) {
                              _l.remove(widget.uid);
                              
                            } else {
                              _l[widget.uid] = true;
                            }

                            final dev = widget.model.copyWith(
                              reactions: _l
                            );

                            await DevotionalService().updateDevotional(dev);

                            reactions = _l;

                            setState(() {
                              
                            });
                          },

                          icon: Row(
                            children: [
                              Icon(
                                reactions.containsKey(widget.uid)? MdiIcons.heart: MdiIcons.heartOutline,
                                color: reactions.containsKey(widget.uid)?Colors.redAccent: null
                              ),

                              Text(
                                reactions.isNotEmpty? reactions.length.toString():'',
                                style: TextStyle(
                                  fontSize: 16
                                ),
                              )
                            ],
                          )
                        ),

                        IconButton(
                          onPressed: (){
                            
                          },
                          icon: Row(
                            children: [
                              Icon(
                                MdiIcons.commentOutline
                              ),

                              Text(
                                widget.model.numberOfComment>0?' '+widget.model.numberOfComment.toString():'',
                                style: TextStyle(
                                  fontSize: 16
                                ),
                              )
                            ],
                          )
                        ),

                        // IconButton(
                        //   onPressed: (){
                        //     Navigator.push(
                        //       context,
                        //       PageTransition(
                        //         child: NoteTaker(
                        //           devotional: widget.model,
                        //         ), 
                        //         type: PageTransitionType.fade)
                        //     );
                        //   },
                        //   icon: Icon(
                        //     MdiIcons.notebookPlusOutline
                        //   )
                        // ),

                        // IconButton(
                        //   onPressed: (){
                        //     Navigator.push(
                        //       context,
                        //       PageTransition(
                        //         child: AddDev(
                        //           model: widget.model,
                        //         ), 
                        //         type: PageTransitionType.fade)
                        //     );
                        //   },
                        //   icon: Icon(
                        //     MdiIcons.pencilPlusOutline
                        //   )
                        // ),

                        IconButton(
                          onPressed: ()async{
                            await Share.share(
                              widget.model.instruction != null && widget.model.instruction!.length>5?"A Word in Due Season\nBy Apostle David Wale Feso\n\n${DateFormat('EEE d, MMM y').format(widget.model.date)}\n\n\""+widget.model.title+
                                  "\"\n\n\""+widget.model.openingScriptureText+"\" - "+widget.model.openingScriptureReference+
                                  "\n\n"+widget.model.body+
                                  '\n\nInstruction\n'+widget.model.instruction!+
                                  '\n\nFurther Scriptures\n'+widget.model.furtherScriptures!+
                                  '\n\nDoing the word\n'+widget.model.doingTheWord!+
                                  '\n\nDaily Scriptural reading\n'+widget.model.dailyScriptureReading!:

                                  widget.model.confession != null && widget.model.confession!.length>5?"A Word in Due Season\nBy Apostle David Wale Feso\n\n${DateFormat('EEE d, MMM y').format(widget.model.date)}\n\n\""+widget.model.title+
                                  "\"\n\n\""+widget.model.openingScriptureText+"\" - "+widget.model.openingScriptureReference+
                                  "\n\n"+widget.model.body+
                                  '\n\nConfession\n'+widget.model.confession!+
                                  '\n\nFurther Scriptures\n'+widget.model.furtherScriptures!+
                                  '\n\nDoing the word\n'+widget.model.doingTheWord!+
                                  '\n\nDaily Scriptural reading\n'+widget.model.dailyScriptureReading!:

                                  "A Word in Due Season\nBy Apostle David Wale Feso\n\n${DateFormat('EEE d, MMM y').format(widget.model.date)}\n\n\""+widget.model.title+
                                  "\"\n\n\""+widget.model.openingScriptureText+"\" - "+widget.model.openingScriptureReference+
                                  "\n\n"+widget.model.body+
                                  '\n\nPrayer\n'+widget.model.prayer!+
                                  '\n\nFurther Scriptures\n'+widget.model.furtherScriptures!+
                                  '\n\nDoing the word\n'+widget.model.doingTheWord!+
                                  '\n\nDaily Scriptural reading\n'+widget.model.dailyScriptureReading!
                            );
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
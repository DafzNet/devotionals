import 'package:devotionals/utils/models/comment.dart';
import 'package:devotionals/utils/widgets/images/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CommentCard extends StatefulWidget {
  final CommentModel comment;
  final VoidCallback? onReply;
  const CommentCard({
    this.onReply,
    required this.comment, super.key});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: GestureDetector(
        onTap: () {
         
        },
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
      
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ClipOval(
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: CachedNetworkImage(imageUrl: widget.comment.user.photoUrl!),
                  ),
                ),
              ),
    
              const SizedBox(width:5),
    
              Container(
                padding: const EdgeInsets.all(10),
                width: MediaQuery.sizeOf(context).width-70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
      
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //mainAxisAlignment: MainAxisAlignment.sta,
                  children: [
                    Text(
                      widget.comment.user.firstName +' '+widget.comment.user.lastName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15
                      ),
                    ),
    
                    Text(
                      DateFormat('d, MMM y').format(widget.comment.date),
                      style: const TextStyle(
                        fontSize: 12
                      ),
                    ),
    
                    const SizedBox(height: 5,),
      
                    Text(
                        widget.comment.comment,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                                      
                        ),
                      ),
    
                    const SizedBox(height: 5,),
    
                    SizedBox(
                    height: 40,
                    width: 180,
                    // color: cricColor.shade900,
      
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        
    
                        IconButton(
                          onPressed: (){
                            
                          },
                          icon: Icon(
                            MdiIcons.thumbUp
                          )
                        ),
    
                        IconButton(
                          onPressed: (){
                            
                          },
                          icon: Icon(
                            MdiIcons.thumbDown
                          )
                        ),
    
                        TextButton(
                          onPressed: widget.onReply,
                          child: Text(
                            'Reply'
                          )
                        ),
                      ],
                    ),
                  )
                    
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
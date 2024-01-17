import 'package:cached_network_image/cached_network_image.dart';
import 'package:devotionals/dbs/sembast/userdb.dart';
import 'package:devotionals/firebase/dbs/devs.dart';
import 'package:devotionals/firebase/dbs/user.dart';
import 'package:devotionals/utils/models/comment.dart';
import 'package:devotionals/utils/models/devotional.dart';
import 'package:devotionals/utils/models/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CommentCard extends StatefulWidget {
  final CommentModel comment;
  final double? width;
  final DevotionalModel dev;
  final VoidCallback? onReply;
  final VoidCallback? onLike;
  final VoidCallback? onDislike;

  final String uid;
  const CommentCard({
    this.onReply,
    required this.uid,
    required this.dev,
    this.onDislike,
    this.onLike,
    this.width,
    required this.comment, super.key});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {

  int takeSize = 1;

  String getFormattedDate() {
    DateTime now = DateTime.now();
    DateTime commentDate = widget.comment.date;

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

  final _store = UserRepo();

  User? _user;
  void _getUser()async{
    if (await _store.containsKey(widget.comment.user.userID)) {
      _user = await _store.get(widget.comment.user.userID);
    } else {
      _user = await UserService().getUser(widget.comment.user.userID);
      _store.insert(_user!);
    }

    setState(() {
      
    });
  }

  @override
  void initState() {
    _getUser();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: GestureDetector(
        onTap: () {
         
        },
        child: SizedBox(
          width: widget.width,
      
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ClipOval(
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: CachedNetworkImage(imageUrl: _user!.photoUrl??''),
                  ),
                ),
              ),
            
              const SizedBox(width:2),
            
              Container(
                padding: const EdgeInsets.all(5),
                width: widget.width!-40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
              
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _user!=null? _user!.firstName+' '+_user!.lastName : widget.comment.user.firstName +' '+widget.comment.user.lastName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15
                      ),
                    ),
                  
                    Text(
                      getFormattedDate(),// DateFormat('d, MMM y').format(widget.comment.date),
                      style: const TextStyle(
                        fontSize: 12
                      ),
                    ),
                  
                    const SizedBox(height: 5,),
                    
                    Text(
                        widget.comment.comment,
                                  
                        style: const TextStyle(
                          fontSize: 14,
                                      
                        ),
                      ),
                  
                    const SizedBox(height: 5,),
                  
                  SizedBox(
                    height: 40,
                    width: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        
                                      
                        IconButton(
                          onPressed: widget.onLike,
                          icon: Row(
                            children: [
                              Icon(
                                widget.comment.likes.contains(widget.uid)?MdiIcons.thumbUp : MdiIcons.thumbUpOutline,
                                color: widget.comment.likes.contains(widget.uid)?Colors.black:Colors.black,
                                size: 18
                              ),
                                
                              SizedBox(width: 3,),
                                
                              Text(
                                widget.comment.likes.length>0? widget.comment.likes.length.toString():'',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          )
                        ),
                                      
                        IconButton(
                          onPressed: widget.onDislike,
                          icon: Row(
                            children: [
                              Icon(
                                widget.comment.dislikes.contains(widget.uid)?MdiIcons.thumbDown : MdiIcons.thumbDownOutline,
                                color: widget.comment.dislikes.contains(widget.uid)?Colors.black:Colors.black,
                                size: 18
                              ),
                                
                              SizedBox(width: 3,),
                                
                              Text(
                                widget.comment.dislikes.length>0? widget.comment.dislikes.length.toString():'',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          )
                        ),
                                      
                        TextButton(
                          onPressed: widget.onReply,
                          child: const Text(
                            'Reply',
                                
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold
                            ),
                          )
                        ),
                      ],
                    ),
                  ),
                
                  SizedBox(height: 5,),
                
                  ...List.generate(widget.comment.replies.take(takeSize).length, (index) => CommentCard(
                      width: widget.width!-43,
                    
                       onLike: () async{
                          List<String> _likes = widget.comment.replies[index].likes;
                          List<String> _dislikes = widget.comment.replies[index].dislikes;

                          CommentModel _current = widget.comment;
                          CommentModel _replyComment = widget.comment.replies[index];
                          List<CommentModel> _allReplied = widget.comment.replies;

                          if(!_likes.contains(widget.uid)) {
                            _allReplied.remove(_replyComment);

                            _likes.add(widget.uid);
                            _dislikes.remove(widget.uid);

                            _replyComment = _replyComment.copyWith(
                              likes: _likes,
                              dislikes: _dislikes,
                            );

                            _allReplied.add(_replyComment);

                            _current = _current.copyWith(
                              replies: _allReplied
                            );

                            await DevotionalService().updateComment(widget.dev.id, 
                              _current
                            );
                          }else{
                            _allReplied.remove(_replyComment);

                            _likes.remove(widget.uid);
                            _dislikes.remove(widget.uid);

                            _replyComment = _replyComment.copyWith(
                              likes: _likes,
                              dislikes: _dislikes,
                            );

                            _allReplied.add(_replyComment);

                            _current = _current.copyWith(
                              replies: _allReplied
                            );

                            await DevotionalService().updateComment(widget.dev.id, 
                              _current
                            );
                          }

                          setState(() {
                            
                          });
                        },


                        onDislike: () async{
                          List<String> _likes = widget.comment.replies[index].likes;
                          List<String> _dislikes = widget.comment.replies[index].dislikes;

                          CommentModel _current = widget.comment;
                          CommentModel _replyComment = widget.comment.replies[index];
                          List<CommentModel> _allReplied = widget.comment.replies;

                          if(!_dislikes.contains(widget.uid)) {
                            _allReplied.remove(_replyComment);

                            _dislikes.add(widget.uid);
                            _likes.remove(widget.uid);

                            _replyComment = _replyComment.copyWith(
                              likes: _likes,
                              dislikes: _dislikes,
                            );

                            _allReplied.add(_replyComment);

                            _current = _current.copyWith(
                              replies: _allReplied
                            );

                            await DevotionalService().updateComment(widget.dev.id, 
                              _current
                            );
                          }else{
                            _allReplied.remove(_replyComment);

                            _dislikes.remove(widget.uid);
                            _likes.remove(widget.uid);

                            _replyComment = _replyComment.copyWith(
                              likes: _likes,
                              dislikes: _dislikes,
                            );

                            _allReplied.add(_replyComment);

                            _current = _current.copyWith(
                              replies: _allReplied
                            );

                            await DevotionalService().updateComment(widget.dev.id, 
                              _current
                            );
                          }

                          setState(() {
                            
                          });
                        },

                    onReply: widget.onReply,

                    dev: widget.dev,
                    uid: widget.uid, 
                    comment: widget.comment.replies[index])
                    ),

                    if(widget.comment.replies.length > takeSize)...
                      [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                takeSize +=2; 
                              });
                            },
                        
                            child: Icon(
                              MdiIcons.dotsHorizontal
                            ),
                          ),
                        ),
                        
                      ]
                    
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
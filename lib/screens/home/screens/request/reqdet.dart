import 'package:devotionals/firebase/dbs/user.dart';
import 'package:devotionals/utils/models/comment.dart';
import 'package:devotionals/utils/models/prayerreq.dart';
import 'package:devotionals/utils/widgets/cards/comment_card.dart';
import 'package:devotionals/utils/widgets/cards/request_comment.dart';
import 'package:devotionals/utils/widgets/click_text.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../firebase/dbs/prayerrequest.dart';
import '../../../../utils/models/user.dart';

class RequestDetails extends StatefulWidget {
  final PrayerRequest req;
  final String uid;
  const RequestDetails({
    required this.req,
    required this.uid,
    super.key});

  @override
  State<RequestDetails> createState() => _RequestDetailsState();
}

class _RequestDetailsState extends State<RequestDetails> {
  final  ScrollController _scrollController = ScrollController();
  final _commentFocus = FocusNode();
  final commentController = TextEditingController();

  
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        loadComments();
        
      }
    });
    
  }

  double commentTextFieldHeight = 0;
  CommentModel? replyingComment;

  List<CommentModel> _comments = [];

  void loadComments()async{
    final c = await PrayerFire().getComments(widget.req.id);

    c.sort((a, b){
      return b.date.compareTo(a.date);
    });

    _comments = c;
    
    print(_comments);

    setState(() {
      
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar.medium(
                floating: true,
                pinned: true,
                title: Text(widget.req.title),
      
                actions: [
                 
                ],
                
                
              ),
            ];
          },
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: ClickableText(
                  text:  widget.req.request,
                  context: context,
                  
                  
                ),
              ),


              const SizedBox(height: 20,),

                              ...List.generate(
                                _comments.length,
                                (index){
                                  return RequestCommentCard(
                                    width: MediaQuery.sizeOf(context).width-20,
                                    req: widget.req,
                                    comment: _comments[index], 
                                    uid: widget.uid,
                                    onReply: (){
                                      commentTextFieldHeight = 70;
                                      replyingComment = _comments[index];

                                      setState(() {
                                        
                                      });
                                    },
                                    onLike: () async{
                                      List<String> _likes = _comments[index].likes;
                                      List<String> _dislikes = _comments[index].dislikes;

                                      if(!_likes.contains(widget.uid)) {
                                        _likes.add(widget.uid);
                                        _dislikes.remove(widget.uid);
                                        await PrayerFire().updateComment(widget.req.id, 
                                          _comments[index].copyWith(
                                            dislikes: _dislikes
                                          )
                                        );
                                      }else{
                                        _likes.remove(widget.uid);
                                        _dislikes.remove(widget.uid);
                                        await PrayerFire().updateComment(widget.req.id, 
                                          _comments[index].copyWith(
                                            likes: _likes,
                                            dislikes: _dislikes
                                          )
                                        );
                                      }

                                      setState(() {
                                        
                                      });
                                    },

                                    onDislike: () async{
                                      List<String> _dislikes = _comments[index].dislikes;
                                       List<String> _likes = _comments[index].likes;

                                      if(!_dislikes.contains(widget.uid)) {

                                        _dislikes.add(widget.uid);
                                         _likes.remove(widget.uid);
                                        

                                        await PrayerFire().updateComment(widget.req.id, 
                                          _comments[index].copyWith(
                                            dislikes: _dislikes,
                                            likes: _likes
                                          )
                                        );
                                      }else{
                                        _dislikes.remove(widget.uid);
                                        _likes.remove(widget.uid);
                                        
                                        await PrayerFire().updateComment(widget.req.id, 
                                          _comments[index].copyWith(
                                            dislikes: _dislikes,
                                            likes: _likes
                                          )
                                        );
                                      }

                                      setState(() {
                                        
                                      });
                                    },
                                  );
                                }
                              ),


                              Focus(
                  onFocusChange: (focus){
                    if(focus){
                      setState(() {
                        commentTextFieldHeight = 70;
                      });
                    }else{
                      
                      setState(() {
                        commentTextFieldHeight = 0;
                      });
                    }
                  },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      height: commentTextFieldHeight,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 243, 247, 244)
                      ),
                      child: Row(
                        children: [
                          Icon(
                            MdiIcons.comment,
                            color: Colors.amber,
                            size: 25,
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                border: Border.all(width: .4),
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: TextField(
                                  textCapitalization: TextCapitalization.sentences,
                                  maxLines: 3,
                                  minLines: 2,
                                  focusNode: _commentFocus,
                                  autocorrect: true,
                                  controller: commentController,
                                  
                                  decoration: InputDecoration.collapsed(
                                    hintText: replyingComment != null? 'reply @${replyingComment!.user.firstName} ${replyingComment!.user.lastName}' : 'write your thoughts',
                                    hintStyle: TextStyle(
                                      
                                    )
                                    
                                  ),
                                ),
                            ),
                          ),

                          IconButton(
                            onPressed:()async{
                              commentTextFieldHeight = 0;
                              setState(() {
                                
                              });

                              if (commentController.text.isNotEmpty && commentController.text.trim().length>4 && replyingComment == null) {
                                User? user = await UserService().getUser(widget.uid);
                                final comment = CommentModel(id: DateTime.now().millisecondsSinceEpoch.toString()+widget.uid, comment: commentController.text, user: user!, date: DateTime.now());
                                await PrayerFire().createComment(widget.req.id, comment);
                                
                              }


                              if (commentController.text.isNotEmpty && commentController.text.trim().length>4 && replyingComment != null) {
                                User? user = await UserService().getUser(widget.uid);
                                var _r = replyingComment!.replies;
                                _r.add(CommentModel(id: DateTime.now().millisecondsSinceEpoch.toString()+widget.uid, comment: commentController.text, user: user!, repliedUser: replyingComment!.user, date: DateTime.now()));
                                final comment = replyingComment!.copyWith(
                                  replies: _r
                                );
                                await PrayerFire().updateComment(widget.req.id, comment);
                                replyingComment = null;

                                setState(() {
                                  
                                });
                                
                              }

                              commentController.text = '';
                            } , 
                            icon: Icon(
                              MdiIcons.sendVariantOutline
                            ))

                        ],
                      ),
                    ),
                  )
            ]
          )
        )
      )
    );
  }
}
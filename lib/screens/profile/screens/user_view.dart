import 'package:cached_network_image/cached_network_image.dart';
import 'package:devotionals/firebase/file_storage.dart';
import 'package:devotionals/screens/profile/screens/edit.dart';
import 'package:devotionals/utils/constants/colors.dart';
import 'package:devotionals/utils/widgets/images/selector.dart';
import 'package:devotionals/utils/widgets/photoView.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import '../../../firebase/dbs/user.dart';
import '../../../utils/models/user.dart';

class UserView extends StatefulWidget {
  final User user;
  final String currentUserID;
  const UserView({
    required this.user,
    required this.currentUserID,
    super.key});

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {

  final _imagePickerCrop = ImagePickerCropper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(''),
          
          flexibleSpace: FlexibleSpaceBar(
          background: Container(
            decoration: BoxDecoration(
              gradient: SweepGradient(
                colors: [
                  cricColor.shade300,
                  cricColor.shade200,
                  cricColor.shade300,
                  cricColor.shade200,
                  cricColor.shade300,
                  cricColor.shade200,
                  cricColor.shade300,
                  cricColor.shade200,
                  cricColor.shade300,
                  cricColor.shade200,
                  cricColor.shade300,
                  cricColor.shade100
                ]
              )
            ),
          ),
        ),

          actions: [
            widget.currentUserID == widget.user.userID?
              IconButton(
                onPressed: () async{
                        await showModalBottomSheet(
                          context: context, 
                          builder: (context){
                            return SizedBox(
                              height: 150,
                              child: ListView(
                                children: [
                                  ListTile(
                                    leading: Icon(
                                      MdiIcons.accountOutline
                                    ),

                                    title: Text(
                                      'Update Profile'
                                    ),
              
                                    onTap: () {
                                      Navigator.pop(context);

                                      Navigator.push(
                                      context,
                                      PageTransition(
                                        child: EditProfile(user: widget.user,),
                                        type: PageTransitionType.fade
                                      )
                                    );
              
                                      setState(() {
                                        
                                      });
                                    },
                                  ),


                                  ListTile(
                                    leading: Icon(
                                      MdiIcons.camera
                                    ),

                                    title: Text(
                                      'Update Profile Photo'
                                    ),
              
                                    onTap: () async{
                                      Navigator.pop(context);

                                        final _file = await _imagePickerCrop.imgFromGallery();

                                        if (_file != null) {
                                          String? dl = await uploadFileToFirebaseStorage(_file, 'profile/${widget.user}');
                                          
                                          final u = widget.user.copyWith(
                                            photoUrl: dl
                                          
                                          );
                                          await UserService().updateUser(u);

                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully uploaded file')));

                                          setState(() {
                                            
                                          });

                                        }

                                      setState(() {
                                        
                                      });
                                    },
                                  ),

                                ],
                              ),
                            );
                          }
                        );
                      }, 
                icon: Icon(
                  MdiIcons.dotsVertical
                )
              ):Container()
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: SweepGradient(
                    colors: [
                      cricColor.shade300,
                      cricColor.shade200,
                      cricColor.shade300,
                      cricColor.shade200,
                      cricColor.shade300,
                      cricColor.shade200,
                      cricColor.shade300,
                      cricColor.shade200,
                      cricColor.shade300,
                      cricColor.shade200,
                      cricColor.shade300,
                      cricColor.shade200
                    ]
                  )
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        widget.user.photoUrl != null? Navigator.push(
                          context,
                          PageTransition(child: ImageViewer(img: widget.user.photoUrl!), type: PageTransitionType.fade)
                        ):null;
                      },
                      child: SizedBox(
                        height: 130,
                        width: 130,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100)
                          ),
                          child: ClipOval(
                            child: Hero(
                              tag: widget.user.email,
                              child: CachedNetworkImage(
                                imageUrl: widget.user.photoUrl??''),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      widget.user.firstName +' '+ widget.user.lastName,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      widget.user.email,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bio:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      widget.user.bio,
                      style: TextStyle(fontSize: 16),
                    ),

                    
                    SizedBox(height: 20),
                    Text(
                      'Gender:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      widget.user.gender!,
                      style: TextStyle(fontSize: 16),
                    ),
                    
                    SizedBox(height: 20),
                    Text(
                      'Phone:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      widget.user.phone,
                      style: TextStyle(fontSize: 16),
                    ),

                    SizedBox(height: 20),
                    Text(
                      'Membership:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      widget.user.memberOfhurch!=null && widget.user.memberOfhurch!?'Member of CRIC':'Not a Member of CRIC',
                      style: TextStyle(fontSize: 16),
                    ),

                    SizedBox(height: 20),
                    Text(
                      'Date of Birth:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      DateFormat('MMM d, y').format(widget.user.dateOfBirth),
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }
}
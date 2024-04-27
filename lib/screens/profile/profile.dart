
import 'package:cached_network_image/cached_network_image.dart';
import 'package:devotionals/dbs/sembast/userdb.dart';
import 'package:devotionals/firebase/auth.dart';
import 'package:devotionals/firebase/dbs/user.dart';
import 'package:devotionals/firebase/file_storage.dart';
import 'package:devotionals/screens/profile/screens/giving.dart';
import 'package:devotionals/screens/profile/screens/testimony/testimony.dart';
import 'package:devotionals/screens/profile/screens/user_view.dart';
import 'package:devotionals/utils/constants/constants.dart';
import 'package:devotionals/utils/models/user.dart';
import 'package:devotionals/utils/widgets/images/selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'screens/about.dart';
import 'screens/edit.dart';
import 'screens/notes/note.dart';

class Profile extends StatefulWidget {
  final String user;
  const Profile({
    required this.user,
    super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  User? _user;


    void getUser()async{
      if (await UserRepo().containsKey(widget.user)) {
        _user = await UserRepo().get(widget.user);
        print('yes');
      } else {
        _user = await UserService().getUser(widget.user);
        await UserRepo().insert(_user!);
      }
      setState(() {
        
      });
    }


  void _showPopupMenu(BuildContext context, Offset position) async {
      double yOffset = position.dy - 20.0;

  // Ensure the yOffset is non-negative
      yOffset = yOffset < 0 ? 0 : yOffset;
      
      await showMenu(
        context: context,
        position: RelativeRect.fromLTRB(position.dx, yOffset, position.dx + 1, yOffset+ 1),
        items: [
          PopupMenuItem<String>(
            onTap: () async{
             final _file= await _imagePickerCrop.imgFromCamera();

            
              if (_file != null) {
                String? dl = await uploadFileToFirebaseStorage(_file, 'profile/${widget.user}');
                 dlink = dl;
                final u = _user!.copyWith(
                  photoUrl: dl
                 
                );

                await UserService().updateUser(u);

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully uploaded file')));


                setState(() {
                  
                });

              }

             
            },
            value: '',
            child: Row(
              children: [
                Icon(MdiIcons.cameraOutline, size: 18,),
                SizedBox(width: 10,),
                Text('Camera'),
              ],
            ),
          ),


          PopupMenuItem<String>(
            onTap: ()async {
              final _file = await _imagePickerCrop.imgFromGallery();

              if (_file != null) {
                String? dl = await uploadFileToFirebaseStorage(_file, 'profile/${widget.user}');
                 dlink = dl;
                final u = _user!.copyWith(
                  photoUrl: dl
                 
                );
                await UserService().updateUser(u);

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully uploaded file')));

                setState(() {
                  
                });

              }


            },
            value: '',
            child: Row(
              children: [
                Icon(MdiIcons.viewGalleryOutline, size: 18,),
                SizedBox(width: 10,),
                Text('Gallery'),
              ],
            ),
          ),
         
        ],
      );
    }

  final _imagePickerCrop = ImagePickerCropper();

  String? dlink;

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 00,
        
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
                  cricColor.shade200
                ]
              )
            ),
          ),
        ),

        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light
          ),
      ),


      body: _user != null? Column(
        children: [
          Expanded(
            child: Column(
              children: [
                
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(child: UserView(user: _user!, currentUserID: _user!.userID,), type: PageTransitionType.bottomToTop)
                    );
                  },
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 85,
                            width: MediaQuery.of(context).size.width,

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
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: SizedBox(
                              width: 80,
                              height: 80,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  SizedBox(
                                    height: 80,
                                    width: 80,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: cricColor.shade200,
                                        borderRadius: BorderRadius.circular(100),
                                        border: Border.all(
                                          color: Theme.of(context).scaffoldBackgroundColor,
                                          width: 2
                                        )
                                      ),
                          
                                      child: ClipOval(
                                        child: Hero(tag: _user!.email!, child: CachedNetworkImage(imageUrl: _user!.photoUrl??'https://www.freepik.com/icon/user_1177568#fromView=keyword&term=User&page=1&position=9&uuid=694cc40b-b89d-4277-bad4-f630ee961d26')),
                                      ),
                                    ),
                                  ),
                                        
                                  Positioned(
                                    right: 3,
                                    bottom: 3,
                                    child: GestureDetector(
                                      onTapDown: (d)async{
                                        _showPopupMenu(context, d.globalPosition);
                                      },
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.circular(50)
                                        ),
                                        child: IconButton(
                                          padding: EdgeInsets.all(0),
                                          onPressed: (){}, 
                                          icon: Icon(MdiIcons.cameraOutline, size: 16, color: Color.fromARGB(255, 245, 244, 244),),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                
                          Positioned(
                            left: 110,
                            top: 20,
                            child: Text(
                              '${_user!.firstName} ${_user!.lastName}',
                              
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white
                              ),
                            ),
                          ),
                
                          Positioned(
                            left: 110,
                            bottom: 20,
                            child: Text(
                              _user!.email!,
                                              
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade200
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                    ],
                  ),
                ),
            
            
                const SizedBox(
                  height: 30,
                ),
            
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: cricColor.shade100)
                        ),
                        child: Column(
                          children: [
                            
                            // const Divider(),
                            TextButton(
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    child: Testimony(),
                                    type: PageTransitionType.fade
                                  )
                                );
                              },
                              style: TextButton.styleFrom(
                                shape: const RoundedRectangleBorder(),
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5)
                              ),
                              child: Row(
                                children:  [
                                  Icon(
                                    MdiIcons.microphoneVariant
                                  ),
                                  SizedBox(width: 10,),
                                  
                                  Expanded(child: Text('Testimonies', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),)),
                                  
                                  Icon(MdiIcons.chevronRight)
                                ],)
                            ),

                            const SizedBox(height: 10,),
                    
                            // const Divider(),
                            TextButton(
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    child: Giving(),
                                    type: PageTransitionType.fade
                                  )
                                );
                              },
                              style: TextButton.styleFrom(
                                shape: const RoundedRectangleBorder(),
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5)
                              ),
                              child: Row(
                                children:  [
                                  Icon(
                                    MdiIcons.creditCardOutline
                                  ),
                                  SizedBox(width: 10,),
                                  
                                  Expanded(child: Text('Giving', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),)),
                                  
                                  Icon(MdiIcons.chevronRight)
                                ],)
                            ),

                            const SizedBox(height: 10,),
                    
                            // const Divider(),
                            TextButton(
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    child: Container(),
                                    type: PageTransitionType.fade
                                  )
                                );
                              },
                              style: TextButton.styleFrom(
                                shape: const RoundedRectangleBorder(),
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5)
                              ),
                              child: Row(
                                children:  [
                                  Icon(
                                    MdiIcons.toolboxOutline
                                  ),
                                  SizedBox(width: 10,),
                                  
                                  Expanded(child: Text('Resources', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),)),
                                  
                                  Icon(MdiIcons.chevronRight)
                                ],)
                            ),

                            const SizedBox(height: 10,),
                            // Divider(),
                            TextButton(
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    child: NoteScreen(),
                                    type: PageTransitionType.fade
                                  )
                                );
                              },
                              style: TextButton.styleFrom(
                                shape: const RoundedRectangleBorder(),
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5)
                              ),
                              child: Row(
                                children:  [
                                  Icon(
                                    MdiIcons.notebookOutline
                                  ),
                                  SizedBox(width: 10,),
                                  
                                  Expanded(child: Text('My Notes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),)),
                                  
                                  Icon(MdiIcons.chevronRight)
                                ],)
                            ),

                            const SizedBox(height: 10,),
                            // const Divider(),
                            TextButton(
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    child: Container(),
                                    type: PageTransitionType.fade
                                  )
                                );
                              },
                              style: TextButton.styleFrom(
                                shape: const RoundedRectangleBorder(),
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5)
                              ),
                              child: Row(
                                children:  [
                                  Icon(
                                    MdiIcons.baby
                                  ),
                                  SizedBox(width: 10,),
                                  
                                  Expanded(child: Text('Child Dedication', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),)),
                                  
                                  Icon(MdiIcons.chevronRight)
                                ],)
                            ),
                    
                            const SizedBox(height: 10,),
                            // const Divider(),
                            TextButton(
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    child: Container(),
                                    type: PageTransitionType.fade
                                  )
                                );
                              },
                              style: TextButton.styleFrom(
                                shape: const RoundedRectangleBorder(),
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5)
                              ),
                              child: Row(
                                children:  [
                                  Icon(
                                    MdiIcons.at
                                  ),
                                  SizedBox(width: 10,),
                                  
                                  Expanded(child: Text('Contact & Appointments', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),)),
                                  
                                  Icon(MdiIcons.chevronRight)
                                ],)
                            ),
                    
                            const SizedBox(height: 10,),
                            // const Divider(),
                            TextButton(
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    child: AboutWidget(),
                                    type: PageTransitionType.fade
                                  )
                                );
                              },
                              style: TextButton.styleFrom(
                                shape: const RoundedRectangleBorder(),
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4)
                              ),
                              child: Row(
                                children:  [
                                  Image.asset(
                                    logo,
                                    width: 30,
                                    height: 30,
                                  ),
                                  SizedBox(width: 10,),
                                  
                                  Expanded(child: Text('About us', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),)),
                                  
                                  Icon(MdiIcons.chevronRight)
                                ],)
                            ),
                    
                    
                            
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            
            
                const SizedBox(height: 10,),


                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      TextButton.icon(
                        onPressed: ()async{
                          final _auth = AuthService();
                          UserService().setPresence(_user!.userID, false);
                          
                          await _auth.signOut();

                          setState(() {
                            
                          });
                        }, 
                        icon: Icon(
                          MdiIcons.logout,
                          color: Colors.redAccent,
                        ),
                
                        label: Text('Log Out', style: TextStyle(color: Colors.redAccent, fontSize: 18, fontWeight: FontWeight.w500),)
                      ),
                    ],
                  ),
                )
            
              ],
            ),
          )
        ],
      ):Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
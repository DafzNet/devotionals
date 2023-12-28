import 'package:devotionals/firebase/auth.dart';
import 'package:devotionals/firebase/dbs/user.dart';
import 'package:devotionals/utils/constants/constants.dart';
import 'package:devotionals/utils/models/user.dart';
import 'package:devotionals/utils/widgets/images/selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'screens/edit.dart';
import 'screens/notes/note.dart';

class Profile extends StatefulWidget {
  final User user;
  const Profile({
    required this.user,
    super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

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
             await _imagePickerCrop.imgFromCamera();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 30,

        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark
          ),
      ),


      body: Column(
        children: [

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: 140,
                      height: 140,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          SizedBox(
                            height: 130,
                            width: 130,
                            child: Container(
                              decoration: BoxDecoration(
                                color: cricColor.shade200,
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                  color: cricColor.shade800
                                )
                              ),
                            ),
                          ),
              
                          Positioned(
                            right: 10,
                            bottom: 10,
                            child: GestureDetector(
                              onTapDown: (d)async{
                                _showPopupMenu(context, d.globalPosition);
                              },
                              child: Container(
                                width: 29,
                                height: 29,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(50)
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.all(0),
                                  onPressed: (){}, 
                                  icon: Icon(MdiIcons.cameraOutline, size: 20, color: Color.fromARGB(255, 245, 244, 244),),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
              
                    const SizedBox(
                      height: 10,
                    ),
              
                    Text(
                      '${widget.user.firstName} ${widget.user.lastName}',
              
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600
                      ),
                    ),
              
              
                    const SizedBox(
                      height: 5,
                    ),
              
              
                    const SizedBox(
                      height: 5,
                    ),
              
                    Text(
                      widget.user.email,
              
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        
                      ),
                    ),
              
            
                    const SizedBox(
                      height: 20,
                    ),
            
            
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        children: [
                          TextButton(
                            onPressed: (){
                              Navigator.push(
                                context,
                                PageTransition(
                                  child: EditProfile(),
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
                                  MdiIcons.accountOutline
                                ),
                                SizedBox(width: 10,),

                                Expanded(child: Text('Edit Profile', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),)),
                                
                                Icon(MdiIcons.chevronRight)
                              ],)
                          ),
                    
                          const Divider(),
                          TextButton(
                            onPressed: (){
                              Navigator.push(
                                context,
                                PageTransition(
                                  child: EditProfile(),
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

                          const Divider(),
                          TextButton(
                            onPressed: (){
                              Navigator.push(
                                context,
                                PageTransition(
                                  child: EditProfile(),
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

                          const Divider(),
                          TextButton(
                            onPressed: (){
                              Navigator.push(
                                context,
                                PageTransition(
                                  child: EditProfile(),
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

                          Divider(),
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

                          const Divider(),
                          TextButton(
                            onPressed: (){
                              Navigator.push(
                                context,
                                PageTransition(
                                  child: EditProfile(),
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


                          const Divider(),
                          TextButton(
                            onPressed: (){
                              Navigator.push(
                                context,
                                PageTransition(
                                  child: EditProfile(),
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


                          
                        ],
                      ),
                    ),
            
            
                    const SizedBox(height: 10,),
            
            
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Text('Version 1.01')
                      ],),


                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          TextButton.icon(
                            onPressed: ()async{
                              final _auth = AuthService();
                              UserService().setPresence(widget.user.userID, false);
                              
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
              ),
            ),
          )
        ],
      ),
    );
  }
}
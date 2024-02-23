import 'package:devotionals/firebase/dbs/user.dart';
import 'package:devotionals/utils/constants/constants.dart';
import 'package:devotionals/utils/models/user.dart';
import 'package:devotionals/utils/widgets/default.dart';
import 'package:devotionals/utils/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../dbs/sembast/userdb.dart';
import '../../../utils/widgets/textfields.dart';


class EditProfile extends StatefulWidget {
  final User user;
  const EditProfile({
    required this.user,
    super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  final departmentController = TextEditingController();
  final cellController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final bioController = TextEditingController();
  final membershipController = TextEditingController();

  bool loading = false;
   List<String> departments = ['Maintenance', 'New Sound', 'Welcomers', 'Ushers', 'Greeters', 'Protocol'];
  List<String> cells = ['Custom', 'Azikoro', 'Agudama', 'Amarata', 'Benin'];


  final dobController = TextEditingController();

  DateTime? selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Edit Profile'
        ),
      ),

      body: LoadingIndicator(
        loading: loading,
        child: Column(
          children: [
            Divider(
              height: 2,
            ),
        
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12) ,
                child: SingleChildScrollView(
                  physics: loading? NeverScrollableScrollPhysics():AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 20,),
                  
                      SingleLineField(
                        '',
                        headerText: 'First name',
                        controller: firstNameController,
      
                        onChanged: (){
                          setState(() {
                            
                          });
                        },
                      ),
                  
                  
                      const SizedBox(height: 20,),
                      
                      SingleLineField(
                        '',
                        headerText: 'Last name',
                        controller: lastNameController,
      
                        onChanged: (){
                          setState(() {
                            
                          });
                        },
                      ),
                  
                      const SizedBox(height: 20,),
                      
                      SingleLineField(
                        'what do you say of yourself',
                        headerText: 'Bio',
                        controller: bioController,
                        minLines: 5,
                        maxLines: 10,
      
                        onChanged: (){
                          setState(() {
                            
                          });
                        },
                      ),
                  
                      const SizedBox(height: 20,),
                      
                      SingleLineField(
                        'Are you a member?',
                        headerText: 'Membership',
                        controller: membershipController,
                  
                        makeButton: true,
                  
                        onTap: () async{
                          await showModalBottomSheet(
                            context: context, 
                            builder: (context){
                              return SizedBox(
                                height: 130,
                                child: ListView(
                                  children: [
                                    ListTile(
                                      title: Text(
                                        'Yes'
                                      ),
                
                                      onTap: () {
                                        Navigator.pop(context);
                                        membershipController.text ='yes';
                
                                        setState(() {
                                          
                                        });
                                      },
                                    ),
            
                                    ListTile(
                                      title: Text(
                                        'No'
                                      ),
                
                                      onTap: () {
                                        Navigator.pop(context);
                                        membershipController.text ='No';
                
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
                      ),
                  
                      const SizedBox(height: 20,),
                      
                      SingleLineField(
                        '',
                        headerText: 'Department',
                        controller: departmentController,
                  
                        makeButton: true,
                  
                        onTap: () async{
                          await showModalBottomSheet(
                            context: context, 
                            builder: (context){
                              return SizedBox(
                                height: 500,
                                child: ListView(
                                  children: List.generate(departments.length, (index) =>
                                    ListTile(
                                      title: Text(
                                        departments[index]
                                      ),
                
                                      onTap: () {
                                        Navigator.pop(context);
                                        departmentController.text =departments[index];
                
                                        setState(() {
                                          
                                        });
                                      },
                                    ),
                                  ).toList(),
                                ),
                              );
                            }
                          );
                        },
                      ),
                  
                      const SizedBox(height: 20,),
                  
                      SingleLineField(
                        '',
                        headerText: 'Cell',
                        controller: cellController,
                  
                        makeButton: true,
                  
                  onTap: () async{
                    await showModalBottomSheet(
                      context: context, 
                      builder: (context){
                        return SizedBox(
                          height: 500,
                          child: ListView(
                            children: List.generate(cells.length, (index) =>
                              ListTile(
                                title: Text(
                                  departments[index]
                                ),
                  
                                onTap: () {
                                  Navigator.pop(context);
                                    cellController.text =cells[index];
                  
                                  setState(() {
                                    
                                  });
                                },
                              ),
                            ).toList(),
                          ),
                        );
                      }
                    );
                  },
                      ),
                  
                      SizedBox(height: 20,),
                      
                      SingleLineField(
                    '',
                    controller: dobController,
                    headerText: 'Date of Birth',
                    suffixIcon: MdiIcons.calendar,
                    makeButton: true,
                  
                    onTap: () async{
                      DateTime? date = await showDatePicker(
                        context: context, 
                        initialDate: new DateTime(2010), 
                        firstDate: new DateTime(1900),
                        lastDate: new DateTime(2050),
                  
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              primaryColor: cricColor,
                              colorScheme: ColorScheme.light(
                                primary: cricColor, // Header text color
                                onPrimary: Colors.white, // Header background text color
                                surface: cricColor.shade100,
                                onSurface: Colors.black,
                              ),
                              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary), // Button text color
                            ),
                            child: child!,
                          );
                        },
                      );
                  
                      if (date != null) {
                        dobController.text = DateFormat('E d, MMM yyyy').format(date);
                        selected = date;
                      } else {
                        dobController.text = '';
                      }
                  
                      setState(() {
                        
                      });
                      
                    },
                  ),
                  
                      const SizedBox(height: 60,),
                  
                  
                      DefaultButton(
                        text: 'Save Changes',
                        active: firstNameController.text.isNotEmpty||lastNameController.text.isNotEmpty||bioController.text.isNotEmpty||
                                membershipController.text.isNotEmpty||departmentController.text.isNotEmpty||cellController.text.isNotEmpty||
                                dobController.text.isNotEmpty,
      
                        onTap: ()async{
      
                          setState(() {
                            loading = true;
                          });
      
                          User updatedUser = widget.user.copyWith(
                            firstName: firstNameController.text.isNotEmpty ? firstNameController.text:widget.user.firstName,
                            lastName: lastNameController.text.isNotEmpty ? lastNameController.text:widget.user.lastName,
                            bio: bioController.text.isNotEmpty ? bioController.text:widget.user.bio,
                            memberOfhurch: membershipController.text.isNotEmpty && membershipController.text.toLowerCase() == 'yes'?true:widget.user.memberOfhurch,
                            department: departmentController.text.isNotEmpty ? departmentController.text:widget.user.department,
                            cell: cellController.text.isNotEmpty ? cellController.text:widget.user.cell,
                            dateOfBirth: dobController.text.isNotEmpty ? selected : widget.user.dateOfBirth
                          );
      
      
                          await UserService().updateUser(updatedUser);

                          await UserRepo().insert(updatedUser);

                          print('done');
      
                          setState(() {
                            loading = false;
                          });
      
                          Navigator.pop(context);
      
                          
                        },
                      ),
      
                      SizedBox(height: 20,)
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
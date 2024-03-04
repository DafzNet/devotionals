// ignore_for_file: prefer_const_constructors


import 'package:devotionals/utils/models/user.dart';
import 'package:devotionals/utils/widgets/default.dart';
import 'package:devotionals/utils/widgets/textfields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';




class SignUpPage2a extends StatefulWidget {

  final Function(User)? onTap;

  const SignUpPage2a({
    this.onTap,
    super.key
    });

  @override
  State<SignUpPage2a> createState() => _SignUpPage2aState();
}

class _SignUpPage2aState extends State<SignUpPage2a> {


  final memberController = TextEditingController();
  final departmentController = TextEditingController();
  final departmentBelongController = TextEditingController();
  final cellController = TextEditingController();
  final cellBelongController = TextEditingController();

  List<String> departments = ['Maintenance', 'New Sound', 'Welcomers', 'Ushers', 'Greeters', 'Protocol'];
  List<String> cells = ['Custom', 'Azikoro', 'Agudama', 'Amarata', 'Benin'];

  User _user = User(userID: '', firstName:'', lastName: '', dateOfBirth: DateTime(1900), email: '', phone: '');


  bool enable(){
    if (memberController.text.toLowerCase() == 'no') {
      return true;
    }
    if (memberController.text.toLowerCase() == 'yes') {
      if (departmentController.text.toLowerCase() == 'no' && cellController.text.toLowerCase() == 'no') {
        return true;
      }
      else if ((departmentController.text.toLowerCase() == 'no' && cellBelongController.text.isNotEmpty) || (departmentController.text.isNotEmpty && cellBelongController.text.toLowerCase() == 'no')) {
        return true;
      }
      else{
        if (departmentBelongController.text.isNotEmpty && cellBelongController.text.isNotEmpty){
          return true;
        }
      }

    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
      
            Text(
                'Membership',
                style: TextStyle(
                  fontSize: 20
                )
              ),
      
            SizedBox(
              height: 20,
            ),
      
            
            SingleLineField(
              'Are you a member of CRIC?',
              controller: memberController,
              makeButton: true,
      
              onTap: () async{
                await showModalBottomSheet(
                  context: context, 
                  builder: (context){
                    return SizedBox(
                      height: 150,
                      child: ListView(
                        children: [
                          ListTile(
                            title: Text(
                              "Yes, I am a member"
                            ),
      
                            onTap: () {
                              Navigator.pop(context);
                              memberController.text = "Yes";
      
                              setState(() {
                                
                              });
                            },
                          ),
                    
                          ListTile(
                            title: Text(
                              "No, not a member yet"
                            ),
      
                            onTap: () {
                              Navigator.pop(context);
                              memberController.text = "No";
      
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
            
      
            if(memberController.text == 'Yes')...[
              SizedBox(height: 15,),
      
              SingleLineField(
              'Are you in any department?',
              controller: departmentController,
              makeButton: true,
      
              onTap: () async{
                await showModalBottomSheet(
                  context: context, 
                  builder: (context){
                    return SizedBox(
                      height: 150,
                      child: ListView(
                        children: [
                          ListTile(
                            title: Text(
                              "Yes"
                            ),
      
                            onTap: () {
                              Navigator.pop(context);
                              departmentController.text = "Yes";
      
                              setState(() {
                                
                              });
                            },
                          ),
                    
                          ListTile(
                            title: Text(
                              "No"
                            ),
      
                            onTap: () {
                              Navigator.pop(context);
                              departmentController.text = "No";
      
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
      
      
            if(departmentController.text == 'Yes')...[
              SizedBox(height: 15,),
      
              SingleLineField(
              'Please select your department',
              controller: departmentBelongController,
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
                              departmentBelongController.text =departments[index];
      
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
            ],
      
      
            SizedBox(height: 15,),
      
              SingleLineField(
              'Are you in any Cell?',
              controller: cellController,
              makeButton: true,
      
              onTap: () async{
                await showModalBottomSheet(
                  context: context, 
                  builder: (context){
                    return SizedBox(
                      height: 150,
                      child: ListView(
                        children: [
                          ListTile(
                            title: Text(
                              "Yes"
                            ),
      
                            onTap: () {
                              Navigator.pop(context);
                              cellController.text = "Yes";
      
                              setState(() {
                                
                              });
                            },
                          ),
                    
                          ListTile(
                            title: Text(
                              "No"
                            ),
      
                            onTap: () {
                              Navigator.pop(context);
                              cellController.text = "No";
      
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
      
      
            if(cellController.text == 'Yes')...[
              SizedBox(height: 15,),
      
              SingleLineField(
              'Please select your Cell',
              controller: cellBelongController,
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
                              cells[index]
                            ),
      
                            onTap: () {
                              Navigator.pop(context);
                              cellBelongController.text =cells[index];
      
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
            ]
            ],


            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: DefaultButton(
                active: enable(),
                onTap: (){
                  departmentBelongController.text = departmentController.text.toLowerCase() == 'no' || departmentController.text == ''?'none':departmentBelongController.text;
                  cellBelongController.text = cellController.text.toLowerCase() == 'no' || cellController.text == ''?'none':cellBelongController.text;

                  widget.onTap!(
                    _user.copyWith(
                      department: departmentBelongController.text,
                      cell: cellBelongController.text,
                      memberOfhurch: memberController.text.toLowerCase() == 'no' ? false:true
                    )
                  );
                },
              ),
            ),                 
          ]
          .animate(interval: 200.ms)
          .fadeIn(duration: 300.ms, delay: 100.ms)
          .shimmer(blendMode: BlendMode.srcOver, color: Colors.white12)
          .move(begin: const Offset(-16, 0), curve: Curves.easeOutQuad)
        
          
        ),
      ),
    );
  }
}
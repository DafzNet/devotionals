// ignore_for_file: prefer_const_constructors, constant_identifier_names


import 'package:devotionals/utils/widgets/default.dart';
import 'package:devotionals/utils/widgets/textfields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../utils/models/user.dart';



class SignUpPage1 extends StatefulWidget {

  final Function(User)? onTap;

  const SignUpPage1({
    this.onTap,
    super.key
    });

  @override
  State<SignUpPage1> createState() => _SignUpPage1State();
}

class _SignUpPage1State extends State<SignUpPage1> {

  final fname = TextEditingController();
  final lname = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final sex = TextEditingController();
  RegExp emailPattern = RegExp(r'^[a-zA-Z0-9.a-zA-Z0-9_a-zA-Z0-9!_+=-~*£]+@[a-zA-Z0-9.a-zA-Z0-9_a-zA-Z0-9-a-zA-Z0-9]+\.[a-zA-Z0-9]+');

  User? user;



  Map<String, dynamic> validateEmail(String pass){
    bool m = emailPattern.hasMatch(pass);

    if(m){
      setState(() {
      });
      return {'valid':true, 'message':''};
    }
    return {'valid':false, 'message':'Invalid email'};
  }


  bool enable(){
    return fname.text.isNotEmpty && lname.text.isNotEmpty && sex.text.isNotEmpty
      && email.text.isNotEmpty && phone.text.isNotEmpty && emailPattern.hasMatch(email.text);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
  
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          
          children: [
      
      
            Text(
              'Personal Information',
              style: TextStyle(
                fontSize: 20
              )
            ),
      
      
            SizedBox(
              height: 20,
            ),
      
      
            SingleLineField(
              'first Name',
              controller: fname,
              onChanged: () {
                enable();

                setState((){

                });
              },
            ),
      
            SizedBox(
              height: 15,
            ),
      
            SingleLineField(
              'last Name',
              controller: lname,

              onChanged: () {
                enable();

                setState((){
                  
                });
              },
            ),
      
            SizedBox(
              height: 15,
            ),
      
            SingleLineField(
              'Phone',
              controller: phone,

              onChanged: () {
                enable();

                setState((){
                  
                });
              },
            ),
      
            SizedBox(
              height: 15,
            ),
      
            SingleLineField(
              'Email',
              valdator: validateEmail,
              controller: email,

              onChanged: () {
                enable();

                setState((){
                  
                });
              },
            ),

            SizedBox(height: 15,),

            SingleLineField(
                  'Gender',
                  controller: sex,
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
                                  "Male"
                                ),
          
                                onTap: () {
                                  Navigator.pop(context);
                                  sex.text = "male";
          
                                  setState(() {
                                    
                                  });
                                },
                              ),
                        
                              ListTile(
                                title: Text(
                                  "Female"
                                ),
          
                                onTap: () {
                                  Navigator.pop(context);
                                  sex.text = "female";
          
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


            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: DefaultButton(
                onTap: (){
                  widget.onTap!(
                    User(
                      userID: '', 
                      firstName: fname.text.trim(), 
                      lastName: lname.text.trim(), 
                      dateOfBirth: DateTime.now(), 
                      email: email.text.trim(), 
                      phone: phone.text.trim(),
                      gender: sex.text.trim()
                    )
                  );
                },
                active: enable(),
              ),
            ),
      
          ]
          .animate(interval: 400.ms)
          .fadeIn(duration: 900.ms, delay: 300.ms)
          .shimmer(blendMode: BlendMode.srcOver, color: Colors.white12)
          .move(begin: const Offset(-16, 0), curve: Curves.easeOutQuad)
        ),
      ),
    );
  }
}
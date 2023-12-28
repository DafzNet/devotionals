import 'package:devotionals/utils/widgets/textfields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/widgets/default.dart';

class CreatePasswordScreen extends StatefulWidget {

  final String? title;
  const CreatePasswordScreen({
    this.title,
    super.key});

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {


  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool passwordAccepted = false;


  Map<String, dynamic> validatePassword(String pass){

    RegExp passUpper = RegExp(r'[A-Z]');
    RegExp passLower = RegExp(r'[a-z]');
    RegExp passNumber = RegExp(r'[0-9]');
    RegExp passSign = RegExp(r'[!@#\$%\=\+\-_\^\(\);,.<>\\[\]\{\}?]');

    if(passUpper.hasMatch(pass) && passLower.hasMatch(pass) && passNumber.hasMatch(pass) && passSign.hasMatch(pass) && pass.length>=8){
      
      passwordAccepted = true;
      
      if(pass == confirmPasswordController.text){
          
      }

      return {'valid':true, 'message':''};
    }
    return {'valid':false, 'message':'Weak password'};
  }


    Map<String, dynamic> validateConfirmPassword(String pass){

    if(pass == passwordController.text){
      

      return {'valid':true, 'message':''};
    }
    return {'valid':false, 'message':'Passwords do not match'};
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark
          ),
      ),


      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const SizedBox(height: 20,),

              Row(
                children: [
                  Text(
                    widget.title??'Create New Password',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width-30,
                    child: const Text(
                      'Create a password that\'s at least 8 characters.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400
                      ),
                    ),
                  ),
                ],
              ),




              const SizedBox(
                height: 50,
              ),


              SingleLineField(
              '',
              controller: passwordController,

              valdator: validatePassword,
            ),

            const SizedBox(
              height: 30,
            ),
      
            SingleLineField(
              '',

              valdator: validateConfirmPassword,

              //onChanged: enableButton,

            ),


            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                'Password must be at least 8 characters long.\n\nPassword must contain at least one upper case.\n\nOne lower case letter.\n\nPassword must contain at least one number or special character',
                style: TextStyle(
                  fontSize: 14,
                  
                ),
              ),
            ),
              const SizedBox(
                height: 30,
              ),


              const SizedBox(
                height:50
              ),

              DefaultButton(
                text: 'Submit',
                onTap: (){
                
              },

              ),

            ],
          ),
        ),
      ),


    );
  }
}
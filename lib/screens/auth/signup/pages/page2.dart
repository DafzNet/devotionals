// ignore_for_file: prefer_const_constructors
import 'package:devotionals/utils/constants/colors.dart';
import 'package:devotionals/utils/models/user.dart';
import 'package:devotionals/utils/widgets/default.dart';
import 'package:devotionals/utils/widgets/textfields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';


class SignUpPage2 extends StatefulWidget {

  final Function(User, String password)? onTap;

  const SignUpPage2({
    this.onTap,
    super.key
    });

  @override
  State<SignUpPage2> createState() => _SignUpPage2State();
}

class _SignUpPage2State extends State<SignUpPage2> {

  User _user = User(userID: '', firstName:'', lastName: '', dateOfBirth: DateTime(1900), email: '', phone: '');

  final dobController = TextEditingController();
  final pwdController = TextEditingController();
  final confitmPwdController = TextEditingController();

  DateTime? selected;

  bool enable(){
  
    if (dobController.text.isNotEmpty && pwdController.text.isNotEmpty && confitmPwdController.text.isNotEmpty && pwdController.text == confitmPwdController.text) {
      return true;
    }
    return false;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
  
      body: Stack(

        fit: StackFit.expand,
        alignment: AlignmentDirectional.bottomCenter,

        children: [
          SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(

              children: [

                Text(
                    'Secure Your account',
                    style: TextStyle(
                      fontSize: 20
                    )
                  ),
                  SizedBox(
                height: 20,
              ),
                
             SingleLineField(
                'Date of Birth',
                controller: dobController,
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
          
              SizedBox(
                height: 15,
              ),
                
              SingleLineField(
                'Password',
                controller: pwdController,
                password: true,

                onChanged: () {
                  setState(() {
                    
                  });
                },
          
              ),


              SizedBox(
                height: 15,
              ),
                
              SingleLineField(
                'Confirm password',
                controller: confitmPwdController,
                password: true,

                onChanged: () {
                  setState(() {
                    
                  });
                },
          
              ),

              Padding(
                padding: const EdgeInsets.only(top: 60),
                child: DefaultButton(
                    active: enable(),
                    onTap: (){
                      widget.onTap!(
                        _user.copyWith(
                          dateOfBirth: selected
                        ),

                        pwdController.text
                      );
                    },
                  ),
              ),
              ]
              .animate(interval: 200.ms)
              .fadeIn(duration: 300.ms, delay: 200.ms)
              .shimmer(blendMode: BlendMode.srcOver, color: Colors.white12)
              .move(begin: const Offset(-16, 0), curve: Curves.easeOutQuad)
            ),
          ),
        ],
      ),
      
    );
  }
}
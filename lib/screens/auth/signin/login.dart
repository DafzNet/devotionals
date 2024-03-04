// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers, prefer_const_constructors

import 'package:devotionals/firebase/auth.dart';
import 'package:devotionals/firebase/dbs/user.dart';
import 'package:devotionals/screens/nav.dart';
import 'package:devotionals/utils/models/user.dart';
import 'package:devotionals/utils/widgets/default.dart';
import 'package:devotionals/utils/widgets/loading.dart';
import 'package:devotionals/utils/widgets/textfields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/constants/colors.dart';
import '../signup/signup.dart';
import 'forgotpassword.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  bool rememberMe = false;
  final email = TextEditingController();
  final pwd = TextEditingController();

  bool isLoading = false;

  void remem()async{
    final pref = await SharedPreferences.getInstance();
    bool? r = pref.getBool('remember');
    if (r == true) {
      email.text = pref.getString('email').toString();
      rememberMe = true;
    }

    setState(() {
      
    });
  }



  @override
  void initState() {
    remem();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark
          ),

          toolbarHeight: 30,
      ),


      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: LoadingIndicator(
            loading: isLoading,
            child: Column(
              children: [
          
                Row(
                  children: const [
                    Text(
                      'Continue Here',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  ],
                ),
          
                Row(
                  children: const [
                      Text(
                      'Please enter your login details',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  ],
                ),
          
          
                const SizedBox(
                  height: 80,
                ),
          
          
                SingleLineField(
                  'Email',
                  controller: email,
                  onChanged: () async{
                    final p = await SharedPreferences.getInstance();
                    final reg = RegExp(r'^[a-zA-Z0-9.a-zA-Z0-9_a-zA-Z0-9!_+=-~*£]+@[a-zA-Z0-9.a-zA-Z0-9_a-zA-Z0-9-a-zA-Z0-9]+\.[a-zA-Z0-9]+');
                    if (reg.hasMatch(email.text)) {
                      await p.setString('email', email.text);
                    }
                    setState(() {
                      
                    });
                  },
                ),
          
                const SizedBox(
                  height: 30,
                ),
          
          
                SingleLineField(
                  'Password',
                  controller: pwd,
                  maxLines: 1,
                  minLines: 1,
          
                  password: true,

                  onChanged: (){
                    setState(() {
                      
                    });
                  },
                ),
          
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap:()async{
                          rememberMe = !rememberMe;
                          final pref = await SharedPreferences.getInstance();
                          await pref.setBool('remember', rememberMe);
                          print(rememberMe);
                          setState(
                            (){
          
                            }
                          );
                        },
                        child: Row(
          
                          children: [
                            Checkbox(
                              value: rememberMe, 
                              activeColor: cricColor,
                              onChanged: (value)async{
                                rememberMe = value!;

                                final pref = await SharedPreferences.getInstance();
                                await pref.setBool('remember', value);
                                print('value');

                                setState(
                                (){
          
                                  }
                                );
                              }),
                      
                            const Text(
                              'Remember Me'
                            )
                          ],
                        ),
                      ),
          
                      GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            PageTransition(
                            child: const ForgotPasswordScreen(),
                            type: PageTransitionType.fade
                            )
                          );
                        },
          
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(
                            color: cricColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500
                      
                          )
                        ),
                      )
          
                  ],
                ),
          
                const SizedBox(
                  height:50
                ),
          
                DefaultButton(
                  text: 'Sign in',

                  active: email.text.isNotEmpty && pwd.text.isNotEmpty && RegExp(r'^[a-zA-Z0-9.a-zA-Z0-9_a-zA-Z0-9!_+=-~*£]+@[a-zA-Z0-9.a-zA-Z0-9_a-zA-Z0-9-a-zA-Z0-9]+\.[a-zA-Z0-9]+').hasMatch(email.text),

                  onTap: ()async{
                    setState(() {
                      isLoading = true;
                    });
                    final _authService = AuthService();

                    final u = await _authService.signIn(email: email.text, password: pwd.text);
                    //User? user = await _userService.getUser(u!.uid);

                   

                    Navigator.pushReplacement(
                      context,
                      PageTransition(
                        child: AppBaseNavigation(uid: u!.uid,),
                        type: PageTransitionType.fade
                      )
                    );
                  },
                ),
          
          
                const SizedBox(height: 30,),
          
          
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an account? ',
          
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500
                      )
                    ),
              
                    GestureDetector(
                      onTap: (){
                          Navigator.push(
                            context,
                            PageTransition(
                            child: const SignUp(),
                            type: PageTransitionType.bottomToTop
                            )
                          );
                        },
                      child: Text(
                        'Sign up',
                    
                        style: TextStyle(
                          color: cricColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500
                        )
                      ),
                    )
                  ],
                ),
          
          
          
          
              ],
            ),
          ),
        ),
      ),


    );
  }
}
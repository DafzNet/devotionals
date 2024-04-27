// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:devotionals/firebase/auth.dart';
import 'package:devotionals/firebase/dbs/user.dart';
import 'package:devotionals/screens/nav.dart';
import 'package:devotionals/utils/constants/colors.dart';
import 'package:devotionals/utils/models/models.dart';
import 'package:devotionals/utils/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'pages/page1.dart';
import 'pages/page2.dart';
import 'pages/page2a.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  UserService _userService = UserService();
  AuthService _authService = AuthService();


  User? _user;

  final _pageController = PageController();
  int _currentStep = 1;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark
          ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: LoadingIndicator(
          loading: isLoading,
          child: Stack(
            children: [
        
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: PageView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  
                  children: [
                    SignUpPage1(
                      onTap: (user){
                        _user = user;
                        print(_user);
                        _pageController.nextPage(duration: Duration(milliseconds: 200), curve: Curves.bounceIn);
                        _currentStep+=1;
        
                        setState(() {
                          
                        });
                      },
                    ),
        
        
                    SignUpPage2a(
                      onTap: (user){
                        _user = _user!.copyWith(
                          department: user.department,
                          cell: user.cell,
                          memberOfhurch: user.memberOfhurch
                        );
        
                        print(_user);
                        _pageController.nextPage(duration: Duration(milliseconds: 200), curve: Curves.bounceIn);
                        _currentStep+=1;
                        setState(() {
                          
                        });
                      },
                    ),
        
                    ///Second signup screencccceer
                    SignUpPage2(
                      onTap: (user, p)async{
                        setState(() {
                          isLoading = true;
                        });
                        _user = _user!.copyWith(
                          dateOfBirth: user.dateOfBirth
                        );
        
                        try {
                          final u = await _authService.signUp(email: _user!.email!, password:p);
                          _user = _user!.copyWith(
                            userID: u!.uid
                          );
                          await _userService.createUser(
                            _user!
                          );
        
                          print(_user);

                          setState(() {
                            isLoading = false;
                          });
        
                          Navigator.pushReplacement(
                            context,
                            PageTransition(
                              child: AppBaseNavigation(uid: u.uid,),
                              type: PageTransitionType.fade
                            )
                          );
        
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: 
                            Text(
                              e.toString()
                            ))
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
        
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                       
                      ],
                    ),
                  ),
        
        
                  SizedBox(
                    width: MediaQuery.of(context).size.width-40,
                    child: StepProgressIndicator(
                        totalSteps: 3,
                        currentStep: _currentStep,
                        size: 8,
                        padding: 0,
                        selectedColor: cricColor.shade600,
                        unselectedColor: cricColor.shade100,
                        roundedEdges: Radius.circular(10),
                        
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
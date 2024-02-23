import 'package:devotionals/screens/onboarding/pages/three.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../utils/widgets/default.dart';
import '../auth/signin/login.dart';
import '../auth/signup/signup.dart';
import 'pages/one.dart';
import 'pages/two.dart';

class Onboarder extends StatefulWidget {
  const Onboarder({super.key});

  @override
  State<Onboarder> createState() => _OnboarderState();
}

class _OnboarderState extends State<Onboarder> {

  PageController _controller = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Column(
          children: [

            Expanded(
              child: PageView(
                controller: _controller,
                physics: NeverScrollableScrollPhysics(),

                onPageChanged: (p){
                  currentPage = p;
                  setState(() {
                    
                  });
                },
                children: [
                  OnboarderOne(),
                  OnboarderTwo(),
                  OnboarderThree()
                ],
              )
            ),

            SizedBox(height: 20,),

            DefaultButton(
              text: currentPage== 2? 'Get Started' : 'Continue',

              onTap: (){
                currentPage < 2?_controller.nextPage(duration: Duration(milliseconds: 200), curve: Curves.bounceIn):
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                    child: SignUp(), 
                    type: PageTransitionType.fade
                  )
                );
              },
            ),

            SizedBox(height: 10,),

            DefaultButton(
              text: currentPage== 2? 'Login' : 'Skip',
              textColor: Colors.black,
              color: Colors.white,

              onTap: (){
                currentPage < 2?
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                    child: SignUp(), 
                    type: PageTransitionType.fade
                  )
                ):
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                    child: LoginScreen(), 
                    type: PageTransitionType.fade
                  )
                );
              },
            ),

            SizedBox(height: 20,)


          ],
        ),
      ),
    );
  }
}
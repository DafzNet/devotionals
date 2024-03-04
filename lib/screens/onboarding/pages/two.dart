import 'package:devotionals/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class OnboarderTwo extends StatefulWidget {
  const OnboarderTwo({super.key});

  @override
  State<OnboarderTwo> createState() => _OnboarderTwoState();
}

class _OnboarderTwoState extends State<OnboarderTwo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Column(
          children: [

            Expanded(
              child: Container(

              )
            ),

            SizedBox(height: 15,),

            Row(
              children: [
                Text(
                  'in velit officia',
                  textAlign: TextAlign.left,

                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16
                  ),
                ),
              ],
            ),

            Text(
              'Aliqua duis nulla qui amet fugiat irure nostrud. Minim nostrud elit id occaecat ea ea ex esse incididunt est Lorem. Elit labore velit est est minim commodo dolor culpa in non fugiat occaecat aliqua. Sunt id esse veniam nulla eiusmod culpa velit ut et. Qui exercitation voluptate esse excepteur in velit officia id sint cillum.',
              
              maxLines: 3,
              style: TextStyle(
                fontSize: 14
              ),
            ),

          ],
        ),
      ),
    );
  }
}
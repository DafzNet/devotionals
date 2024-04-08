import 'package:devotionals/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class OnboarderThree extends StatefulWidget {
  const OnboarderThree({super.key});

  @override
  State<OnboarderThree> createState() => _OnboarderThreeState();
}

class _OnboarderThreeState extends State<OnboarderThree> {
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
                  'Visit Us',
                  textAlign: TextAlign.left,

                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16
                  ),
                ),
              ],
            ),

            Text(
              'We will love to have you around. Worship with us at Charismatic Renaissance Int\'l church',
              
              maxLines: 3,
              textAlign: TextAlign.left,
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
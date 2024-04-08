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
                  'Our Culture',
                  textAlign: TextAlign.left,

                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16
                  ),
                ),
              ],
            ),

            Text(
              'We care for all, we are out to make all lives count. We speak the language of love',
              
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
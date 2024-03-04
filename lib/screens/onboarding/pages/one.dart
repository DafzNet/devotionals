import 'package:devotionals/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class OnboarderOne extends StatefulWidget {
  const OnboarderOne({super.key});

  @override
  State<OnboarderOne> createState() => _OnboarderOneState();
}

class _OnboarderOneState extends State<OnboarderOne> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Column(
          children: [

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/images/plant-new-life.jpg'),
                  fit: BoxFit.cover
                  ),

                  gradient: LinearGradient(
                    colors: [
                      Colors.black,
                      Colors.transparent
                    ]
                  )
                )
              )
            ),

            SizedBox(height: 15,),

            Row(
              children: [
                Text(
                  'Our Message',
                  textAlign: TextAlign.left,

                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16
                  ),
                ),
              ],
            ),

            Text(
              'Our mandate is to preach and teach the full message of the Gospel based on Acts 5:20 NIV',
              
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
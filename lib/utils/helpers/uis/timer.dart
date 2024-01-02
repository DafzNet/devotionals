import 'dart:async';

import 'package:devotionals/utils/constants/colors.dart';
import 'package:devotionals/utils/helpers/functions/dateformat.dart';
import 'package:flutter/material.dart';

class CountdownScreen extends StatefulWidget {
  final DateTime targetDate;

  CountdownScreen({required this.targetDate});

  @override
  _CountdownScreenState createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  late Duration timeDifference;

  @override
  void initState() {
    super.initState();
    timeDifference = widget.targetDate.difference(DateTime.now());
    startTimer();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (Timer timer) {
      if (timeDifference.inSeconds <= 0) {
        timer.cancel();
      } else {
        setState(() {
          timeDifference = timeDifference - oneSec;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                width: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: cricColor.shade100
                  )
                ),
                child: Column(
                  children: [
                    Text(
                      '${timeDifference.inDays}',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: cricColor),
                    ),

                    Text(
                      'Days',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),



              Container(
                padding: EdgeInsets.all(10),
                width: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: cricColor.shade100
                  )
                ),
                child: Column(
                  children: [
                    Text(
                      '${timeDifference.inHours.remainder(24)}',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: cricColor),
                    ),

                    Text(
                      'hours',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),


              Container(
                padding: EdgeInsets.all(10),
                width: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: cricColor.shade100
                  )
                ),
                child: Column(
                  children: [
                    Text(
                      '${timeDifference.inMinutes.remainder(60)}',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: cricColor),
                    ),

                    Text(
                      'mins',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),



                            Container(
                padding: EdgeInsets.all(10),
                width: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: cricColor.shade100
                  )
                ),
                child: Column(
                  children: [
                    Text(
                      '${timeDifference.inSeconds.remainder(60)}',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: cricColor),
                    ),

                    Text(
                      'secs',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),





            ],
          )
          // Text(
          //    days, ${timeDifference.inHours.remainder(24)} hours, '
          //   '${timeDifference.inMinutes.remainder(60)} minutes, ${timeDifference.inSeconds.remainder(60)} seconds',
          //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          // ),
        ],
    );
  }
}
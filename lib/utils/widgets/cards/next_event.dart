
import 'package:devotionals/utils/constants/colors.dart';
import 'package:devotionals/utils/constants/sizes.dart';
import 'package:devotionals/utils/helpers/functions/dateformat.dart';
import 'package:devotionals/utils/helpers/uis/timer.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class NextEventDate extends StatefulWidget {
  const NextEventDate({super.key});

  @override
  State<NextEventDate> createState() => _NextEventDateState();
}

class _NextEventDateState extends State<NextEventDate> {

  DateTime _dateTime = DateTime.now();

void _next() {
  DateTime presentDay = DateTime.now();
  // Assuming FoHP occurs on the fifth Friday of every month with five Fridays
  DateTime? nextFoHP = calculateNextFoHP(presentDay);

  _dateTime = nextFoHP!;

  setState(() {
    
  });
  
}

DateTime? calculateNextFoHP(DateTime presentDay) {
  DateTime firstDayOfNextMonth = DateTime(presentDay.year, presentDay.month, 1);
  DateTime lastDayOfNextMonth = DateTime(firstDayOfNextMonth.year, firstDayOfNextMonth.month+1, 0);


  DateTime? fifthFriday = findFifthFriday(firstDayOfNextMonth, lastDayOfNextMonth);

  while(fifthFriday == null){
    firstDayOfNextMonth = firstDayOfNextMonth.copyWith(
      month: firstDayOfNextMonth.month+1
    );
    lastDayOfNextMonth = DateTime(firstDayOfNextMonth.year, firstDayOfNextMonth.month+1, 0);


    fifthFriday = findFifthFriday(firstDayOfNextMonth, lastDayOfNextMonth);
    if (fifthFriday != null) {
      break;
    }
  }

  return fifthFriday;
}

DateTime? findFifthFriday(DateTime start, DateTime end) {
  DateTime date = start;

  while (date.weekday != DateTime.friday) {
    date = date.add(Duration(days: 1));
  }

  for (int i = 1; i < 5; i++) {
    date = date.add(Duration(days: 7)); // Move to the next Friday
    if (date.isAfter(end)) {
      return null; // No fifth Friday in the month
    }
  }

  return date;
}


  @override
  void initState() {
    _next();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width-20,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color.fromARGB(149, 243, 243, 243)
      ),

      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                      MdiIcons.calendar,
                      size: 16,
                      color: cricColor,
                    ),

                    SizedBox(width: 7,),
                Expanded(
                  child: Text(
                    'Fragrance of His Presence',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                
                    style: TextStyle(fontSize: titleFontSmall, fontWeight: FontWeight.bold),
                  ),
                ),
      
            Text(
              '${formatDate(_dateTime.toLocal())}',
              style: TextStyle(fontSize: 13),
            ),
      
              ],
            ),

            SizedBox(height: 15,),
      
            CountdownScreen(targetDate: _dateTime)
          ],
        ),
      ),
    );
  }
}



class NextMoHDate extends StatefulWidget {
  const NextMoHDate({super.key});

  @override
  State<NextMoHDate> createState() => _NextMoHDateState();
}

class _NextMoHDateState extends State<NextMoHDate> {

  DateTime _dateTime = DateTime.now();

void _next() {
  DateTime presentDay = DateTime.now();
  
  // Assuming Matters of the Heart occurs on the first Thursday of every month
  DateTime nextMattersOfTheHeart = calculateNextMattersOfTheHeart(presentDay);
  Duration timeDifference = nextMattersOfTheHeart.difference(presentDay);
  _dateTime = nextMattersOfTheHeart;

  setState(() {
    
  });
}

DateTime calculateNextMattersOfTheHeart(DateTime presentDay) {
  // Find the first day of the next month
  DateTime firstDayOfNextMonth = DateTime(presentDay.year, presentDay.month + 1, 1);

  // Calculate the first Thursday of the next month
  DateTime firstThursday = findFirstThursday(firstDayOfNextMonth);

  return firstThursday;
}

DateTime findFirstThursday(DateTime date) {
  while (date.weekday != DateTime.thursday) {
    date = date.add(Duration(days: 1));
  }
  return date;
}

void printTimeDifference(Duration difference) {
  print("Time until Matters of the Heart:");
  print("${difference.inDays} days, ${difference.inHours.remainder(24)} hours, "
      "${difference.inMinutes.remainder(60)} minutes, ${difference.inSeconds.remainder(60)} seconds");
}

  @override
  void initState() {
    _next();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width-20,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color.fromARGB(149, 243, 243, 243)
      ),

      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                      MdiIcons.calendar,
                      size: 16,
                      color: cricColor,
                    ),

                    SizedBox(width: 7,),
                Expanded(
                  child: Text(
                    'Matters of the Heart',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
      
            Text(
              '${formatDate(_dateTime.toLocal())}',
              style: TextStyle(fontSize: 13),
            ),
      
              ],
            ),

            SizedBox(height: 15,),
      
            CountdownScreen(targetDate: _dateTime)
          ],
        ),
      ),
    );
  }
}







class NextEquipDate extends StatefulWidget {
  const NextEquipDate({super.key});

  @override
  State<NextEquipDate> createState() => _NextEquipDateState();
}

class _NextEquipDateState extends State<NextEquipDate> {

  DateTime _dateTime = DateTime.now();

void _next() {
  DateTime presentDay = DateTime.now();
  
  // Assuming EQUIP occurs on the last Monday of every month
  DateTime nextEQUIP = calculateNextEQUIP(presentDay);

  _dateTime = nextEQUIP;
}

DateTime calculateNextEQUIP(DateTime presentDay) {
  // Find the first day of the next month
  DateTime firstDayOfNextMonth = DateTime(presentDay.year, presentDay.month + 1, 1);

  // Calculate the last Monday of the next month
  DateTime lastMonday = findLastMonday(firstDayOfNextMonth);

  return lastMonday;
}

DateTime findLastMonday(DateTime date) {
  while (date.weekday != DateTime.monday) {
    date = date.subtract(Duration(days: 1));
  }
  return date;
}

void printTimeDifference(Duration difference) {
  print("Time until EQUIP:");
  print("${difference.inDays} days, ${difference.inHours.remainder(24)} hours, "
      "${difference.inMinutes.remainder(60)} minutes, ${difference.inSeconds.remainder(60)} seconds");
}


  @override
  void initState() {
    _next();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width-20,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color.fromARGB(149, 243, 243, 243)
      ),

      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                      MdiIcons.calendar,
                      size: 16,
                      color: cricColor,
                    ),

                    SizedBox(width: 7,),
                Expanded(
                  child: Text(
                    'EQUIP',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
      
            Text(
              '${formatDate(_dateTime.toLocal())}',
              style: TextStyle(fontSize: 13),
            ),
      
              ],
            ),

            SizedBox(height: 15,),
      
            CountdownScreen(targetDate: _dateTime)
          ],
        ),
      ),
    );
  }
}




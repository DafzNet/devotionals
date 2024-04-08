
import 'package:devotionals/firebase/dbs/verseoftheday.dart';
import 'package:devotionals/utils/constants/colors.dart';
import 'package:devotionals/utils/models/dailyverse.dart';
import 'package:devotionals/utils/widgets/default.dart';
import 'package:devotionals/utils/widgets/loading.dart';
import 'package:devotionals/utils/widgets/textfields.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ScriptureOftheDay extends StatefulWidget {
  const ScriptureOftheDay({super.key});

  @override
  State<ScriptureOftheDay> createState() => _ScriptureOftheDayState();
}

class _ScriptureOftheDayState extends State<ScriptureOftheDay> {

  final dateController = TextEditingController();
  final textController = TextEditingController();
  final refController = TextEditingController();

  DateTime _selected = DateTime.now();

  bool _loading = false;

  @override
  void initState() {
    dateController.text = DateFormat('E d, MMM yyyy').format(_selected);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scripture of the Day'),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: LoadingIndicator(
            loading: _loading,
            child: Column(
              children: [
            
                SingleLineField('',
                headerText: 'Day',
                controller: dateController,
                  
                suffixIcon: MdiIcons.calendar,
                makeButton: true,
                  
                    onTap: () async{
                      DateTime? date = await showDatePicker(
                        context: context, 
                        initialDate: new DateTime.now(), 
                        firstDate: new DateTime(1900),
                        lastDate: new DateTime.now().add(Duration(days: 365)),
                  
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
                        dateController.text = DateFormat('E d, MMM yyyy').format(date);
                        _selected = date;
                      } else {
                        dateController.text = DateFormat('E d, MMM yyyy').format(DateTime.now());
                        _selected = DateTime.now();
                      }
                  
                      setState(() {
                        
                      });
                    },

                    onChanged: (){
                    setState(() {
                      
                    });
                  },
                  
              ),
            
            
                SizedBox(height: 20,),
                
                SingleLineField(
                  '',
                  headerText: 'Scripture Text',
                  controller: textController,
                  minLines: 10,
                  maxLines: 10,

                  onChanged: (){
                    setState(() {
                      
                    });
                  },
            
                ),
            
                SizedBox(
                  height: 20,
                ),
            
                SingleLineField(
                  '',
                  headerText: 'Reference',
                  controller: refController,

                  onChanged: (){
                    setState(() {
                      
                    });
                  },
                ),
            
            
                SizedBox(height: 40,),
            
            
                DefaultButton(
                  active: textController.text.trim().length>=5 && refController.text.trim().length>=5 && dateController.text.trim().length>=5,

                  onTap: ()async{

                    setState(() {
                      _loading = true;
                    });

                    VerseofDayFirestoreService verseofDayFirestoreService = VerseofDayFirestoreService();

                    final DailyVerse dailyVerse = DailyVerse(
                      id: _selected.millisecondsSinceEpoch, 
                      verseText: textController.text, 
                      reference: refController.text, 
                      date: _selected
                    );

                    await verseofDayFirestoreService.addDailyVerse(dailyVerse);



                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Daily verse added successfully', style: TextStyle(color: cricColor),),
                        backgroundColor: Colors.white,
                      )
                    );

                    textController.text = '';
                    refController.text = '';


                    setState(() {
                      _loading = false;
                    });
                  }
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
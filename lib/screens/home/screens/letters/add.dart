
import 'package:devotionals/firebase/dbs/letters.dart';
import 'package:devotionals/firebase/dbs/verseoftheday.dart';
import 'package:devotionals/utils/constants/colors.dart';
import 'package:devotionals/utils/models/dailyverse.dart';
import 'package:devotionals/utils/models/letters.dart';
import 'package:devotionals/utils/widgets/default.dart';
import 'package:devotionals/utils/widgets/loading.dart';
import 'package:devotionals/utils/widgets/textfields.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AddLetter extends StatefulWidget {
  const AddLetter({super.key});

  @override
  State<AddLetter> createState() => _AddLetterState();
}

class _AddLetterState extends State<AddLetter> {

  final dateController = TextEditingController();
  final textController = TextEditingController();
  final typeController = TextEditingController(text:'letter');

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
        title: Text('Add Letter'),
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
                  'Add letter or prayer by Apostle',
                  headerText: 'Text',
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
                  headerText: 'Type',
                  controller: typeController,

                  makeButton: true,

                  onTap: ()async{
                     await showModalBottomSheet(
            backgroundColor: Color.fromARGB(73, 36, 15, 15),
            context: context, 
            builder: (BuildContext context){
              return Container(
                padding: EdgeInsets.fromLTRB(2, 15, 2, 0),
                

                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    20
                  )
                ),


                child: ListView(
                  children: [
                    ListTile(
                      title: Text('letter'),
                      trailing: Icon(
                        typeController.text == 'letter'? MdiIcons.circle  :  MdiIcons.circleOutline,
                        color: typeController.text == 'letter'?cricColor:Colors.grey[800],
                      ),
                      onTap: () {
                        typeController.text = 'letter';
                        Navigator.pop(context);
                         
                      },
                    ),


                    ListTile(
                      title: Text('prayer'),
                      trailing: Icon(
                        typeController.text == 'prayer'? MdiIcons.circle  :  MdiIcons.circleOutline,
                        color: typeController.text == 'prayer'?cricColor:Colors.grey[800],
                      ),
                      onTap: () {
                        typeController.text = 'prayer';
                        Navigator.pop(context);
                         
                      },
                    ),

                  ],
                ),
              );
            }
          );


                  },

                  onChanged: (){
                    setState(() {
                      
                    });
                  },
                ),
            
            
                SizedBox(height: 40,),
            
            
                DefaultButton(
                  active: textController.text.trim().length>=5 && typeController.text.trim().length>=5 && dateController.text.trim().length>=5,

                  onTap: ()async{

                    setState(() {
                      _loading = true;
                    });

                    VerseofDayFirestoreService verseofDayFirestoreService = VerseofDayFirestoreService();

                    final Letters letter = Letters(
                      id: _selected.millisecondsSinceEpoch, 
                      text: textController.text, 
                      type: typeController.text, 
                      date: _selected
                    );


                    final _apstLettersService = ApostleLettersFirestoreService();

                    await _apstLettersService.addLetter(letter);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('successfully added', style: TextStyle(color: cricColor),),
                        backgroundColor: Colors.white,
                      )
                    );
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
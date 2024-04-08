
import 'dart:io';

import 'package:devotionals/firebase/dbs/verseoftheday.dart';
import 'package:devotionals/utils/constants/colors.dart';
import 'package:devotionals/utils/models/event.dart';
import 'package:devotionals/utils/widgets/default.dart';
import 'package:devotionals/utils/widgets/images/selector.dart';
import 'package:devotionals/utils/widgets/loading.dart';
import 'package:devotionals/utils/widgets/textfields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../firebase/dbs/event_fs.dart';
import '../../../../firebase/file_storage.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({super.key});

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {

  Color pickedColor = Colors.white;

  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final titleController = TextEditingController();
  final venueController = TextEditingController();
  final themeController = TextEditingController();
  final timeController = TextEditingController();
  final endTimeController = TextEditingController();
  final photoController = TextEditingController();

  DateTime _startSelected = DateTime.now();
  DateTime _endSelected = DateTime.now();
  TimeOfDay _timeSelected = TimeOfDay.now();
  TimeOfDay _endtimeSelected = TimeOfDay.now();

  bool _loading = false;


    final _imagePickerCrop = ImagePickerCropper();
    File? _file;

  @override
  void initState() {
    endDateController.text = DateFormat('E d, MMM yyyy').format(_endSelected);
    startDateController.text = DateFormat('E d, MMM yyyy').format(_startSelected);
    timeController.text =  DateFormat('h:m').format(_startSelected);

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Events'),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: LoadingIndicator(
            loading: _loading,
            child: Column(
              children: [

                
                
                SingleLineField(
                  '',
                  headerText: 'Event Title',
                  controller: titleController,

                  onChanged: (){
                    setState(() {
                      
                    });
                  },
            
                ),

                SizedBox(height: 20,),

                SingleLineField(
                  '',
                  headerText: 'Venue',
                  controller: venueController,

                  onChanged: (){
                    setState(() {
                      
                    });
                  },
            
                ),

                SizedBox(height: 20,),



                SingleLineField(
                  '',
                  headerText: 'Theme',
                  controller: themeController,

                  onChanged: (){
                    setState(() {
                      
                    });
                  },
            
                ),

                SizedBox(height: 20,),

                SingleLineField('',
                headerText: 'Start Time',
                controller: timeController,
                  
                suffixIcon: MdiIcons.clockOutline,
                makeButton: true,
                  
                    onTap: () async{
                      
                      TimeOfDay? _time = await showTimePicker(
                        context: context, 
                        initialTime: _timeSelected,



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

                      if (_time != null) {
                        timeController.text = DateFormat('h:m a').format(
                          DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, _time.hour, _time.minute));
                        _timeSelected = _time;
                      } else {
                        timeController.text = DateFormat('h:m a').format(DateTime.now());
                        _timeSelected = TimeOfDay.now();
                      }
                  
                      setState(() {
                        
                      });
                      setState(() {
                        
                      });
                    },

                    onChanged: (){
                    setState(() {
                      
                    });
                  },
                  
                ),
                

                SizedBox(height: 20,),

                SingleLineField('',
                headerText: 'End Time',
                controller: endTimeController,
                  
                suffixIcon: MdiIcons.clockOutline,
                makeButton: true,
                  
                    onTap: () async{
                      
                      TimeOfDay? _time = await showTimePicker(
                        context: context, 
                        initialTime: _endtimeSelected,



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

                      if (_time != null) {
                        endTimeController.text = DateFormat('h:m a').format(
                          DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, _time.hour, _time.minute));
                        _endtimeSelected = _time;
                      } else {
                        endTimeController.text = DateFormat('h:m a').format(DateTime.now());
                        _endtimeSelected = TimeOfDay.now();
                      }
                  
                      setState(() {
                        
                      });
                      setState(() {
                        
                      });
                    },

                    onChanged: (){
                    setState(() {
                      
                    });
                  },
                  
                ),



                SizedBox(height: 20,),

                SingleLineField('',
                headerText: 'Start Date',
                controller: startDateController,
                  
                suffixIcon: MdiIcons.calendarMonthOutline,
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
                        startDateController.text = DateFormat('E d, MMM yyyy').format(date);
                        _startSelected = date;
                      } else {
                        startDateController.text = DateFormat('E d, MMM yyyy').format(DateTime.now());
                        _startSelected = DateTime.now();
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


              SingleLineField('',
                headerText: 'End Date',
                controller: endDateController,
                  
                suffixIcon: MdiIcons.calendarMonthOutline,
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
                        endDateController.text = DateFormat('E d, MMM yyyy').format(date);
                        _endSelected = date;
                      } else {
                        endDateController.text = DateFormat('E d, MMM yyyy').format(DateTime.now());
                        _endSelected = DateTime.now();
                      }
                  
                      setState(() {
                        
                      });
                    },

                    onChanged: (){
                    setState(() {
                      
                    });
                  },
                  
              ),
            
            
                
            
                SizedBox(
                  height: 20,
                ),
            
                SingleLineField(
                  'Attach an image (optional)',
                  headerText: 'Photo',
                  controller: photoController,

                  makeButton: true,
                  suffixIcon: MdiIcons.imageOutline,

                  onChanged: (){
                    setState(() {
                      
                    });
                  },

                  onTap: ()async{

                    _file = await _imagePickerCrop.imgFromGallery(crop: false);

                    if (_file != null) {
                      // String? dl = await uploadFileToFirebaseStorage(_file, 'events_images/');

                      photoController.text = _file!.path.split('/').last;
                      
                      setState(() {
                        
                      });

                    }

                  setState(() {
                    
                  });
                  },
                ),
            
                SizedBox(
                  height: 20,
                ),
            
                SingleLineField(
                  'Pick a color for this event (optional)',
                  headerText: 'Color Picker',

                  makeButton: true,
                  suffixIcon: MdiIcons.square,
                  suffixColor: pickedColor,

                  onChanged: (){
                    setState(() {
                      
                    });
                  },

                  onTap: (){
                    showDialog(
                    context: context,
                    builder: (context){
                      return AlertDialog(
                        title: const Text('Pick a color!'),
                        content: SingleChildScrollView(
                          child: ColorPicker(
                            pickerColor: pickedColor,
                            onColorChanged: (c){
                              pickedColor = c;
                              setState(() {
                                
                              });
                            },
                          ),));
                      }
                        
                    );
                  },
                ),
            
                SizedBox(height: 40,),
            
            
                DefaultButton(
                  active: venueController.text.isNotEmpty&& titleController.text.isNotEmpty&&timeController.text.isNotEmpty&&startDateController.text.isNotEmpty,
                  onTap: ()async{

                    setState(() {
                      _loading = true;
                    });

                    String? downloadLink;


                    if (_file != null ) {
                      downloadLink = await uploadFileToFirebaseStorage(_file!, 'events_images/${photoController.text}');
                    }


                    EventModel event = EventModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(), 
                      title: titleController.text, 
                      startDate: _startSelected.copyWith(hour: _timeSelected.hour, minute: _timeSelected.minute),
                      endDate: _endSelected.copyWith(hour: _endtimeSelected.hour, minute: _endtimeSelected.minute),
                      venue: venueController.text,
                      color: pickedColor,
                      theme: themeController.text,
                      image: downloadLink
                    );

                    EventFirestoreService eventFirestoreService = EventFirestoreService();
                    await eventFirestoreService.addEvent(event);
                   

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Event added successfully', style: TextStyle(color: cricColor),),
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
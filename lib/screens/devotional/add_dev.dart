import 'package:devotionals/firebase/dbs/devs.dart';
import 'package:devotionals/utils/constants/colors.dart';
import 'package:devotionals/utils/models/devotional.dart';
import 'package:devotionals/utils/widgets/default.dart';
import 'package:devotionals/utils/widgets/loading.dart';
import 'package:devotionals/utils/widgets/textfields.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AddDev extends StatefulWidget {
  final DevotionalModel? model;
  const AddDev({
    this.model,
    super.key});

  @override
  State<AddDev> createState() => _AddDevState();
}

class _AddDevState extends State<AddDev> {

  final titleController = TextEditingController();
  final openTextController = TextEditingController();
  final openRefController = TextEditingController();
  final bodyController = TextEditingController();
  final instructionController = TextEditingController();
  final confesionController = TextEditingController();
  final prayerController = TextEditingController();
  final furtherController = TextEditingController();
  final doingController = TextEditingController();
  final dailyController = TextEditingController();
  final dateController = TextEditingController();

  DateTime? _selected;
  bool loading = false;


  @override
  void initState() {
    if (widget.model!=null) {
      titleController .text = widget.model!.title;
      openTextController .text = widget.model!.openingScriptureText;
      openRefController .text = widget.model!.openingScriptureReference;
      bodyController     .text = widget.model!.body;
      furtherController   .text = widget.model!.furtherScriptures!;
      doingController     .text = widget.model!.doingTheWord!;
      dailyController     .text = widget.model!.dailyScriptureReading!;
      dateController.text = DateFormat('E d, MMM yyyy').format(widget.model!.date);

      _selected = widget.model!.date;
      
      if (widget.model!.confession!=null && widget.model!.confession!.length >5 ) {
        confesionController.text = widget.model!.confession!;
      } else {
        confesionController.text = '';
      }


      if (widget.model!.prayer!=null && widget.model!.prayer!.length >5 ) {
        prayerController.text = widget.model!.prayer!;
      } else {
        prayerController.text = '';
      }


      if (widget.model!.instruction!=null && widget.model!.instruction!.length >5 ) {
        instructionController.text = widget.model!.instruction!;
      } else {
        instructionController.text = '';
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),

      body: LoadingIndicator(
        loading: loading,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ListView(
            children: [
              SingleLineField('Title',
              controller: titleController,
              maxLines: 5,),
      
              SizedBox(height: 10,),
      
              SingleLineField('Date',
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
                  }
      
              
      /////////
            ),
      
              SizedBox(height: 10,),
      
              SingleLineField(
                'Opening Scripture Text',
                controller: openTextController,
                maxLines: 5,
                minLines: 2,  
              ),
      
              SizedBox(height: 10,),
      
              SingleLineField(
                'Opening Scripture Reference',
                controller: openRefController,
              ),
      
              SizedBox(height: 10,),
      
      
              SingleLineField(
                'Body',
                controller: bodyController,
                minLines: 3,
                maxLines: 10,
              ),
      
              SizedBox(height: 10),
      
              SingleLineField(
                'Instruction',
                controller: instructionController,
                maxLines: 5,
              ),
      
              SizedBox(height: 10),
      
              SingleLineField(
                'Confession',
                controller: confesionController,
                maxLines: 5,
                
              ),
      
              SizedBox(height: 10),
      
              SingleLineField(
                'Prayer',
                controller: prayerController,
                maxLines: 5,),
      
              SizedBox(height: 10),
      
              SingleLineField('Further Scriptures',
              controller: furtherController,
              maxLines: 5,),
      
              SizedBox(height: 10),
      
              SingleLineField(
                'Doing the Word',
                controller: doingController,
                maxLines: 5,),
      
              SizedBox(height: 10),
      
              SingleLineField('Daily Scripture Reading',
              controller: dailyController,
              maxLines: 5,),
      
              SizedBox(height: 30,),
      
              DefaultButton(
                text: 'Upload',

                onTap: ()async{
                  setState(() {
                    loading = true;

                  });

                  final _dev = DevotionalService();

                  if(widget.model != null){
                    DevotionalModel _model = widget.model!.copyWith( 
                      title: titleController.text, 
                      openingScriptureText: openTextController.text, 
                      openingScriptureReference: openRefController.text, 
                      body: bodyController.text, 
                      date: _selected!,
                      instruction: instructionController.text,
                      prayer: prayerController.text,
                      confession: confesionController.text,
                      doingTheWord: doingController.text,
                      dailyScriptureReading: dailyController.text,
                      furtherScriptures: furtherController.text
                    );
                    await _dev.updateDevotional(
                      _model
                  );
                  }else{
                    await _dev.createDevotional(
                    DevotionalModel(
                      id: _selected!.millisecondsSinceEpoch.toString(), 
                      title: titleController.text, 
                      openingScriptureText: openTextController.text, 
                      openingScriptureReference: openRefController.text, 
                      body: bodyController.text, 
                      date: _selected!,
                      instruction: instructionController.text,
                      prayer: prayerController.text,
                      confession: confesionController.text,
                      doingTheWord: doingController.text,
                      dailyScriptureReading: dailyController.text,
                      furtherScriptures: furtherController.text
                    )
                  );
                  }

                  setState(() {
                    loading = false;
                  });

                  Navigator.pop(context);
                },
              ),
      
              SizedBox(height: 30,),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:devotionals/dbs/init_db.dart';
import 'package:devotionals/dbs/note.dart';
import 'package:devotionals/utils/constants/db_consts.dart';
import 'package:devotionals/utils/models/note_model.dart';
import 'package:devotionals/utils/widgets/default.dart';
import 'package:devotionals/utils/widgets/loading.dart';
import 'package:devotionals/utils/widgets/textfields.dart';
import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';

class NoteTaker extends StatefulWidget {
  final Note? note;
  const NoteTaker({
    this.note,
    super.key});

  @override
  State<NoteTaker> createState() => _NoteTakerState();
}

class _NoteTakerState extends State<NoteTaker> {
  List<String> tags = ['health', 'wealth', 'prayer', 'leadership', 'growth','development', 'love', 'finance', 'giving', 'Others'];
  List<String> cats = ['Matters of the Heart', 'FoHP', 'Sunday Service', 'Devotional Comment', 'Leader\'s Meeting', 'School of Faith', 'EQUIP', 'Others'];

  Map<String, bool>? _selected;

  final titleC = TextEditingController();
  final bodyC = TextEditingController();
  final catC = TextEditingController();

  bool enable(){
    bool i = false;
    for (var e in _selected!.values) {
      if(e==true){i=e;}
    }
    return titleC.text.length>3 && bodyC.text.length>=20 &&catC.text.isNotEmpty && i;
  }


  bool loading = false;

  @override
  void initState() {
    _selected = Map<String, bool>.fromIterable(tags,
      key: (element) => element,
      value: (element) => false,
    );

     if (widget.note != null) {
       titleC.text = widget.note!.title;
       bodyC.text = widget.note!.body;
       catC.text = widget.note!.category;
       
       for (var i in widget.note!.tags.split(',')) {
         _selected![i] = true;
       }
     }

    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note != null? widget.note!.title: 'Add Note'),
      ),

      body: LoadingIndicator(
        loading: loading,
        child: Column(
          children: [
            Divider(height: 4,),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ListView(
                  children: [
                    SizedBox(height: 10,),
      
                    SingleLineField(
                      'title',
                      headerText: '',
                      controller: titleC,
                      bottomHint: 'minimum of 4 characters',
      
                      onChanged: () {
                        enable();
                        setState(() {
                          
                        });
                      },
                    ),
      
                    SizedBox(height: 15,),
      
                    SingleLineField(
                      'body',
                      headerText: '',
                      controller: bodyC,
                      minLines: 10,
                      maxLines: 15,
                      bottomHint: 'minimum of 20 characters',
      
                      onChanged: () {
                        enable();
                        setState(() {
                          
                        });
                      },
                    ),
      
                    SizedBox(height: 15,),
      
                    SingleLineField(
                      'Select Category',
                      controller: catC,
                      headerText: '',
                      makeButton: true,
      
                      onTap: widget.note != null? null: () {
                        showModalBottomSheet(
                          context: context, 
                          builder: (context){
                            return Container(
                              padding: EdgeInsets.fromLTRB(10,10, 10,2),
                              child: ListView(
                                children: cats.map((e) => ListTile(
                                  title: Text(e),
      
                                  onTap: () {
                                    enable();
                                    catC.text = e;
                                    
                                    Navigator.pop(context);
                                    setState(() {
                                      
                                    });
                                  },
                                )).toList(),
                              ),
                            );
                          });
                      },
      
                    ),
      
                    SizedBox(height: 15,),
                    Text('Tags:'),
      
                    SizedBox(height: 10,),
      
                    Wrap(
                      spacing: 5,
                      children: tags.map(
                        (e) => ChoiceChip.elevated(
                          label: Text(e),
                          onSelected: (value) {
                            _selected![e] = value;
                            enable();
      
                            setState(() {
                              
                            });
                          }, 
                          selected: _selected![e]!)
                      
                      ).toList(),
                    ),
      
                    SizedBox(height: 30,),
      
                    DefaultButton(
                      text: 'Save',
                      active: enable(),
      
                      onTap: () async{

                        setState(() {
                          loading = true;
                        });

                        List<String> k = [];
      
                        for (var e in _selected!.keys) {
                          if (_selected![e] == true){
                            k.add(e);
                          }
                        }
      
                        Database _db = await initDatabase(notedb);
      
                        Note _note = Note(
                          id: DateTime.now().millisecondsSinceEpoch, 
                          title: titleC.text, 
                          category: catC.text, 
                          date: DateTime.now(), 
                          lastUpdated: DateTime.now(), 
                          tags: k.join(','),
                          body: bodyC.text
                        );

                        if (widget.note != null) {
                          _note = widget.note!.copyWith(
                            title: titleC.text,
                            body: bodyC.text,
                            lastUpdated: DateTime.now(),
                            tags: k.join(',')
                          );
                        }
      
                        NoteRepository _notesDb = NoteRepository(_db);
      
                        if (widget.note != null) {
                          await _notesDb.updateNote(_note);
                        }else{
                          await _notesDb.insertNote(_note);
                        }

                        

                        loading = false;
                        setState(() {
                          
                        });

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: 
                        Text( widget.note != null?'Note Updated':'Note added successfully')));

                        Navigator.pop(context);
                      },
                    ),


                    SizedBox(height: 20,)
      
      
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
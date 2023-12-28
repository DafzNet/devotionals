import 'package:devotionals/dbs/init_db.dart';
import 'package:devotionals/dbs/note.dart';
import 'package:devotionals/screens/profile/screens/notes/note_taker.dart';
import 'package:devotionals/utils/constants/db_consts.dart';
import 'package:devotionals/utils/widgets/cards/note_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sembast/sembast.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  bool categorised = false;
  String? _category;


  String appBarTitle = 'My Notes';
  NoteRepository? _noteRepository;

  void getDb()async{
    Database db = await initDatabase(notedb);
    _noteRepository = NoteRepository(db);
    setState(() {
      
    });
  }

    void _showPopupMenu(BuildContext context, Offset position) async {
      double yOffset = position.dy - 20.0;

  // Ensure the yOffset is non-negative
      yOffset = yOffset < 0 ? 0 : yOffset;
      
      await showMenu(
        context: context,
        position: RelativeRect.fromLTRB(position.dx, yOffset, position.dx + 1, yOffset+ 1),
        items: [
          PopupMenuItem<String>(
            onTap: () {
              appBarTitle = 'FoHP';
              _category = 'FoHP';
              categorised=true;

              setState(() {
                
              });
            },
            value: '',
            child: Text('FoHP'),
          ),
          PopupMenuItem<String>(
            onTap: () {
              appBarTitle = '';
              _category = 'FoHP';
              categorised=true;

              setState(() {
                
              });
            },
            value: 'item2',
            child: Text('Item 2'),
          ),
          PopupMenuItem<String>(
            value: 'item3',
            child: Text('Item 3'),
          ),
        ],
      );
    }

  @override
  void initState() {
    getDb();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [
        TextButton.icon(
          onPressed: (){},
          icon: Icon(
            MdiIcons.backupRestore
          ), 
          label: Text('Backup')),

        GestureDetector(
          onTapDown: (d){
            _showPopupMenu(context, d.globalPosition);
          },
          child: TextButton.icon(
            onPressed: (){
              
            },
            icon: Icon(
              MdiIcons.selectAll
            ), 
            label: Text('Category')),
        ),

          

          TextButton.icon(
          onPressed: (){
            Navigator.push(
              context,
              PageTransition(
                child: NoteTaker(), 
                type: PageTransitionType.bottomToTop
              )
            );
          },
          icon: Icon(
            MdiIcons.notebookPlusOutline
          ), 
          label: Text('New Note'))
      ],

      appBar: AppBar(
        title: Text(appBarTitle),
        actions: [
          TextButton.icon(
          onPressed: (){},
          icon: Icon(
            MdiIcons.magnify,
          ), 
          label: Text('Search', )),
        ],
      ),


      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: !categorised? StreamBuilder(
          stream: _noteRepository!.getNotesStream(),
          builder: (context, snapshot){
            if(snapshot.data != null && snapshot.data!.isNotEmpty){
              return ListView.separated(
                itemBuilder: (context, index){
                  return NoteCard(
                    note: snapshot.data![index],
                    onDel: ()async{
                      await _noteRepository!.deleteNoteByNoteId(snapshot.data![index]);
                    },
                  );
                }, 
                separatorBuilder: (context, index){
                  return SizedBox(height: 5,);
                }, 
                itemCount: snapshot.data!.length);
            }
      
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  MdiIcons.notebookPlusOutline,
                  size: 70,
                  color: Colors.blueGrey,
                ),
                Center(child: Text(
                  'No Notes added',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.grey[600]
                  ),
                )),
              ],
            );
          }):FutureBuilder(
          future: _noteRepository!.getAllNotes(cat: _category),
          builder: (context, snapshot){
            if(snapshot.data != null && snapshot.data!.isNotEmpty){
              return ListView.separated(
                itemBuilder: (context, index){
                  return NoteCard(
                    note: snapshot.data![index],
                    onDel: ()async{
                      await _noteRepository!.deleteNoteByNoteId(snapshot.data![index]);
                    },
                  );
                }, 
                separatorBuilder: (context, index){
                  return SizedBox(height: 5,);
                }, 
                itemCount: snapshot.data!.length);
            }
      
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  MdiIcons.notebookPlusOutline,
                  size: 70,
                  color: Colors.blueGrey,
                ),
                Center(child: Text(
                  'No Notes added',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.grey[600]
                  ),
                )),
              ],
            );
          }),
      ),


    );
  }
}
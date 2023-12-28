import 'package:devotionals/controllers/retrieve.dart';
import 'package:devotionals/utils/bible_map.dart';
import 'package:devotionals/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class BibleViewScreen extends StatefulWidget {
  final String bibleRef;
  const BibleViewScreen({
    required this.bibleRef,
    super.key});

  @override
  State<BibleViewScreen> createState() => _BibleViewScreenState();
}

class _BibleViewScreenState extends State<BibleViewScreen> {
  final bible = BibleReader();
  List<List<dynamic>> bibleList = [];
  List<List<dynamic>> myScriptures = [];

  String? book;
  String? chapter;
  String? startVerse;
  String? endVerse;

  Future getScripture()async{
    String vv = widget.bibleRef.trim();
    List<String> newString = [];
    for (int i = 0; i < vv.length; i++) {
    String currentChar = vv[i];

    if (currentChar == ',' || currentChar == ';') {
      currentChar = '';
    }

    newString.add(currentChar);
  }

    String _new = newString.join('');
    final ref = _new.split(' ');

    if (int.tryParse(ref[0]) != null) {
      book = '${ref[0]} ${ref[1]}';

      String verseC = ref.sublist(2).join('');

      if(int.tryParse(verseC.trim()) != null){
        chapter = verseC;
        print(chapter);
      }
      else{
        final vc = verseC.trim().split(':');
        chapter = vc[0];
        final v = vc[1];
        
        if (int.tryParse(v.trim()) != null) {
          startVerse = v.trim();
        } else {
          final sev = v.split('-');
          startVerse = sev[0];
          endVerse = sev[1];
        }
      }

    } else {
      book = ref[0];
      String verseC = ref.sublist(1).join('');

      if(int.tryParse(verseC.trim()) != null){
        chapter = verseC;
      }
      else{
        final vc = verseC.trim().split(':');
        chapter = vc[0];
        final v = vc[1];
        
        if (int.tryParse(v.trim()) != null) {
          startVerse = v.trim();
        } else {
          final sev = v.split('-');
          startVerse = sev[0];
          endVerse = sev[1];
        }
      }
    }

    setState(() {});
  }

  Future loadBible()async{
    String bibleFile = await rootBundle.loadString('assets/bibles/kjv.csv');
    bibleList = await bible.loadBibleData(bibleFile);

    setState(() {
      
    });
  }


  void getText()async{
    await loadBible();
    await getScripture();

    int? bookNumber = booksOfTheBible[book!.toLowerCase()];
    print(bookNumber);
    
    myScriptures = bibleList.where((element){
      return element[0] == bookNumber && element[1] == int.parse(chapter!);
    }).toList();

    setState(() {
    });

    _scrollTo();
  }


  bool selected(int x){
    if (startVerse != null && endVerse!=null) {
      if (x >= int.parse(startVerse!) && x<=int.parse(endVerse!)) {
        return true;
      }
    } else {
      if (startVerse == null && endVerse==null) {
        return false;
      }
      if (endVerse==null) {
        return int.parse(startVerse!)==x;
      }
    }

    return false;
  }

  ItemScrollController _scrollController = ItemScrollController();

  void _scrollTo(){
    if (startVerse != null) {
      Future.delayed(
        Duration(milliseconds: 300),
        (){
          _scrollController.scrollTo(index: int.parse(startVerse!)-1, duration: Duration(milliseconds: 300));
        }
      );
    }

    setState(() {
      
    });
  }

  @override
  void initState() {
    getText();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.bibleRef
        ),

        actions: [
        ],
      ),
      body: ScrollablePositionedList.builder(
        itemScrollController: _scrollController,
        itemCount: myScriptures.length,
        itemBuilder: (context, index){
          if (index == int.parse(startVerse!)+2) {
            _scrollController.scrollTo(index: int.parse(startVerse!)-1, duration: Duration(milliseconds: 200));
          }
          return ListTile(
            selected: selected(myScriptures[index][2]),
            selectedTileColor: cricColor.shade50,
            leading: Text(
              myScriptures[index][2].toString(),
              style: TextStyle(
                color: cricColor,
                fontSize: 16
              ),
            ),

            title: Text(
              myScriptures[index][3].toString(),

              style: TextStyle(
                fontSize: 16
              ),
            ),
          );
        }
      )
    );
  }
}


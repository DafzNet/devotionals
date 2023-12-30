import 'package:devotionals/controllers/retrieve.dart';
import 'package:devotionals/utils/bible_map.dart';
import 'package:devotionals/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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
  List<List<List<dynamic>>> myScripturesMult = [];

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

      if(int.tryParse(verseC.trim()) != null || RegExp(r'\d+-\d+').hasMatch(verseC.trim())){
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

      if(int.tryParse(verseC.trim()) != null || RegExp(r'\d+-\d+').hasMatch(verseC.trim())){
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


  // String? book;
  // String? chapter;
  // String? startVerse;
  // String? endVerse;

  // Future<void> getScripture() async {
  //   String bibleRef = widget.bibleRef.trim();
  //   List<String> characters = bibleRef.split('');
  //   List<String> newString = [];

  //   for (String currentChar in characters) {
  //     if (currentChar != ',' && currentChar != ';') {
  //       newString.add(currentChar);
  //     }
  //   }

  //   String cleanedRef = newString.join('');
  //   final ref = cleanedRef.split(' ');

  //   if (ref.isNotEmpty) {
  //     if (int.tryParse(ref[0]) != null) {
  //       // The first word is a number, indicating a verse or chapter
  //       book = ref.length > 1 ? '${ref[0]} ${ref[1]}' : ref[0];

  //       if (ref.length > 2) {
  //         String verseC = ref.sublist(2).join('');

  //         if (int.tryParse(verseC.trim()) != null) {
  //           chapter = verseC;
  //         } else {
  //           processVerse(verseC);
  //         }
  //       }
  //     } else {
  //       // The first word is not a number, indicating a book
  //       book = ref[0];
  //       if (ref.length > 1) {
  //         String verseC = ref.sublist(1).join('');
  //         if (int.tryParse(verseC.trim()) != null) {
  //           chapter = verseC;
  //         } else {
  //           processVerse(verseC);
  //         }
  //       }
  //     }

  //     setState(() {});
  //   }
  // }

  // void processVerse(String verseC) {
  //   final vc = verseC.trim().split(':');
  //   chapter = vc[0];
  //   final v = vc[1];

  //   if (int.tryParse(v.trim()) != null) {
  //     startVerse = v.trim();
  //   } else {
  //     final sev = v.split('-');
  //     startVerse = sev[0];
  //     endVerse = sev[1];
  //   }
  // }

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
    
    if (chapter != null && !RegExp(r'\d+-\d+').hasMatch(chapter!)) {
      myScriptures = bibleList.where((element){
        return element[0] == bookNumber && element[1] == int.parse(chapter!);
      }).toList();
    } else {
      String n = chapter!.split('-')[0];
      String m = chapter!.split('-')[1];


      // myScriptures = bibleList.where((element){
      //   return element[0] == bookNumber && element[1] >= int.parse(n) && element[1] <= int.parse(m);
      // }).toList();

      for (var i = int.parse(n); i <= int.parse(m); i++) {
        myScriptures = bibleList.where((element){
          return element[0] == bookNumber && element[1] == i;
        }).toList();

        myScripturesMult.add(myScriptures);
      }
    }

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
        Duration(milliseconds: 200),
        (){
          _scrollController.scrollTo(index: int.parse(startVerse!)-1, duration: Duration(milliseconds: 300));
        }
      );
    }

    setState(() {
      
    });
  }


  final _pageController = PageController();

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
      body: myScripturesMult.isEmpty? ScrollablePositionedList.builder(
        itemScrollController: _scrollController,
        itemCount: myScriptures.length,
        itemBuilder: (context, index){
          if ( startVerse!=null && index == int.parse(startVerse!)+2) {
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
      ):PageView.builder(
        itemCount: myScripturesMult.length,
        controller: _pageController,
        itemBuilder: (context, index0){
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    iconSize: 40,
                    onPressed: (){
                      _pageController.previousPage(
                        duration: Duration(milliseconds: 200), 
                        curve: Curves.bounceIn);
                    },
                    icon: Icon(
                      MdiIcons.chevronLeft,
                    )
                  ),

                  Text(
                    'Chapter ${myScripturesMult[index0][1][1].toString()}',

                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),
                  ),

                  IconButton(
                    iconSize: 40,
                    onPressed: (){
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 200), 
                        curve: Curves.bounceIn);
                    }, 
                    icon: Icon(
                      MdiIcons.chevronRight,
                    )
                  ),
                ],
              ),
              Expanded(
                child: ScrollablePositionedList.builder(
                  itemCount: myScripturesMult[index0].length,
              
                  itemBuilder: (context, index){
                    return ListTile(
                      selectedTileColor: cricColor.shade50,
                      leading: Text(
                        myScripturesMult[index0][index][2].toString(),
                        style: TextStyle(
                          color: cricColor,
                          fontSize: 16
                        ),
                      ),
              
                      title: Text(
                        myScripturesMult[index0][index][3].toString(),
              
                        style: TextStyle(
                          fontSize: 16
                        ),
                      ),
                    );
                  }
                ),
              ),
            ],
          );   
        }
      )
    );
  }
}


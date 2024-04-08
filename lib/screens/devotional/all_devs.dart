import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devotionals/firebase/dbs/devs.dart';
import 'package:devotionals/dbs/sembast/generic.dart';
import 'package:devotionals/utils/constants/colors.dart';
import 'package:devotionals/utils/models/models.dart';
import 'package:devotionals/utils/widgets/cards/devotional.dart';
import 'package:flutter/material.dart';

// class AllDevotionals extends StatefulWidget {
//   final String uid;
//   const AllDevotionals({
//     required this.uid,
//     super.key});

//   @override
//   State<AllDevotionals> createState() => _AllDevotionalsState();
// }

// class _AllDevotionalsState extends State<AllDevotionals> {
//   final _store = DataStore('devotional');

//   final DevotionalService _devotionalService = DevotionalService();
//   late List<DevotionalModel> devotionals;
//   DocumentSnapshot? lastDocument;

//   @override
//   void initState() {
//     super.initState();
//     devotionals = [];
//     _loadData();

//     _scrollController.addListener(() {
//       setState(() {
//         _isTitleVisible = _scrollController.offset > 100; // Adjust the offset as needed
//       });
//     });
//   }

//   Future<void> _loadData() async {
//   if (isLoading) {
//     return;
//   }

//   setState(() {
//     isLoading = true;
//   });

//   try {
//     List<DevotionalModel> newData;
//     DocumentSnapshot? newLastDocument;

//     // Destructure the result from getDevotionals
//     [newData, newLastDocument] = await _devotionalService.getDevotionals(lastDocument: lastDocument);

//     setState(() {
//       devotionals.addAll(newData);
//       lastDocument = newLastDocument;
//     });
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   bool isLoading = false;

//   final  ScrollController _scrollController = ScrollController();
//   bool _isTitleVisible = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: NestedScrollView(
//         controller: _scrollController,
//         headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
//           return [
//             SliverAppBar(
//               expandedHeight: 300,
//               floating: true,
//               pinned: true,              
//               flexibleSpace: FlexibleSpaceBar(
              
//               title:_isTitleVisible ? Text('A Word In Due Season'):null,
      
//               background: SizedBox(
//                 width: MediaQuery.of(context).size.width,
//                 child: Image.asset(
//                   'assets/images/dev.jpg',
//                   fit: BoxFit.cover,
//                 ),
//               )
//             )
//             ),
//           ];
//         },

//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 12),
//         child: ListView.separated(
//           itemCount: devotionals.length + (isLoading ? 1 : 0),
//           itemBuilder: (context, index) {
//             if (index == devotionals.length) {
//               // Show loading indicator at the end of the list while more data is being loaded
//               return Column(
//                 children: [
//                   Center(child: CircularProgressIndicator()),
//                 ],
//               );
//             } else {
//               DevotionalModel devotional = devotionals[index];
//               return DevotionalCard(model: devotional,uid: widget.uid,);
//             }
//           },

//           separatorBuilder: (context, index) {
//             return SizedBox(height: 10,);
//           },
//           // Trigger _loadData when reaching the end of the list
          
//         ),
//       ),
//       )
//     );
//   }
// }




class AllDevotionals extends StatefulWidget {
  final String uid;
  const AllDevotionals({
    required this.uid,
    Key? key,
  }) : super(key: key);

  @override
  State<AllDevotionals> createState() => _AllDevotionalsState();
}

class _AllDevotionalsState extends State<AllDevotionals> {
  final _devotionalService = DevotionalService();
  late List<DevotionalModel> devotionals;
  DocumentSnapshot? lastDocument;
  final ScrollController _nestedScrollController = ScrollController();
  final ScrollController _listScrollController = ScrollController();
  bool _isTitleVisible = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    devotionals = [];
    _loadData();

    _listScrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_listScrollController.position.pixels ==
        _listScrollController.position.maxScrollExtent) {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    if (_isLoading) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final newData = await _devotionalService.getDevotionals(lastDocument: lastDocument);

      setState(() {
        devotionals.addAll(newData[0]);
        lastDocument = newData[1];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _nestedScrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              floating: true,
              title: Text('A Word in Due Season'),
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: SweepGradient(
                      colors: [
                        cricColor.shade300,
                        cricColor.shade200,
                        cricColor.shade300,
                        cricColor.shade200,
                        cricColor.shade300,
                        cricColor.shade200,
                        cricColor.shade300,
                        cricColor.shade200,
                        cricColor.shade300,
                        cricColor.shade200,
                        cricColor.shade300,
                        cricColor.shade200
                      ]
                    )
                  ),
                ),
              ),

            ),
          ];
        },
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ListView.separated(
            controller: _listScrollController,
            itemCount: devotionals.length + (_isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == devotionals.length) {
                // Show loading indicator at the end of the list while more data is being loaded
                return Column(
                  children: [
                    Center(child: CircularProgressIndicator()),
                  ],
                );
              } else {
                DevotionalModel devotional = devotionals[index];
                return DevotionalCard(model: devotional, uid: widget.uid);
              }
            },
            separatorBuilder: (context, index) {
              return SizedBox(height: 10);
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nestedScrollController.dispose();
    _listScrollController.dispose();
    super.dispose();
  }
}

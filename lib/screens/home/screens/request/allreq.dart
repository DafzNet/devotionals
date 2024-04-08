import 'package:devotionals/dbs/sembast/generic.dart';
import 'package:devotionals/firebase/dbs/prayerrequest.dart';
import 'package:devotionals/utils/constants/colors.dart';
import 'package:devotionals/utils/models/prayerreq.dart';
import 'package:devotionals/utils/widgets/cards/req.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AllPrayerRequests extends StatefulWidget {
  final String uid;
  const AllPrayerRequests(this.uid,{super.key});

  @override
  State<AllPrayerRequests> createState() => _AllPrayerRequestsState();
}

class _AllPrayerRequestsState extends State<AllPrayerRequests> {

  final prayerStore = DataStore('requests');
  List<Map<String, dynamic>>? storePrayers;

  @override
  void initState() {
    super.initState();
    _getReqs();
  }

  void _getReqs()async{
    final _all = await prayerStore.getList('prayers');
    storePrayers = _all??[];
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
              title: Text('Prayer Requests'),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        child: FutureBuilder(
          future: PrayerFire().getPrayerRequests(),
          builder: (context, snapshot) {
        
            if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty || snapshot.connectionState == ConnectionState.waiting){
              
              if (storePrayers!=null && storePrayers!.isNotEmpty) {
                final _myPrayers = storePrayers!.map((e) => PrayerRequest.fromMap(e)).toList();
        
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount:  _myPrayers.length,
                  itemBuilder: (context, index){
                    return Column(
                      children: [
                        PrayerRequestCard(
                          uid: widget.uid,
                          req: _myPrayers[index],
                          
                        ),

                        SizedBox(height: 10,)
                      ],
                    );
                  }
                );
              }
              return Container();             
            }
        
            final _data = snapshot.data;
            print(_data);
        
            prayerStore.insertList('prayers', List<Map<String, dynamic>>.from(_data!.map((e) =>e.toMap()).toList()));
        
            return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount:  _data.length,
              itemBuilder: (context, index){
                return Column(
                  children: [
                    PrayerRequestCard(
                      uid: widget.uid,
                      req: _data[index],
                      
                    ),
                     SizedBox(height: 10,)
                  ],
                );
              }
            );
          }
        ),
      ),
    );
  }
}
import 'package:devotionals/dbs/sembast/generic.dart';
import 'package:devotionals/firebase/dbs/prayerrequest.dart';
import 'package:devotionals/utils/constants/colors.dart';
import 'package:devotionals/utils/widgets/cards/req.dart';
import 'package:flutter/material.dart';

class PendingPrayerRequests extends StatefulWidget {
  final String uid;
  const PendingPrayerRequests(this.uid,{super.key});

  @override
  State<PendingPrayerRequests> createState() => _PendingPrayerRequestsState();
}

class _PendingPrayerRequestsState extends State<PendingPrayerRequests> {

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
              title: Text('Pending Requests'),
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
        child: StreamBuilder(
          stream: PrayerFire().getPrayerRequestsAdminStream(),
          builder: (context, snapshot) {
        
            if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty || snapshot.connectionState == ConnectionState.waiting){
              
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
                    // if(_data[index].waiting)
                    PrayerRequestCard(
                      req: _data[index],
                      uid: widget.uid,
                      admin: true,
                      
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
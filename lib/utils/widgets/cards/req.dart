import 'package:devotionals/firebase/dbs/prayerrequest.dart';
import 'package:devotionals/screens/home/screens/request/reqdet.dart';
import 'package:devotionals/utils/constants/constants.dart';
import 'package:devotionals/utils/models/prayerreq.dart';
import 'package:devotionals/utils/widgets/allusers.dart';
import 'package:devotionals/utils/widgets/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

class PrayerRequestCard extends StatefulWidget {
  final PrayerRequest req;
  final String uid;
  final VoidCallback? onPressed;
  final  bool admin;

  const PrayerRequestCard({
    required this.req,
    this.onPressed,
    required this.uid,
    this.admin = false,
    Key? key,
  }) : super(key: key);

  @override
  State<PrayerRequestCard> createState() => _PrayerRequestCardState();
}

class _PrayerRequestCardState extends State<PrayerRequestCard> {

  bool accepting = false;
  bool deleting = false;


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: InkWell(
        onTap: widget.onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.req.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: titleFontSmall,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    DateFormat('d/M/yy | hh:m').format(widget.req.date),
                    style: const TextStyle(
                      fontSize: bodyFontSmall,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                widget.req.request.trim(),
                style: const TextStyle(
                  fontSize: bodyFontMedium,
                ),
                maxLines: widget.admin?10 :3,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  UserWidget(
                    user: widget.req.user,
                  ),

                  TextButton(
                    onPressed:widget.onPressed??(){
                      
                      Navigator.push(
                        context,
                        PageTransition(child: RequestDetails(uid: widget.uid, req: widget.req,), type: PageTransitionType.fade));
                    },
                    child: Text(
                      'View Details',
                      style: TextStyle(
                        color: cricColor.shade200,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),


              if(widget.admin)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                 if(!accepting)...[
                  TextButton(
                    onPressed: ()async{
                      setState(() {
                        accepting = true;
                      });

                      await PrayerFire().updatePrayerRequest(widget.req.copyWith(waiting: false));

                      setState(() {
                        accepting = false;
                      });
                    },

                    child: Text(
                      'Accept',
                      style: TextStyle(
                        color: cricColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),]else...[
                    SizedBox(width: 15, height: 15, child: CircularProgressIndicator(strokeWidth: 2,))
                  ],

                if(!deleting)...[
                  TextButton(
                    onPressed: ()async{
                      setState(() {
                        accepting = true;
                      });

                      await PrayerFire().deletePrayerRequest(widget.req);

                      setState(() {
                        accepting = false;
                      });
                    },
                    child: const Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),]else...[
                    SizedBox(width: 15, height: 15, child: CircularProgressIndicator(strokeWidth: 2,))
                  ]
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

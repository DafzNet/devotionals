import 'package:devotionals/firebase/dbs/event_fs.dart';
import 'package:devotionals/utils/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventNavigation extends StatefulWidget {
  const EventNavigation({
    super.key});

  @override
  State<EventNavigation> createState() => _EventNavigationState();
}

class _EventNavigationState extends State<EventNavigation> with WidgetsBindingObserver {


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text(''),

        // actions: [
        //   TextButton(onPressed: null, child: Text('Weekly'))
        // ],
      ),

      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(logo),
            fit: BoxFit.contain,
            opacity: .3
          )
        ),
        child: FutureBuilder(
          future: EventFirestoreService().getAllEvents(),
          builder: (context, snapshot) {

            if (snapshot.hasError || snapshot.connectionState == ConnectionState.waiting || snapshot.data == null) {
             return SfCalendar(
                  view: CalendarView.schedule,
                  onTap: (det){
                    if (det.appointments!.isNotEmpty) {
                      print(det.appointments!.first);
                    }
                  },
                  todayHighlightColor: Colors.transparent,
            
                  // backgroundColor: cricColor.shade100,
                  monthViewSettings: MonthViewSettings(
                    appointmentDisplayMode: MonthAppointmentDisplayMode.appointment
                  ),
                ); 
            }

            final List<Meeting> meetings = snapshot.data!.map((e) {
              return Meeting(e.title, e.startDate, e.endDate??DateTime.now(), e.color??Colors.transparent, false, e.venue??'');
            },).toList();


            return SfCalendar(
                  view: CalendarView.schedule,
                  onTap: (det){
                    if (det.appointments!.isNotEmpty) {
                      print(det.appointments!.first);
                    }
                  },
                  
                  todayHighlightColor: Colors.transparent,
                  todayTextStyle: TextStyle(
                  color: Colors.grey[600]),
                  // backgroundColor: cricColor.shade100,
                  dataSource: MeetingDataSource(meetings),
                  monthViewSettings: MonthViewSettings(
                      appointmentDisplayMode: MonthAppointmentDisplayMode.appointment
                    ),
                );
          }
        )
        
      ),

      
    );

  }
}





class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source){
    appointments = source;
  }



  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  String? getLocation(int index){
    return appointments![index].location;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay, this.location);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
  String location;

}
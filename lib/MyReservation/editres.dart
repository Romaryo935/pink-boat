import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';
import 'edittime.dart';

import 'my_res.dart';
DateTime aa;
String modidedit;
String testnameedit;
final Map<DateTime, List> _holidays = {
  DateTime(2019, 1, 1): ['New Year\'s Day'],
  DateTime(2019, 1, 6): ['Epiphany'],
  DateTime(2019, 2, 14): ['Valentine\'s Day'],
  DateTime(2019, 4, 21): ['Easter Sunday'],
  DateTime(2019, 4, 22): ['Easter Monday'],
};


class EditReservation extends StatefulWidget {


  
  @override
  _EditReservationState createState() => _EditReservationState();
  
}

class _EditReservationState extends State<EditReservation> with TickerProviderStateMixin {

DateTime selectedDay;
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  
  void initState() {
    super.initState();
   

    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }



  void _onVisibleDaysChanged(DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  @override
  Widget build(BuildContext context) {
      dynamic comingidedit = ModalRoute.of(context).settings.arguments;
    setState(() {
        if(comingidedit["test_center"]!=null){
     modidedit = comingidedit["test_center"]["_id"];
     testnameedit = comingidedit["test_center"]["medical_org"]["name"];
      }
      else{
        if(comingidedit["mobileCenter"]["test_center"]!=null)
        {
 modidedit = comingidedit["mobileCenter"]["test_center"]["_id"];
  testnameedit = comingidedit["mobileCenter"]["test_center"]["medical_org"]["name"];
        }
        else {
         modidedit = comingidedit["nearestSchedule"]["mobileTestCenter_id"]["test_center"];
          testnameedit = comingidedit["mobileCenter"]["name"];
        }
      } 
    }); 
    return Scaffold(

      appBar: AppBar(
         backgroundColor: Colors.pink[400],
          title: Text(
            'edit Reservation',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              // fontFamily: Utils.ubuntuRegularFont
            ),
          ),
        centerTitle: true,
           leading: FlatButton(onPressed: (){
            Navigator.pop(context);
          }, child: Icon(  
            Icons.arrow_back,
            color: Colors.white
          ), ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          // Switch out 2 lines below to play with TableCalendar's settings
          //-----------------------
          Container(
            child:_buildTableCalendar(),
            height: 390,
            width: double.infinity,

          ),

          // _buildTableCalendarWithBuilders(),


          RaisedButton(

            child: Text('Continue',
              style: TextStyle(
                color: Colors.white,

              ),

            ),
            color: Colors.pink,
            onPressed: (){
              debugPrint(selectedDay.toString());
                 Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => EditTime(),
                settings: RouteSettings(
                  arguments: selectedDay,
                )));
            },
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(20.0),
                side: BorderSide(color: Colors.pinkAccent)
            ),
          ),

        ],

      ),
       );

  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar() {
    
    return TableCalendar(
      calendarController: _calendarController,
      holidays: _holidays,
      startingDayOfWeek: StartingDayOfWeek.saturday,
      calendarStyle: CalendarStyle(
        todayColor: Colors.pink,
        markersColor: Colors.pink[700],
        outsideDaysVisible: true,
      ),
    
      // header style of calendar
      headerStyle: HeaderStyle(
        formatButtonTextStyle: TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.pink,
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
       onDaySelected: (date,events){
          setState(() {
            selectedDay=date;
            aa=date;
          });
      },
    );
  }

  // More advanced TableCalendar configuration (using Builders & Styles)
  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      locale: 'pl_PL',
      calendarController: _calendarController,

      holidays: _holidays,
      initialCalendarFormat: CalendarFormat.twoWeeks,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.saturday,
      availableGestures: AvailableGestures.all,

      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekendStyle: TextStyle().copyWith(color: Colors.pink),
        holidayStyle: TextStyle().copyWith(color: Colors.pink),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.pink),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              color: Colors.deepOrange[300],
              width: 100,
              height: 100,
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            color: Colors.amber[400],
            width: 100,
            height: 100,
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(fontSize: 16.0),
            ),
          );
        },

      ),

      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
      
    );
    


  }







  }




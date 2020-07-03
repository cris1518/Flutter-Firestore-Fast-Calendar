import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import "package:l1pro/ApiUtil.dart";
import 'push_nofitications.dart' as notif;
import "contacts/LisCont.dart";
class CalendarScreen extends StatefulWidget {
  static const String id = 'calendar_screen';
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarController _calendarController;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  TextEditingController _eventController;
  SharedPreferences prefs;
  String _improf;
  String _nute;
  String dsele;
  @override
  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();
    _calendarController = CalendarController();
    _eventController = TextEditingController();
    _events = {};
    _selectedEvents = [];
    dsele="";
    _improf = "";
    _nute="";
    initPrefs();
  }

  initPrefs() async {
    prefs = await SharedPreferences.getInstance();
   var val=await ApiUtil().ImProf();
    var utente = await FirebaseAuth.instance.currentUser();
    var nome = utente.displayName;
    setState(() {
      _improf=val;
      _nute=nome;//prefs.getString("Username");
      print(val);
      _events = Map<DateTime, List<dynamic>>.from(
          decodeMap(json.decode(prefs.get('events') ?? '{}')));
    });
  }

  // Encode Date Time Helper Method
  Map<String, dynamic> encodeMap(Map<DateTime, dynamic> map) {
    Map<String, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[key.toString()] = map[key];
    });
    return newMap;
  }

  // decode Date Time Helper Method
  Map<DateTime, dynamic> decodeMap(Map<String, dynamic> map) {
    Map<DateTime, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[DateTime.parse(key)] = map[key];
    });
    return newMap;
  }



  @override
  Widget build(BuildContext context) {

    var enDatesFuture = initializeDateFormatting('it', null);
    notif.PushNotificationsManager().init();

    final ImgContr = TextEditingController();
    ImgContr.text=_improf;

    return Scaffold(
      backgroundColor: Colors.white,

        drawer: Drawer(

          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(

            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[

              Container(

                child: Column(children:<Widget>[

                  Divider(
                    color: Colors.transparent,
                    height: 190,
                    thickness: 5,
                    indent: 120,
                    endIndent: 0,
                  ),

                  Text(_nute, style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),)]),
                height: 240.0,
                width: MediaQuery.of(context).size.width - 100.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.black,

                    image: DecorationImage(
                        image: new NetworkImage(
                            "https://firebasestorage.googleapis.com/v0/b/promemoria-be40e.appspot.com/o/felix-wiedemann-YuyGosrgyfY-unsplash.jpg?alt=media&token=981e93e9-a557-4b3b-81ac-8daf387a67ec",
                        ),
                        fit: BoxFit.fill,
                        colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.dstATop),
                    )
                ),
              ),





              ListTile(
                leading:Icon(Icons.add),
                title: Text('Crea Evento'),
                onTap: () {
                  ApiUtil().ApriEvento({},context,"SI");
                  // ...
                },
              ),
              ListTile(
                leading:Icon(Icons.account_circle),
                title: Text('Contatti'),
                onTap: () {

                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => ListCont()));

                },
              ),
              ListTile(
                leading:Icon(Icons.settings),
                title: Text('Impostazioni'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                leading:Icon(Icons.exit_to_app),
                title: Text('Esci'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                 ApiUtil().UteLogout(context);
                },
              ),
            ],
          ),
        ),
      appBar: AppBar(
        title: Text('Promemoria'),
        backgroundColor: Colors.blue.shade800,

          actions: <Widget>[

            IconButton(
              icon:Icon( Icons.sync),
              onPressed: () async {

                await ApiUtil().CaricaEv();

                await initPrefs();

              },
            ),
          ]
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TableCalendar(
              locale: 'it_IT',
              events: _events,
              initialCalendarFormat: CalendarFormat.month,
              calendarStyle: CalendarStyle(
                markersColor: Colors.red.shade400,
                todayColor: Colors.blue.shade300,
                selectedColor: Colors.blue.shade800,
                todayStyle:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              headerStyle: HeaderStyle(
                formatButtonDecoration: BoxDecoration(
                  color: Colors.blue.shade800,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                formatButtonTextStyle: TextStyle(color: Colors.white),
                formatButtonShowsNext: false,
              ),
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarController: _calendarController,
              onDaySelected: (date, events) {
                setState(() {
                  print(date.toIso8601String());
                  dsele=date.toIso8601String();
                  _selectedEvents = events;
                });
              },
            ),
            ..._selectedEvents.map((event) => Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 5.8,color: Colors.blue.shade700),

                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.blue.shade600,
                  ),
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10.0),

                  child:   ListTile(

                    leading: Text( event["Data Inizio"].toString().substring(11,16),  style: TextStyle(color: Colors.white, fontSize: 15),),
                    title: Text(
                      event["Contatto"],
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    subtitle: Text(
                      event["Oggetto"],
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    onTap: () => ApiUtil().ApriEvento(event,context,"NO"),

                  ),
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade800,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          ApiUtil().ApriEvento({},context,"SI");
        },
      ),
    );
  }

  _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Calendar Event:'),
        content: TextFormField(
          controller: _eventController,
          keyboardType: TextInputType.multiline,
          maxLines: 4,
        ),
        actions: <Widget>[
          Row(
            children: <Widget>[
              FlatButton(
                color: Colors.deepOrange,
                child: Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  setState(() {
                    if (_eventController.text.isEmpty) return;

                    if (_events[_calendarController.selectedDay] != null) {
                      _events[_calendarController.selectedDay]
                          .add("_eventController.text");
                    } else {
                      _events[_calendarController.selectedDay] = [
                        _eventController.text
                      ];
                    }

                    prefs.setString('events', json.encode(encodeMap(_events)));
                    Navigator.of(context).pop();
                    _eventController.clear();
                  });
                },
              ),
              SizedBox(
                width: 10.0,
              ),
              FlatButton(
                color: Colors.grey,
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        ],
      ),
    );
  }



}


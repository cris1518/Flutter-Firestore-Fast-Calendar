import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import "package:l1pro/ApiUtil.dart";
import 'push_nofitications.dart' as notif;
import 'Home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

// For changing the language
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_cupertino_localizations/flutter_cupertino_localizations.dart';

const appName = 'DateTimeField Example';

void main() => runApp(MaterialApp(
  title: appName,
  home: MyHomePage(text: ""),

  theme: ThemeData(
      inputDecorationTheme:
      InputDecorationTheme(border: OutlineInputBorder())),
  localizationsDelegates: [
    // ... app-specific localization delegate[s] here
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: [

    const Locale('it'), // Chinese
  ],
));

class MyHomePage extends StatefulWidget {


  final String text;
  final String dsel;
  MyHomePage({Key key, @required this.text,this.dsel}) : super(key: key);
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    var devento=jsonDecode(widget.text);





    return Scaffold(

      appBar: AppBar(
          backgroundColor: Colors.blue.shade800,
          title: Text("Gestione Evento"),
          leading: GestureDetector(
            onTap: () { /* Write listener code here */ },
            child: Icon(
              Icons.menu,  // add custom icons also
            ),
          ),
          actions: <Widget>[

            IconButton(
              icon:Icon( Icons.arrow_back),
              onPressed: () {

                ApiUtil().BackEvento(context);

              },
            ),
          ]
      ),
      body: ListView(
        padding: EdgeInsets.all(24),
        children: <Widget>[
          DateTimeForm(text2: widget.text,),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade800,
        child: Icon(
          Icons.save,
          color: Colors.white,
        ),
        onPressed: () {
          print("widge.");
        },
      ),
    );
  }
}

class DateTimeForm  extends StatefulWidget {
  final String text2;
  DateTimeForm({Key key, @required this.text2}) : super(key: key);

  @override
  _DateTimeFormState createState() => _DateTimeFormState(text3: text2);
}

class _DateTimeFormState extends State<DateTimeForm> {

  final String text3;
  _DateTimeFormState({Key key, @required this.text3}) ;

  final Cliente = TextEditingController();

  final Oggetto = TextEditingController();
  final Note = TextEditingController();


  final Datat = TextEditingController();
  final format = DateFormat("yyyy-MM-dd HH:mm");

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var evento=jsonDecode(text3);
    Cliente.text=evento["Cliente"].toString();
    Oggetto.text=evento["Descr"].toString();
    Note.text=evento["Note"].toString();

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.center, // Align however you like (i.e .centerRight, centerLeft)
            child: Text("Cliente",style: TextStyle(color: Colors.blue.shade800, fontSize: 16)),
          ),
          TextField(

            readOnly: true,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search,
                color:Colors.blue ,
              ),

              enabledBorder: const OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blue, width: 0.5),
              ),

              focusedBorder: const OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blue, width: 1.5),
              ),

              border: const OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 0.5),
              ),
            ),
            controller: Cliente,
          ), new Divider(),new Divider(),new Divider(),
          Align(
            alignment: Alignment.center, // Align however you like (i.e .centerRight, centerLeft)
            child: Text("Oggetto",style: TextStyle(color: Colors.blue.shade800, fontSize: 16)),
          ),
          TextField(
            controller: Oggetto,
            decoration: InputDecoration(

              enabledBorder: const OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blue, width: 0.5),
              ),

              focusedBorder: const OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blue, width: 1.5),
              ),

              border: const OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 0.5),
              ),
            ),
          ),
          new Divider(),new Divider(),new Divider(),



          Text('Inserire Data e Ora',style: TextStyle(color: Colors.blue.shade800, fontSize: 16)),
          DateTimeField(
              controller: Datat,
              decoration: InputDecoration(

                enabledBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue, width: 0.5),
                ),

                focusedBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                ),

                border: const OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 0.5),
                ),
              ),
              format: format,
              onShowPicker: (context, currentValue) async {
                final date = await showDatePicker(
                    context: context,
                    firstDate: DateTime(1900),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2100));
                if (date != null) {
                  final time = await showTimePicker(
                    context: context,
                    initialTime:
                    TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                  );

                  return DateTimeField.combine(date, time);
                } else {


                  return currentValue;
                }
              }
          ),


          new Divider(),new Divider(),new Divider(),
          Align(
            alignment: Alignment.center, // Align however you like (i.e .centerRight, centerLeft)
            child: Text("Note",style: TextStyle(color: Colors.blue.shade800, fontSize: 16)),

          ),
          TextField(
            controller: Note,
            maxLines: 15,

            decoration: InputDecoration(

              enabledBorder: const OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blue, width: 0.5),
              ),

              focusedBorder: const OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blue, width: 1.5),
              ),

              border: const OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 0.5),
              ),
            ),
          ),




        ],
      ),
    );
  }
}




import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
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
  final String nuovo;
  final String dsel;
  MyHomePage({Key key, @required this.text,this.dsel,this.nuovo}) : super(key: key);
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    var devento=jsonDecode(widget.text);



    final Cliente = TextEditingController();
    final ClienteCod= TextEditingController();
    final Oggetto = TextEditingController();
    final Note = TextEditingController();


    final Datat = TextEditingController();
    final format = DateFormat("yyyy-MM-dd HH:mm");

    final formKey = GlobalKey<FormState>();

    var evento=jsonDecode(widget.text);
    Cliente.text=evento["Contatto Descr"].toString();
    ClienteCod.text=evento["Contatto"].toString();
    Oggetto.text=evento["Oggetto"].toString();
    Note.text=evento["Descrizione"].toString();
   Datat.text=evento["Data Inizio"].toString().replaceAll("T"," ").replaceAll("Z","");
   if(evento["Data Inizio"]!="" && evento["Data Inizio"]!=null ){}
   else{ Datat.text= new DateTime.now().toString().substring(0,16);}
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.blue.shade800,
            title: Text("Gestione Evento"),
            leading: GestureDetector(
              onTap: () async{  await  ApiUtil().BackEvento(context); },
              child: Icon(
                Icons.arrow_back,  // add custom icons also
              ),
            ),

        ),
        body: ListView(
          padding: EdgeInsets.all(24),
          children: <Widget>[
 Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.center, // Align however you like (i.e .centerRight, centerLeft)
                child: Text("Contatto",style: TextStyle(color: Colors.blue.shade800, fontSize: 16)),
              ), Divider(
                color: Colors.transparent,
                height: 15,
                thickness: 5,
                indent: 120,
                endIndent: 0,
              ),
              TextField(

              onTap: () async{

               
                evento["Contatto Descr"]=Cliente.text;
                evento["Contatto"]=ClienteCod.text;
                evento["Oggetto"]=Oggetto.text;
                evento["Descrizione"]=Note.text;
                evento["Data"]=Datat.text;
                final prefs = await SharedPreferences.getInstance();
                prefs.setString("BKEventoN",widget.nuovo);
                prefs.setString("BKEvento",jsonEncode(evento));
               await ApiUtil().ApriCercaCli(context);


              },
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'Cerca Cliente',
                  hintStyle: TextStyle(color: Colors.blue.shade800),
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
              ) , Divider(
      color: Colors.transparent,
      height: 40,
      thickness: 5,
      indent: 120,
      endIndent: 0,
    ),

              Align(
                alignment: Alignment.center, // Align however you like (i.e .centerRight, centerLeft)
                child: Text("Data e Ora",style: TextStyle(color: Colors.blue.shade800, fontSize: 16)),
              ),
              Divider(
                color: Colors.transparent,
                height: 15,
                thickness: 5,
                indent: 120,
                endIndent: 0,
              ),
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


              Divider(
                color: Colors.transparent,
                height: 40,
                thickness: 5,
                indent: 120,
                endIndent: 0,
              ),

              Align(
                alignment: Alignment.center, // Align however you like (i.e .centerRight, centerLeft)
                child: Text("Oggetto",style: TextStyle(color: Colors.blue.shade800, fontSize: 16)),
              ),
              Divider(
                color: Colors.transparent,
                height: 15,
                thickness: 5,
                indent: 120,
                endIndent: 0,
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
              Divider(
                color: Colors.transparent,
                height: 40,
                thickness: 5,
                indent: 120,
                endIndent: 0,
              ),



              Align(
                alignment: Alignment.center, // Align however you like (i.e .centerRight, centerLeft)
                child: Text("Note",style: TextStyle(color: Colors.blue.shade800, fontSize: 16)),

              ),
              Divider(
                color: Colors.transparent,
                height: 15,
                thickness: 5,
                indent: 120,
                endIndent: 0,
              ),
              TextField(
                controller: Note,
                maxLines: 12,

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

          ],
        ),
      floatingActionButton: evento["Data Inizio"]!=null ? SpeedDial(
        // both default to 16
        marginRight: 18,
        marginBottom: 20,
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        // this is ignored if animatedIcon is non null
        // child: Icon(Icons.add),
        visible: true,
        // If true user is forced to close dial manually
        // by tapping main button and overlay is not rendered.
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        onOpen: () => print('OPENING DIAL'),
        onClose: () => print('DIAL CLOSED'),
        tooltip: 'Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
              child: Icon(Icons.delete),
              backgroundColor: Colors.red,
              label: 'Elimina',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () async {


                var unid=evento["Unid"];



                await ApiUtil().EliProme(context, unid);


              }
          ),

          SpeedDialChild(
            child: Icon(Icons.save),
            backgroundColor: Colors.green,
            label: 'Salva',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap:  () async {
              print(evento);
              var data=Datat.text;
              var oggetto=Oggetto.text;
              var note=Note.text;
              var cliente=Cliente.text;
              var clientecod=ClienteCod.text;
              var unid=evento["Unid"];

              var nuovo=widget.nuovo;

              await ApiUtil().SalvaProme(context,cliente,clientecod,oggetto,note,data,nuovo,unid);


            }  ,
          ),
        ],

      ) : SpeedDial(
        // both default to 16
        marginRight: 18,
        marginBottom: 20,
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        // this is ignored if animatedIcon is non null
        // child: Icon(Icons.add),
        visible: true,
        // If true user is forced to close dial manually
        // by tapping main button and overlay is not rendered.
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        onOpen: () => print('OPENING DIAL'),
        onClose: () => print('DIAL CLOSED'),
        tooltip: 'Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [


          SpeedDialChild(
            child: Icon(Icons.save),
            backgroundColor: Colors.green,
            label: 'Salva',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap:  () async {
              print(evento);
              var data=Datat.text;
              var oggetto=Oggetto.text;
              var note=Note.text;
              var cliente=Cliente.text;
              var clientecod=ClienteCod.text;
              var unid=evento["Unid"];

              var nuovo=widget.nuovo;

              await ApiUtil().SalvaProme(context,cliente,clientecod,oggetto,note,data,nuovo,unid);


            }  ,
          ),
        ],

      ) ,
    );
  }
}





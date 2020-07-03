import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:l1pro/contacts/LisCont.dart';

import '../ApiUtil.dart';

void main() => runApp(NCont());

class NCont extends StatelessWidget {
  final String nuovo;
  final String titolo;
  final String dati;
  final Nome = TextEditingController();
  final Cognome= TextEditingController();
  final Mail = TextEditingController();
  final Telefono = TextEditingController();
  final ID = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  NCont({Key key, @required this.nuovo,@required this.titolo,this.dati}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final appTitle = titolo;
    if(dati!="" && dati!=null){



      var Contatto=dati.toString().substring(1,dati.toString().length-1).split("***");
      print(Contatto);
      var fullname=Contatto[0].split(" ");
      var nome=fullname[0];
      var cognome=fullname[1];
      var id=Contatto[1];
      var email=Contatto[2];
      var telefono=Contatto[3];
      Nome.text=nome;
      Cognome.text=cognome;
      Mail.text=email;
      Telefono.text=telefono;
      ID.text=id;
    }
    else{}


    return MaterialApp(
      title: appTitle,
        debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue.shade800,
          leading: GestureDetector(
            onTap: () async{
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => ListCont()));

            },
            child: Icon(
              Icons.arrow_back,  // add custom icons also
            ),
          ),
          title: Text(appTitle),
        ),
        body:   Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[



          Divider(
          color: Colors.transparent,
            height: 15,
            thickness: 5,
            indent: 120,
            endIndent: 0,
          ),
          TextFormField(
              controller:Nome,
              decoration: new InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          labelText: "Nome",
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding:
          EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),

          hintText:"Nome"),
      validator: (value) {
        if (value.isEmpty) {
          return 'Inserire Nome';
        }
        return null;
      },

    ),
    Divider(
    color: Colors.transparent,
    height: 15,
    thickness: 5,
    indent: 120,
    endIndent: 0,
    ),
    TextFormField(
      controller:Cognome,
    decoration: new InputDecoration(
    labelText: "Cognome",
    prefixIcon: Icon(Icons.account_circle),
    border: InputBorder.none,
    focusedBorder: InputBorder.none,
    enabledBorder: InputBorder.none,
    errorBorder: InputBorder.none,
    disabledBorder: InputBorder.none,
    contentPadding:
    EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
    hintText:"Cognome"),
    validator: (value) {
    if (value.isEmpty) {
    return 'Inserire Cognome';
    }
    return null;
    },

    ),
    Divider(
    color: Colors.transparent,
    height: 15,
    thickness: 5,
    indent: 120,
    endIndent: 0,
    ),
    TextFormField(
      controller:Mail,
    decoration: new InputDecoration(
    prefixIcon: Icon(Icons.email),
    labelText: "Email",
    border: InputBorder.none,
    focusedBorder: InputBorder.none,
    enabledBorder: InputBorder.none,
    errorBorder: InputBorder.none,
    disabledBorder: InputBorder.none,
    contentPadding:
    EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
    hintText:"Email"),


    ),
    Divider(
    color: Colors.transparent,
    height: 15,
    thickness: 5,
    indent: 120,
    endIndent: 0,
    ),
    TextFormField(
      controller:Telefono,
    decoration: new InputDecoration(
    prefixIcon: Icon(Icons.phone),
    labelText: "Telefono",
    border: InputBorder.none,
    focusedBorder: InputBorder.none,
    enabledBorder: InputBorder.none,
    errorBorder: InputBorder.none,
    disabledBorder: InputBorder.none,
    contentPadding:
    EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
    hintText:"Telefono"),



    ),
    Divider(
    color: Colors.transparent,
    height: 15,
    thickness: 5,
    indent: 120,
    endIndent: 0,
    ),




    ],
    ),

    ),

        floatingActionButton: SpeedDial(
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
          children: nuovo=="NO" ? [
            SpeedDialChild(
                child: Icon(Icons.delete),
                backgroundColor: Colors.red,
                label: 'Elimina',
                labelStyle: TextStyle(fontSize: 18.0),

                onTap: () async {


                 await ApiUtil().EliCont(context,ID.text);

                }
            ),

            SpeedDialChild(
              child: Icon(Icons.save),
              backgroundColor: Colors.green,
              label: 'Salva',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap:  () async {

                if (_formKey.currentState.validate()) {
                  // If the form is valid, display a Snackbar.
                  var utente = await FirebaseAuth.instance.currentUser();
                  var uid = utente.uid;
                  var dat={"Nome":Nome.text,"Cognome":Cognome.text,"Email":Mail.text,"Telefono":Telefono.text,"Id":ID.text,"User":uid};

                  await ApiUtil().SalvaCont(nuovo,dat,context);

                  Scaffold.of(context)
                      .showSnackBar(SnackBar(
                      backgroundColor: Colors.green,
                      content: Text('CONTATTO SALVATO')));
                }

              }  ,
            ),
          ] : [


            SpeedDialChild(
              child: Icon(Icons.save),
              backgroundColor: Colors.green,
              label: 'Salva',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap:  () async {

                if (_formKey.currentState.validate()) {
                  // If the form is valid, display a Snackbar.
                  var utente = await FirebaseAuth.instance.currentUser();
                  var uid = utente.uid;
                  var dat={"Nome":Nome.text,"Cognome":Cognome.text,"Email":Mail.text,"Telefono":Telefono.text,"Id":ID.text,"User":uid};

                  await ApiUtil().SalvaCont(nuovo,dat,context);

                  Scaffold.of(context)
                      .showSnackBar(SnackBar(
                      backgroundColor: Colors.green,
                      content: Text('CONTATTO SALVATO')));
                }

              }  ,
            ),
          ],

        ),
      ),
    );
  }
}

// Create a Form widget.

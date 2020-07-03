import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:l1pro/contacts/LisCont.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'Home.dart';
import 'secondpage.dart';
import 'Evento.dart';
import 'push_nofitications.dart' as notif;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:l1pro/CercaCli.dart';
import 'contacts/CreCont.dart';
import 'package:timeago/timeago.dart' as timeago;

class ApiUtil {
  Widget _buildPageContent(BuildContext context2) {}

  ImProf() async {
    return "https://www.google.it/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png";
  }

  ImProf2() async {
    final prefs = await SharedPreferences.getInstance();
    var ute = prefs.getString("Username").toString().toUpperCase();
    final uri = prefs.getString("Server") +
        "/l1settin.nsf/utente.xsp/imgprof?Utente=" +
        ute;

    http.Response response = await http.get(
      uri,
      headers: {"DomAuthSessId": await prefs.getString("Token")},
    );
    ////print(response.headers);
    var stoken = response.headers['set-cookie'].toString();

    if (stoken != "" && stoken != null) {
      ////print("DATI CORRETTI REDIRECT ALLA HOME");
      print(jsonDecode(response.body)["out"].toString());
      return jsonDecode(response.body)["out"].toString();
    } else {
      //print("TOKEN SCADUTO O DATI NON VALIDI  TENTO ACCESSO");

      return prefs.getString("Server") + "/l1settin.nsf/usermob.png";
    }
  }

  UteLogout(context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    //print("ACCESSO NON RIUSCITO REDIRECT ALLA PAGINA DI LOGIN");
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Secondpage()));
  }

  Accedi(context) async {
    final prefs = await SharedPreferences.getInstance();
    var username = prefs.getString("Username");
    var password = prefs.getString("Password");
    var server = prefs.getString("Server");
    var azienda = prefs.getString("Azienda");

    final uri = server + '/names.nsf?Login';
    var map = new Map<String, dynamic>();

    map['username'] = username;
    map['password'] = password;
    http.Response response = await http.post(
      uri,
      body: map,
    );

    var stoken = response.headers['set-cookie'].toString();
    if (stoken != "" && stoken != null) {
      var token =
          stoken.substring(stoken.indexOf("=") + 1, stoken.indexOf(";"));
      final prefs = await SharedPreferences.getInstance();
      var now = new DateTime.now();
      prefs.setString("Token", token);
      prefs.setString("DToken", now.toString());
      //print("ACCESO RIUSCITO IL TOKEN SCADRA TRA 30 MINUTI");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => CalendarScreen()));
    } else {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.clear();
      //print("ACCESSO NON RIUSCITO REDIRECT ALLA PAGINA DI LOGIN");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Secondpage()));
    }
  }

  Controllo(context) async {
    final prefs = await SharedPreferences.getInstance();
    final uri = prefs.getString("Server") + "/l1settin.nsf/utente.xsp/dati2";

    http.Response response = await http.get(
      uri,
      headers: {"DomAuthSessId": await prefs.getString("Token")},
    );
    ////print(response.headers);
    var stoken = response.headers['set-cookie'].toString();
    if (stoken != "" && stoken != null) {
      ////print("DATI CORRETTI REDIRECT ALLA HOME");

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => CalendarScreen()));
    } else {
      //print("TOKEN SCADUTO O DATI NON VALIDI  TENTO ACCESSO");

      await ApiUtil().Accedi(context);
    }
  }

  CKLogin(context) async {
    final prefs = await SharedPreferences.getInstance();
    var username = prefs.getString("Username");
    var password = prefs.getString("Password");
    var server = prefs.getString("Server");
    var azienda = prefs.getString("Azienda");

    final uri = server + '/names.nsf?Login';
    var map = new Map<String, dynamic>();

    map['username'] = username;
    map['password'] = password;
    http.Response response = await http.post(
      uri,
      body: map,
    );

    var stoken = response.headers['set-cookie'].toString();
    if (stoken != "" && stoken != null) {
      var token =
          stoken.substring(stoken.indexOf("=") + 1, stoken.indexOf(";"));
      final prefs = await SharedPreferences.getInstance();
      var now = new DateTime.now();
      prefs.setString("Token", token);
      prefs.setString("DToken", now.toString());
      //print("ACCESO RIUSCITO IL TOKEN SCADRA TRA 30 MINUTI");
    } else {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.clear();
      //print("ACCESSO NON RIUSCITO REDIRECT ALLA PAGINA DI LOGIN");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Secondpage()));
    }
  }

  CKLoggato(context) async {
    final prefs = await SharedPreferences.getInstance();
    final uri = prefs.getString("Server") +
        "/" +
        prefs.getString("Azienda") +
        "/crm.nsf/Promemoria.xsp/cale";
    var tokenute = await prefs.getString("Token");
    http.Response response = await http.get(
      uri,
      headers: {
        "DomAuthSessId": tokenute,
        "cookie": "DomAuthSessId=" + tokenute
      },
    );

    //var resp = jsonDecode(response.body.toString());
    print(response.headers);
    var stoken = response.headers['set-cookie'].toString();
    if (stoken != "" && stoken != null) {
      // await prefs.setString("Token",resp["Dati"]);
    } else {
      //print("TOKEN SCADUTO O DATI NON VALIDI  TENTO ACCESSO");

      await ApiUtil().CKLogin(context);
    }
  }

  CaricaEventi(context) async {
    var utente = await FirebaseAuth.instance.currentUser();
    var uid = utente.uid;
    //prefs.setString('events',response.body);
    var _events = {};
    //print(response.body);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('events');

    var insta = Firestore.instance;

    var eve = insta
        .collection("Eventi")
        .where('User', isEqualTo: uid)
        .getDocuments()
        .then((querySnapshot) {
      querySnapshot.documents.forEach((result) {
        var obj = result.data;
        print(obj);
        Timestamp timestamp = obj["Data Inizio"];

        var dat = timestamp.toDate().toString();
        var data = dat.substring(0, dat.indexOf(" ")).replaceAll("-", "/");
        obj["Data"] = dat;
        print(data);

        if (_events[data] != null) {
          _events[data].add(obj);
        } else {
          _events[data] = [obj];
        }
      });
    });

    prefs.setString('events', json.encode(_events));
  }

  CaricaEv() async {
    var utente = await FirebaseAuth.instance.currentUser();
    var uid = utente.uid;
    //prefs.setString('events',response.body);
    var _events = {};
    //print(response.body);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('events');

    var insta = Firestore.instance;

    var eve = insta
        .collection("Eventi")
        .where('User', isEqualTo: uid)
        .getDocuments()
        .then((querySnapshot) {
      querySnapshot.documents.forEach((result) {
        var obj = result.data;
        var unid=result.documentID;
        print(obj);
        var dat = obj["Data Inizio"].toString();
        obj["Data"] = dat.substring(0, 10);
        var data = obj["Data"];
        obj["Unid"]=unid;
        if (_events[data] != null) {
          _events[data].add(obj);
        } else {
          _events[data] = [obj];
        }
      });
      prefs.setString('events', json.encode(_events));
    });
  }

  PrimoAvvio(context) async {
    final prefs = await SharedPreferences.getInstance();
    final uri = prefs.getString("Server") +
        "/" +
        prefs.getString("Azienda") +
        "/crm.nsf/Promemoria.xsp/cale";
    var tokenute = await prefs.getString("Token");
    http.Response response = await http.get(
      uri,
      headers: {
        "DomAuthSessId": tokenute,
        "cookie": "DomAuthSessId=" + tokenute
      },
    );

    var stoken = response.headers['set-cookie'];
    if (stoken != "" && stoken != null) {
      //print("DATI CORRETTI REDIRECT ALLA HOME");
      await CaricaEventi(context);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => CalendarScreen()));
    } else {
      //print("TOKEN SCADUTO O DATI NON VALIDI  TENTO ACCESSO");

      await ApiUtil().Accedi(context);
      await PrimoAvvio(context);
    }
  }

  SalvaProme(context, cliente,clientecod, oggetto, note, data, nuovo, unid) async {
    print(data);
    var utente = await FirebaseAuth.instance.currentUser();
    var uid = utente.uid;
    var insta = Firestore.instance;
    if (data == null || data == "") {
      Fluttertoast.showToast(
          msg: "INSERIRE DATA EVENTO",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red.shade800,
          textColor: Colors.white,
          fontSize: 15.0);
    } else {
      final prefs = await SharedPreferences.getInstance();
      var luogo = "";
      var fined = data;
      var inid = data;
      var utente = await FirebaseAuth.instance.currentUser();
      var uid = utente.uid;
      var insta = Firestore.instance;
      if (nuovo == "NO") {



        insta.collection("Eventi")
            .document(unid)
            .updateData({"Contatto":clientecod,
          "Contatto Descr": cliente,
          "Data Fine": data,
          "Data Inizio": data,
          "Descrizione": note,
          "Oggetto": oggetto,
          "User": uid,
          }).then((value) async {
          await CaricaEv();
            Navigator.pushReplacement(

            context, MaterialPageRoute(builder: (context) => CalendarScreen()));});

      }


       else {
        insta.collection("Eventi").add({
          "Contatto":clientecod,
          "Contatto Descr": cliente,
          "Data Fine": data,
          "Data Inizio": data,
          "Descrizione": note,
          "Oggetto": oggetto,
          "User": uid,

        }).then((value) async {
          await CaricaEv();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => CalendarScreen()));
        });
      }

  }}

  EliProme(context, unid) async {

    var utente = await FirebaseAuth.instance.currentUser();
    var uid = utente.uid;
    var insta = Firestore.instance;
await CaricaEv();


      insta.collection("Eventi")
          .document(unid).delete().then((value){ Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => CalendarScreen()));});

  }



  EliCont(context, unid) async {

    var utente = await FirebaseAuth.instance.currentUser();
    var uid = utente.uid;
    var insta = Firestore.instance;
    await CaricaEv();


    insta.collection("Contatti")
        .document(unid).delete().then((value){ Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => ListCont()));});

  }
  ElenCli() async {

    var utente = await FirebaseAuth.instance.currentUser();
    var uid = utente.uid;
    //prefs.setString('events',response.body);
    var _events = {};
    //print(response.body);


    var insta = Firestore.instance;

    var eve = insta
        .collection("Contatti")
        .where('User', isEqualTo: uid)
        .getDocuments()
        .then((querySnapshot) {
      return querySnapshot.documents;
        });

  }

  EContattoBack(context) async {
  await CaricaEv();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => CalendarScreen()));
  }

  ClienteBack(context) async {
    final prefs = await SharedPreferences.getInstance();
    var evento = await prefs.getString("BKEvento");

    var val = await jsonDecode(evento);
    var tmp = await jsonEncode(val);
    var nuovov = await prefs.getString("BKEventoN");
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MyHomePage(
                  text: tmp,
                  nuovo: nuovov,
                )));
  }

  ClienteSelez(context, user) async {
    final prefs = await SharedPreferences.getInstance();
    var evento = await prefs.getString("BKEvento");

    var val = await jsonDecode(evento);
    var arr = user.toString().split("***");
    val["Contatto"] = arr[1];
    val["Contatto Descr"] = arr[0];
    print(arr[1]);
    var tmp = await jsonEncode(val);
    var nuovov = await prefs.getString("BKEventoN");
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MyHomePage(
                  text: tmp,
                  nuovo: nuovov,
                )));
  }

  LeggiKey(keyy) async {
    final prefs = await SharedPreferences.getInstance();
    var val = await prefs.getString(keyy).toString();
    return val;
  }

  ApriEvento(item, context, nuovo) async {
    //final prefs = await SharedPreferences.getInstance();
    //await prefs.setString("EvSel",jsonEncode(item));

    if (nuovo == "NO") {
      var out = jsonEncode(item);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MyHomePage(
                    text: out,
                    nuovo: "NO",
                  )));
    } else {
      var it = {
        "Data": "",
        "Oggetto": "",
        "Descrizione": "",
        "Contatto Descr": "",
        "Contatto": "",

      };
      var out = jsonEncode(it);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MyHomePage(
                    text: out,
                    nuovo: "SI",
                  )));
    }
  }

  LeggiEvento() async {
    final prefs = await SharedPreferences.getInstance();
    var val = await prefs.getString("EvSel");
    var out = await jsonDecode(val);

    return out;
  }

  ApriCont(context,datip) async{


    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => NCont(nuovo: "NO",titolo: "Nuovo Contatto",dati: jsonEncode(datip),)));

  }



 ApriNCont(context) async{


    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => NCont(nuovo: "SI",titolo: "Nuovo Contatto",)));

  }


  SalvaCont(nuovo,dati,context) async{

    var insta = Firestore.instance;

    if (nuovo == "NO") {


      insta.collection("Contatti")
          .document(dati["Id"])
          .updateData(dati).then((value) async {
        await CaricaEv();
        Navigator.pushReplacement(

            context, MaterialPageRoute(builder: (context) => ListCont()));});

    }


    else {
      insta.collection("Contatti").add(dati).then((value) async {
        await CaricaEv();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ListCont()));
      });
    }

  }

  BackEvento(context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("EvSel");
    await prefs.remove("BKEvento");
    await prefs.remove("BKEventoN");
    await ApiUtil().CaricaEv();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => CalendarScreen()));
  }

  ApriCercaCli(context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MyApp3()));
  }
}

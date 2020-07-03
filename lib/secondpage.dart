import 'dart:developer';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:l1pro/ApiUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'Home.dart';
import "package:cloud_firestore/cloud_firestore.dart";


import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class Secondpage extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Secondpage>  {
  String _scanBarcode = 'Unknown';
  TextEditingController Username = TextEditingController();
  TextEditingController Password = TextEditingController();
  TextEditingController Server = TextEditingController();
  TextEditingController Azienda = TextEditingController();

  @override
  void initState() {
    super.initState();
  }


  startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
        "#ff6666", "Cancel", true, ScanMode.BARCODE)
        .listen((barcode) => setCampi(barcode));

  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Annulla", true, ScanMode.QR);
      print(barcodeScanRes);
      setCampi(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
      Fluttertoast.showToast(
          msg: "IMPOSSIBILE EFFETTUARE SCANSIONE SU QUESTO DISPOSITIVO",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;

    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);

      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';

    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  setCampi(barcode) async {
    var arr=barcode.toString().split(",");
    Username.text=arr[0];
    Password.text=arr[1];
    Server.text=arr[2];
    Azienda.text=arr[3];


    final prefs = await SharedPreferences.getInstance();
    var username = arr[0];
    var password = arr[1];
    var server = arr[2];
    var azienda =arr[3];

   await _save();

  }
  _save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("Username", Username.text);
    prefs.setString("Password", Password.text);
    prefs.setString("Server", Server.text);
    prefs.setString("Azienda", Azienda.text);

    Accedi(Username.text, Password.text, Server.text, Azienda.text).then((_) async {
      Fluttertoast.showToast(
          msg: "ACCESSO RIUSCITO",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      await ApiUtil().CaricaEventi(context);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => CalendarScreen()));

    }).catchError((_) {
      Fluttertoast.showToast(
          msg: "ACCESSO FALLITO CONTROLLA I DATI INSERITI",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }

  Accedi(username, password, server, azienda) async {
    final uri = server + '/names.nsf?Login';
    var map = new Map<String, dynamic>();
    map['username'] = username;
    map['password'] = password;

    http.Response response = await http.post(
      uri,
      body: map,
    );
    print(response.statusCode);

    var stoken = response.headers['set-cookie'].toString();
    if (stoken != "" && stoken != null) {
      var token =
      stoken.substring(stoken.indexOf("=") + 1, stoken.indexOf(";"));
      final prefs = await SharedPreferences.getInstance();
      var now = new DateTime.now();
      prefs.setString("Token", token);
      prefs.setString("DToken", now.toString());

      print("ACCESO RIUSCITO IL TOKEN SCADRA TRA 30 MINUTI");
    } else {
      Fluttertoast.showToast(
          msg: "ACCESSO FALLITO CONTROLLA I DATI INSERITI",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      print("ERRORE");
    }
  }

  Widget _buildPageContent(BuildContext context) {




    Future <List<Map<dynamic, dynamic>>> getCollection() async{
      List<DocumentSnapshot> templist;
      List<Map<dynamic, dynamic>> list = new List();
      CollectionReference collectionRef = Firestore.instance.collection("Eventi");
      QuerySnapshot collectionSnapshot = await collectionRef.getDocuments();

      templist = collectionSnapshot.documents; // <--- ERROR

      list = templist.map((DocumentSnapshot docSnapshot){
        return docSnapshot.data;
      }).toList();
      print(list);
      return list;
    }
    getCollection();

    return Container(
      padding: EdgeInsets.all(20.0),
      color: Colors.blue.shade800,
      child: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Container(
                width: 200,
                child: Icon(
                  Icons.whatshot,
                  size: 100.0,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              ListTile(
                  title: TextField(
                    controller: Username,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        hintText: "Username:",
                        hintStyle: TextStyle(color: Colors.white70),
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.account_circle,
                          color: Colors.white30,
                        )),
                  )),
              Divider(
                color: Colors.greenAccent,
              ),
              ListTile(
                  title: TextField(
                    controller: Password,
                    obscureText: true,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        hintText: "Password:",
                        hintStyle: TextStyle(color: Colors.white70),
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.lock,
                          color: Colors.white30,
                        )),
                  )),
              Divider(
                color: Colors.greenAccent,
              ),
              ListTile(
                  title: TextField(
                    controller: Server,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        hintText: "Server:",
                        hintStyle: TextStyle(color: Colors.white70),
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.dns,
                          color: Colors.white30,
                        )),
                  )),
              Divider(
                color: Colors.greenAccent,
              ),
              ListTile(
                  title: TextField(
                    controller: Azienda,
                    obscureText: false,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        hintText: "Azienda:",
                        hintStyle: TextStyle(color: Colors.white70),
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.business_center,
                          color: Colors.white30,
                        )),
                  )),
              Divider(
                color: Colors.greenAccent,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      onPressed: () {
                        _save();
                        /* Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) => Home()
                        ));*/
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      color: Colors.green,
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white70, fontSize: 16.0),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              InkWell(
                child: Text("Scansiona Codice QR",
                    style: TextStyle(color: Colors.grey.shade500)),
                onTap: () async {

              await scanQR();// startBarcodeScanStream();

                },

              )
            ],
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPageContent(context),
    );
  }


}


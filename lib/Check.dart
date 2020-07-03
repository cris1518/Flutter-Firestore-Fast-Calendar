// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'Home.dart';
import 'secondpage.dart';
import 'push_nofitications.dart' as notif;
import 'package:flutter/material.dart';
import "package:l1pro/ApiUtil.dart";

class CheckApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


   Avvio() async {
      await ApiUtil().CaricaEv();
      var utente = await FirebaseAuth.instance.currentUser();
      var uid = utente.uid;
      var unome=utente.displayName;
      var insta = Firestore.instance;

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => CalendarScreen()));
    }

    Avvio();

    return Container(
      padding: EdgeInsets.all(20.0),
      color: Colors.white,
      child: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Divider(
                color: Colors.transparent,
                height: 150,
                thickness: 5,
                indent: 120,
                endIndent: 0,
              ),
              Image.asset('images/lg.png',  height:200,),
              Divider(
                color: Colors.transparent,
                height: 15,
                thickness: 5,
                indent: 120,
                endIndent: 0,
              ),
            
            ],
          ),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}

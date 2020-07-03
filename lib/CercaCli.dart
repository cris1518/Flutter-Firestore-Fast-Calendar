import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:l1pro/ApiUtil.dart';
class MyApp3 extends StatefulWidget {
 MyApp3({ Key key }) : super(key: key);
  @override
  _SearchListState createState() => new _SearchListState();

}

class _SearchListState extends State<MyApp3>
{
  Widget appBarTitle = new Text("Seleziona Cliente", style: new TextStyle(color: Colors.white),);
  Icon actionIcon = new Icon(Icons.search, color: Colors.white,);
  final key = new GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = new TextEditingController();
  List<String> _list;
  List<String> _list2;
  bool _IsSearching;
  String _searchText = "";
  String _cli="";
  _SearchListState() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _IsSearching = false;
          _searchText = "";
        });
      }
      else {
        setState(() {
          _IsSearching = true;
          _searchText = _searchQuery.text;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _IsSearching = false;

     init();
    CaricaCli();
  }

  CaricaCli() async {
    var response=await ApiUtil().ElenCli();

   _list = List();



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
      querySnapshot.documents.forEach((result) {

        var item=result.data;
        print(item);
        _list.add(item["Nome"]+" "+item["Cognome"]+"***"+item["Codice"].toString());
      });
      setState(() {

        _cli="SI";

      });

        });









  }

   init() {
    _list = List();


   }

  @override
  Widget build(BuildContext context) {


 return new Scaffold(
   backgroundColor: Colors.white,
  key: key,
  appBar: buildBar(context),
  body: _cli=="SI" ? new ListView(
    padding: new EdgeInsets.symmetric(vertical: 8.0),
    children: _IsSearching ? _buildSearchList() : _buildList(),
  ) : new ListView(),
);




  }

  List<ChildItem> _buildList() {

    return _list.map((contact) => new ChildItem(contact)).toList();
  }

  List<ChildItem> _buildSearchList() {
    if (_searchText.isEmpty) {
      return _list.map((contact) => new ChildItem(contact))
          .toList();
    }
    else {
      List<String> _searchList = List();
      for (int i = 0; i < _list.length; i++) {
        String  name = _list.elementAt(i);
        if (name.toLowerCase().contains(_searchText.toLowerCase())) {
          _searchList.add(name);
        }
      }
      return _searchList.map((contact) => new ChildItem(contact))
          .toList();
    }
  }

  Widget buildBar(BuildContext context) {
    return new AppBar(

        centerTitle: true,
        title: appBarTitle,
        backgroundColor: Colors.blue.shade800,
        leading: GestureDetector(
          onTap: () async{  await  ApiUtil().ClienteBack(context) ; },
          child: Icon(
            Icons.arrow_back,  // add custom icons also
          ),
        ),
        actions: <Widget>[
          new IconButton(icon: actionIcon, onPressed: () {
            setState(() {
              if (this.actionIcon.icon == Icons.search) {
                this.actionIcon = new Icon(Icons.close, color: Colors.white,);
                this.appBarTitle = new TextField(
                  controller: _searchQuery,
                  style: new TextStyle(
                    color: Colors.white,

                  ),
                  decoration: new InputDecoration(
                      prefixIcon: new Icon(Icons.search, color: Colors.white),
                      hintText: "Cerca...",
                      hintStyle: new TextStyle(color: Colors.white)
                  ),
                );
                _handleSearchStart();
              }
              else {
                _handleSearchEnd();
              }
            });
          },),
        ]
    );
  }

  void _handleSearchStart() {
    setState(() {
      _IsSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.actionIcon = new Icon(Icons.search, color: Colors.white,);
      this.appBarTitle =
      new Text("Seleziona Cliente", style: new TextStyle(color: Colors.white),);
      _IsSearching = false;
      _searchQuery.clear();
    });
  }

}

class ChildItem extends StatelessWidget {
  final String name;
  ChildItem(this.name);
  @override
  Widget build(BuildContext context) {
    return new ListTile(
        title: new Text(this.name.substring(0,this.name.indexOf("***"))),
      onTap: ()async{
        await ApiUtil().ClienteSelez(context,this.name);
      },
    );
  }

}
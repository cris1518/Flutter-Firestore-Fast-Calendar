import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:l1pro/ApiUtil.dart';

class ListViewJsonapi extends StatefulWidget {
  _ListViewJsonapiState createState() => _ListViewJsonapiState();
}

class _ListViewJsonapiState extends State<ListViewJsonapi> {


  Future<List<Users>> _fetchUsers() async {
    var response = await ApiUtil().ElenCli();


      final items = response.cast<Map<String, dynamic>>();
      List<Users> listOfUsers = items.map<Users>((json) {
        return Users.fromJson(json);
      }).toList();

      return listOfUsers;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        leading: GestureDetector(
          onTap: () async{   await  ApiUtil().ClienteBack(context);},
          child: Icon(
            Icons.arrow_back,  // add custom icons also
          ),
        ),

          backgroundColor: Colors.blue.shade800,
        title: Text('Seleziona Cliente'),
      ),
      body: FutureBuilder<List<Users>>(
        future: _fetchUsers(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          return ListView(
            children: snapshot.data
                .map((user) => ListTile(
              title: Text(user.name),
              onTap: ()async{
                await ApiUtil().ClienteSelez(context,user);
              },

              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade800,
                child: Text(user.name[0],
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    )),
              ),
            ))
                .toList(),
          );
        },
      ),
    );
  }
}

class Users {

  String name;
  int codice;



  Users({

    this.name,
    this.codice,



  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(

      name: json['Nome']+" "+json['Cognome'],
      codice: json['Codice'],

    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Check.dart';
import 'login-register.dart';
import 'ApiUtil.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

final FirebaseAuth auth = FirebaseAuth.instance;


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'GO',
      debugShowCheckedModeBanner: false,

      home: new StreamBuilder(
        stream: auth.onAuthStateChanged,
        builder: (context, snapshot)   {
          if (snapshot.hasData) {

            return CheckApp();
          }
          return LoginRegister();
        },
      ),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => new CheckApp(),
        '/login': (BuildContext context) => new LoginRegister()
      },
    );
  }
}

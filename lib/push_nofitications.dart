import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
 
class PushNotificationsManager {

  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance = PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure( onMessage: (Map<String, dynamic> message) async {

        // actions
      },);

      // For testing purposes print the Firebase Messaging token
      String token = await _firebaseMessaging.getToken();
      var prefs = await SharedPreferences.getInstance();
      prefs.setString("NToken",token);



      var utente = await FirebaseAuth.instance.currentUser();
      var uid = utente.uid;
      var insta = Firestore.instance;

      await insta
          .collection("Notifiche")
          .where('User', isEqualTo: uid)
          .getDocuments()
          .then((querySnapshot) async {
        if( querySnapshot.documents.length>0){
          querySnapshot.documents.forEach((result) async {
            var id=result.documentID;
            await  insta.collection("Notifiche")
                .document(id).updateData({"User":uid,"Token":token});

          });
        }
        else{

          await insta
              .collection("Notifiche")
              .where('User', isEqualTo: uid)
              .getDocuments()
              .then((querySnapshot) async {
            if( querySnapshot.documents.length>0){
              querySnapshot.documents.forEach((result) async {
                var id=result.documentID;
                await  insta.collection("Notifiche")
                    .document(id).updateData({"User":uid,"Token":token});

              });
            }
            else{

              await insta.collection("Notifiche").add({"User":uid,"Token":token});
            }

          });


        }});





      //var utente= await prefs.getString("Username").replaceAll(" ","%20");
      //final uri = prefs.getString("Server")+"/l1settin.nsf/utente.xsp/FBaseToken?Utente="+utente+"&Token="+token;

     // http.Response response = await http.get(
       // uri,
        //headers: {"DomAuthSessId":await prefs.getString("Token")}

      //);



      _initialized = true;
    }
  }



}
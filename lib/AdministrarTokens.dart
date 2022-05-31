import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> saveTokenToDatabase(String token) async {
  // Assume user is logged in for this example
  String? userId = FirebaseAuth.instance.currentUser?.uid;

  DocumentReference docRefUsuario =  FirebaseFirestore.instance.collection('usuarios').doc(userId);
  await docRefUsuario.get().then( (value) => {
        if(value.exists){
            docRefUsuario.update({
              'tokens': FieldValue.arrayUnion([token])
            })
          }else{
          docRefUsuario.set({
            'tokens': FieldValue.arrayUnion([token])
          })
        }
  });


}

class Token {
  // Get the token each time the application loads
  static guardarToken() async {
    String? token = await FirebaseMessaging.instance.getToken();

    // Save the initial token to the database
    await saveTokenToDatabase(token.toString());

    // Any time the token refreshes, store this in the database too.
    FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
  }
}

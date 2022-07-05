import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../splashScreen.dart';

class AdminCuenta {
  static Widget getPerfilTutorado(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) => {
                GoogleSignIn().disconnect(),
                Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context) => splashScreen()))
                
              });
            },
            child: Text("Cerrar sesión"))
      ],
    );
  }
}

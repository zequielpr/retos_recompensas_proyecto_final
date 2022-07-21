import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../splashScreen.dart';

class AdminCuenta {
  static Widget getPerfilTutorado(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
            onPressed: () async {
              //print(FirebaseAuth.instance.currentUser?.providerData);


              await FirebaseAuth.instance.signOut().then((value) async => {

                 await _p(),
                    Navigator.pushReplacementNamed(context, '/')


                  });


            },
            child: Text("Cerrar sesión"))
      ],
    );
  }

  static Future<void> _p() async {
    try{
      await GoogleSignIn().disconnect();
    }catch(e){}
  }
}

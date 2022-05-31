import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'main.dart';

class Autenticar{

  //Metodo para iniciar sesion con google
  static Future<User?>  signInWithGoogle(BuildContext context) async {
    FirebaseAuth autenticador = FirebaseAuth.instance;
    User? user;

    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser
        ?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    try {
      UserCredential userCredential = await autenticador.signInWithCredential(
          credential);

      user = userCredential.user;

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => Inicio()));


      return user;
    } on FirebaseAuthException catch (e) {
      print("Error en la autenticación");
    }
  }
}
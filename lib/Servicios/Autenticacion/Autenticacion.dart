import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../main.dart';

class Autenticar{

  //Metodo para iniciar sesion con google
  static Future<dynamic>  signInWithGoogle(BuildContext context, AuthCredential credential) async {
    FirebaseAuth autenticador = FirebaseAuth.instance;
    User? user;


    // Trigger the authentication flow
    /*
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser
        ?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );*/

    try {
      UserCredential userCredential = await autenticador.signInWithCredential(
          credential);

      user = userCredential.user;

      //Si el usuario no es nulo, se verifica si es nuevo o no, en el caso contrario, se le asignará null a la variable
      var isNewUser = user != null ? userCredential.additionalUserInfo?.isNewUser : null;

      return isNewUser;

    } on FirebaseAuthException catch (e) {
      return null;
      print("Error en la autenticación");
    }
  }



  //Metodo para comprobar que el nombre de usuario sea válido
  //Comprobar nombre de usuario:
  static Future<bool> comprUserName(String userName, CollectionReference collectionReferenceUsers) async {
    bool userNameValido = false;

    await collectionReferenceUsers
        .where("nombre_usuario", isEqualTo: userName)
        .get()
        .then((value) => {
      if (value.docs.isEmpty)
        {
          print("nombre de usuario disponible"),
          userNameValido = true,
        }
      else
        {print("Nombre de usuario no disponible"), userName = ""}
    });

    return userNameValido;
  }



}
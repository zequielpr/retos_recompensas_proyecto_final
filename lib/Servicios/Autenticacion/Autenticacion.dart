import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../main.dart';
import '../Notificaciones/AdministrarTokens.dart';
import 'DatosNewUser.dart';

class Autenticar{

  //Metodo para iniciar sesion con google
  static Future<dynamic>  signInWithGoogle(BuildContext context, AuthCredential credential) async {
    print("Se intenta acceder con google");
    FirebaseAuth autenticador = FirebaseAuth.instance;
    User? user;


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




  //Acciones que suceden al pulsar el boton iniciar con google
  static Future<void> continuarConGoogle(CollectionReference collecUsuarios, BuildContext context) async {
    {
      FirebaseAuth aut = FirebaseAuth.instance;
      //Obtiene las credenciales ofrecidas por google
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      print("Registrar");
      // Obtain the auth details from the request
      GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

      // Create a new credential
      var credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      //Regitra el usuario en la app y devuelve si es nuevo o no
      var isNewUser =
      await Autenticar.signInWithGoogle(context, credential);


      if (isNewUser) {
        await GoogleSignIn().disconnect();
        aut.currentUser?.delete();
        Navigator.push(context, MaterialPageRoute(
            builder: (BuildContext context) => Roll(credential, collecUsuarios)));


      } else if (!isNewUser) {
        print("El usuario no es nuevo");
        Token.guardarToken();
        //El usuario accede su cuenta con las vista correspendiente al roll preestablecido.
        DocumentReference docUser = collecUsuarios
            .doc(FirebaseAuth.instance.currentUser?.uid);
        await docUser.get().then((value) => {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      Inicio(value['rol_tutorado'])))
        });
      } else {
        print(
            "A ocurrido un error, no ha sido posible obtener el usuario con las credenciales especificadas por google");
      }
    }
  }



}
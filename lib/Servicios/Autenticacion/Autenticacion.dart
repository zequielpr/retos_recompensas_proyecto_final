import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:retos_proyecto/datos/TransferirDatos.dart';

import '../../main.dart';
import '../Notificaciones/AdministrarTokens.dart';
import 'DatosNewUser.dart';
import 'login.dart';

class Autenticar {
  static FirebaseAuth aut = FirebaseAuth.instance;
  static User? currentUser = aut.currentUser;

  //Metodo para iniciar sesion con google
  static Future<dynamic> obtenerCredencialesGoogle() async {
    //Ofrece el panel para que esl usuario elija la cuenta con la que desea registrarse.
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    //Si el usuario no selecciona un usuario, retorna null
    if (googleUser == null) {
      return null;
    }

    //Obtiene el autenticador
    GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

    ////Crea una credencial con el token de acceso facilitado por facebook
    var credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return credential;
  }

  //Metodo para comprobar que el nombre de usuario sea válido
  //Comprobar nombre de usuario:
  static Future<bool> comprUserName(
      String userName, CollectionReference collectionReferenceUsers) async {
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

  //Comprueba si el usuario es nuevo o viejo
  static Future<void> comprobarNewOrOld(
      CollectionReference collecUsuarios,
      BuildContext context,
      var isNewUser,
      OAuthCredential? credential,
      String metodoDeInicio) async {
    {
      if (isNewUser) {
        var credentialColecUsers =
            TranferirDatosRoll(credential, collecUsuarios);
        await GoogleSignIn().disconnect().whenComplete(() async => {
              await aut.currentUser?.delete().whenComplete(() => {
                    Navigator.pushNamed(context, Roll.routeName,
                        arguments: credentialColecUsers),
                  })
            });
      } else if (!isNewUser) {
        print("El usuario no es nuevo");
        Token.guardarToken();
        //El usuario accede su cuenta con las vista correspendiente al roll preestablecido.
        DocumentReference docUser =
            collecUsuarios.doc(FirebaseAuth.instance.currentUser?.uid);
        await docUser.get().then((value) => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          Inicio(value['rol_tutorado'])))
            });
      } else {
        print(
            "A ocurrido un error, no ha sido posible obtener el usuario con las credenciales ofrecidas por " +
                metodoDeInicio);
      }
    }
  }

  static Future<OAuthCredential?> obtenerCredencialesFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      //devuelve una credencial creada con el token de acceso facilitado por facebook
      return FacebookAuthProvider.credential(result.accessToken!.token);
    }
  }

  static Future<UserCredential?> iniciarSesion(
      OAuthCredential credential) async {
    try {
      return await aut.signInWithCredential(credential);
    } catch (e) {}
  }
}

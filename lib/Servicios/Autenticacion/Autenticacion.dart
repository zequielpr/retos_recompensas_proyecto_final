import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:retos_proyecto/Rutas.gr.dart';
import 'package:retos_proyecto/datos/Colecciones.dart';
import 'package:retos_proyecto/datos/TransferirDatos.dart';

import '../../datos/Roll_Data.dart';
import '../../datos/UsuarioActual.dart';
import '../../MenuNavigatioBar/menu.dart';
import '../Notificaciones/AdministrarTokens.dart';
import 'DatosNewUser.dart';
import 'login.dart';

class Autenticar {
  static FirebaseAuth aut = FirebaseAuth.instance;
  static User? currentUser = aut.currentUser;

  //Obtener cuenta de google
  static Future<GoogleSignInAccount?> getGoogleAcount() async {
    return await GoogleSignIn().signIn();
  }

  //Metodo para iniciar sesion con google
  static Future<dynamic> obtenerCredencialesGoogle(
      GoogleSignInAccount? googleUser) async {
    //Obtiene el autenticador
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    ////Crea una credencial con el token de acceso
    var credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return credential;
  }

  //Metodo para comprobar que el nombre de usuario sea válido
  //Comprobar nombre de usuario:
  static Future<bool> comprUserName(String userName) async {
    bool userNameValido = false;

    await Coleciones.COLECCION_USUARIOS
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
  static Future<void> newOrOld(BuildContext context, var isNewUser,
      OAuthCredential? credential, String metodoDeInicio) async {
    {
      if (isNewUser) {
        //Si el usuario es de facebook se elimina, ya que para comprobar si es nuevo o no, es necesario registrarlo previamente

        var credentialColecUsers = TranferirDatosRoll(credential);

        await GoogleSignIn().disconnect().whenComplete(() async =>
            {context.router.push(RollRouter(args: credentialColecUsers))});
      } else if (!isNewUser) {
        late DocumentReference docUser;
        await iniciarSesion(credential!).then((userCredential) async => {
              Token.guardarToken(),
              //El usuario accede su cuenta con las vista correspendiente al rol preestablecido.
              docUser =
                  Coleciones.COLECCION_USUARIOS.doc(userCredential?.user?.uid),
              await docUser.get().then((snap) => {
                    //Dirigirse a la pantalla principal
                    context.router.replace(MainRouter())
                  })
            });
      } else {
        print(
            "A ocurrido un error, no ha sido posible obtener el usuario con las credenciales ofrecidas por " +
                metodoDeInicio);
      }
    }
  }

  static Future<dynamic> obtenerCredencialesFacebook() async {
    final LoginResult result = await FacebookAuth.instance
        .login(permissions: ['email', 'public_profile']);

    if (result.status == LoginStatus.success) {
      //devuelve una credencial creada con el token de acceso facilitado por facebook
      return FacebookAuthProvider.credential(result.accessToken!.token);
    }
    print('holaaa');
    return null;
  }

  static Future<UserCredential?> iniciarSesion(
      OAuthCredential credential) async {
    try {
      return await aut.signInWithCredential(credential);
    } catch (e) {}
  }

  static Future<UserCredential?> registrarConEmailPassw(
      Map<String, String> emialPasswd) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emialPasswd['email'] as String,
        password: emialPasswd['passw'] as String,
      );

      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<String> inciarSesionEmailPasswd(String email, String password,
      CollectionReference collectionReferenceUser, BuildContext context) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      if (credential.user?.emailVerified == false) {
        return 'env'; //Email no verificado
      }

      CurrentUser.setCurrentUser();
      DocumentReference docUser = Coleciones.COLECCION_USUARIOS.doc(CurrentUser.getIdCurrentUser());
      await docUser.get().then((value) {
        Roll_Data.ROLL_USER_IS_TUTORADO = value['rol_tutorado'];
        context.router.replace(MainRouter());
      });

      return 's'; //Succeful
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'u';
      } else if (e.code == 'wrong-password') {
        return 'p';
      } else {
        return 'ed'; //Error desconocido
      }
    }
  }

  //Comprobar si el email dado ya esta registrado
  static Future<List<String>> metodoInicioSesion(String email) async {
    return await aut.fetchSignInMethodsForEmail(email);
  }
}

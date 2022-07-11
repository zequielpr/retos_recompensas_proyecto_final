import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Notificaciones/AdministrarTokens.dart';
import 'Autenticacion.dart';
import '../../main.dart';
import 'DatosNewUser.dart';

class Login extends StatelessWidget {
  final CollectionReference collectionReferenceUsuarios;
  const Login(this.collectionReferenceUsuarios, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
          title: 'Flutter Demo Home Page',
          collecUsuarios: collectionReferenceUsuarios),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {Key? key, required this.title, required this.collecUsuarios})
      : super(key: key);
  final String title;
  final CollectionReference collecUsuarios;

  @override
  State<MyHomePage> createState() => _MyHomePageState(collecUsuarios);
}

class _MyHomePageState extends State<MyHomePage> {
  final passw = TextEditingController();
  final correo = TextEditingController();
  String descripcion = '';
  final CollectionReference  collecUsuarios;

  _MyHomePageState(this.collecUsuarios);
  @override
  Widget build(BuildContext context) {
    final correo = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //Iniciar sesion con google
            ElevatedButton(
              child: Text('iniciar sesión con google'),
              onPressed: () async =>registrar()
            ),
          ],
        ),
      ),
    );
  }

  registrar() async {
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

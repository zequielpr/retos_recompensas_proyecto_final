import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_fonts/google_fonts.dart';
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
  final CollectionReference collecUsuarios;

  Color colorBorde = const Color.fromARGB(226, 114, 114, 114);

  _MyHomePageState(this.collecUsuarios);
  @override
  Widget build(BuildContext context) {
    final correo = TextEditingController();

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 0),
            child: SizedBox(
              width: 300,
              child: Column(
                children: [
                  Text(
                    'Inicia sesion en <nombre app>',
                    style: GoogleFonts.roboto(color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(bottom: 76, top: 10),
            child: SizedBox(
              width: 254,
              child: Text(
                'Inicia sesion en <nombre app> y tutorea o '
                'se tutorado, empleando nuestros servicios.',
                style: GoogleFonts.roboto(color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          //Iniciar sesion con correo y contraseña
          Padding(
            padding: EdgeInsets.only(top: 0),
            child: Card(
                margin: EdgeInsets.all(0),
                semanticContainer: true,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                    side: BorderSide(color: colorBorde)),
                child: SizedBox(
                  width: 300,
                  height: 47,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.transparent),
                        padding: MaterialStateProperty.all(
                            EdgeInsetsGeometry.lerp(
                                EdgeInsets.all(0), EdgeInsets.all(0), 0)),
                        elevation: MaterialStateProperty.all(0)),
                    onPressed: () async =>
                        Autenticar.continuarConGoogle(collecUsuarios, context),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children:  [
                        const Padding(
                            padding: EdgeInsets.only(right: 43, left: 10),
                            child: Icon(
                              Icons.person,
                              size: 30,
                              color: Colors.black,
                            )),
                        Text(
                          'Correo/constraseña',
                          style: GoogleFonts.roboto(fontSize: 19, color: Colors.black, fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  ),
                )),
          ),

          //Iniciar sesión con google
          Padding(
            padding: EdgeInsets.only(top: 12),
            child: Card(
                margin: EdgeInsets.all(0),
                semanticContainer: true,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                    side: BorderSide(color: colorBorde)),
                child: SizedBox(
                  width: 300,
                  height: 47,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.transparent),
                        padding: MaterialStateProperty.all(
                            EdgeInsetsGeometry.lerp(
                                EdgeInsets.all(0), EdgeInsets.all(0), 0)),
                        elevation: MaterialStateProperty.all(0)),
                    onPressed: () async =>
                        Autenticar.continuarConGoogle(collecUsuarios, context),
                    child: Row(
                      children:  [
                        const Padding(
                            padding: EdgeInsets.only(right: 40, left: 10),
                            child: Image(
                                image: AssetImage('lib/imgs/img_google.png'),
                                height: 25,
                                width: 25)),
                        Text(
                          'Continuar con Google',
                          style: GoogleFonts.roboto(fontSize: 19, color: Colors.black, fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  ),
                )),
          ),

          //Iniciar sesion con facebook
          Padding(
            padding: EdgeInsets.only(top: 12),
            child: Card(
                margin: EdgeInsets.all(0),
                semanticContainer: true,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                    side: BorderSide(color: colorBorde)),
                child: SizedBox(
                  width: 300,
                  height: 47,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.transparent),
                        padding: MaterialStateProperty.all(
                            EdgeInsetsGeometry.lerp(
                                EdgeInsets.all(0), EdgeInsets.all(0), 0)),
                        elevation: MaterialStateProperty.all(0)),
                    onPressed: () async =>
                        Autenticar.continuarConGoogle(collecUsuarios, context),
                    child: Row(
                      children:  [
                        const Padding(
                            padding: EdgeInsets.only(right: 35, left: 10),
                            child: Image(
                                image: AssetImage('lib/imgs/img_facebook.png'),
                                height: 25,
                                width: 25)),
                        Text(
                          'Continuar con Facebook',
                          style: GoogleFonts.roboto(fontSize: 19, color: Colors.black, fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  ),
                )),
          ),

          //Inicio de sesio con apple
          Padding(
            padding: EdgeInsets.only(top: 12),
            child: Card(
                margin: EdgeInsets.all(0),
                semanticContainer: true,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                    side: BorderSide(color: colorBorde)),
                child: SizedBox(
                  width: 300,
                  height: 47,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.transparent),
                        padding: MaterialStateProperty.all(
                            EdgeInsetsGeometry.lerp(
                                EdgeInsets.all(0), EdgeInsets.all(0), 0)),
                        elevation: MaterialStateProperty.all(0)),
                    onPressed: () async =>
                        Autenticar.continuarConGoogle(collecUsuarios, context),
                    child: Row(
                      children: [
                        const Padding(
                            padding: EdgeInsets.only(right: 45, left: 10),
                            child: Image(
                                image: AssetImage('lib/imgs/img_apple.png'),
                                height: 27,
                                width: 27)),
                        Text(
                          'Continuar con Apple',
                          style: GoogleFonts.roboto(fontSize: 19, color: Colors.black, fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  ),
                )),
          ),

          Padding(
            padding: EdgeInsets.only(bottom: 0, top: 70),
            child: Container(
                width: 254,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: 'Al continuar, aceptas nuestros ',
                      style:  GoogleFonts.roboto(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w300),
                      children: <TextSpan>[
                        TextSpan(
                          text: ' Terminos del servicios ',
                          style: const TextStyle(
                              color: Color.fromARGB(236, 231, 64, 122),
                              fontSize: 13,
                              fontWeight: FontWeight.w300),
                          recognizer: TapGestureRecognizer()
                            ..onTap = _terminosDelServicio,
                        ),
                        const TextSpan(text: 'y confirmas haber leido la '),
                        TextSpan(
                            text: 'politica de privacidad.',
                            style: const TextStyle(
                                color: Color.fromARGB(236, 231, 64, 122)),
                            recognizer: TapGestureRecognizer()
                              ..onTap = _politicaDePrivacidad),
                      ]),
                )),
          ),

          Padding(
            padding: EdgeInsets.only(top: 50),
            child: Container(
              color: const Color.fromARGB(202, 217, 217, 217),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('¿No tienes una cuenta?',
                      style: TextStyle(
                        fontSize: 17,
                      )),
                  TextButton(
                      onPressed: () {},
                      child: Text(
                        'Registrarse',
                        style: TextStyle(
                            color: Color.fromARGB(236, 231, 64, 122),
                            fontSize: 18),
                      ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _terminosDelServicio() {
    print('Terminos del servicio');
  }

  void _politicaDePrivacidad() {
    print('Politica de privacidad');
  }
}

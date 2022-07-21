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
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:retos_proyecto/Servicios/Autenticacion/EmailPassw/IniciarSessionEmailPassw.dart';

import '../../datos/TransferirDatos.dart';
import '../Notificaciones/AdministrarTokens.dart';
import 'Autenticacion.dart';
import '../../main.dart';
import 'DatosNewUser.dart';

class Login extends StatefulWidget {
  static const ROUTE_NAME = 'Login';
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _loading = false;

  void _onLoading() {
    setState(() {
      _loading = true;
    });
  }

  Future _login() async {
    setState(() {
      _loading = false;
    });
  }

  final passw = TextEditingController();
  final correo = TextEditingController();
  String descripcion = '';
  late CollectionReference collecUsuarios;

  Color colorBorde = const Color.fromARGB(226, 114, 114, 114);

  dynamic contenidoBoton = Text(
    'Continuar con Google',
    style: GoogleFonts.roboto(
        fontSize: 19, color: Colors.black, fontWeight: FontWeight.w400),
  );

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as TransferirCollecion;
    collecUsuarios = args.collectionReferenceUser;

    /*FlutterStatusbarcolor.setStatusBarWhiteForeground(
        false); //Colores de los iconos de la barra superior
    FlutterStatusbarcolor.setStatusBarColor(Colors.white,
        animate: true); //Color de la barra superior*/



    final correo = TextEditingController();

    var body = Column(
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
                  style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: 22.5,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.only(bottom: 76, top: 10),
          child: SizedBox(
            width: 280,
            child: Text(
              'Inicia sesion en <nombre app> y tutorea o '
              'se tutorado, empleando nuestros servicios.',
              style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontSize: 15.5,
                  fontWeight: FontWeight.w300),
              textAlign: TextAlign.center,
            ),
          ),
        ),

        //Iniciar sesion con correo y contraseña
        Padding(
          padding: EdgeInsets.only(top: 0),
          child: SizedBox(
            width: 305,
            height: 47,
            child: ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                      side: BorderSide(color: colorBorde))),
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent),
                  padding: MaterialStateProperty.all(EdgeInsetsGeometry.lerp(
                      EdgeInsets.all(0), EdgeInsets.all(0), 0)),
                  elevation: MaterialStateProperty.all(0)),
              onPressed: () {
                var datos =
                    TransDatosInicioSesion('', true, false, '', collecUsuarios);
                Navigator.pushNamed(context, IniSesionEmailPassword.ROUTE_NAME,
                    arguments: datos);

                /*Autenticar.comprobarNewOrOld(collecUsuarios, context)*/
              },
              child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'lib/imgs/img_logo_provicional.png',
                      ),
                      alignment: Alignment(-0.9, 0),
                      scale: 39,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Continuar con <App Name>',
                      //textAlign: TextAlign.justify,
                      style: GoogleFonts.roboto(
                          fontSize: 19,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                    ),
                  )),
            ),
          ),
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
                width: 305,
                height: 47,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.transparent),
                        padding: MaterialStateProperty.all(
                            EdgeInsetsGeometry.lerp(
                                EdgeInsets.all(0), EdgeInsets.all(0), 0)),
                        elevation: MaterialStateProperty.all(0)),
                    onPressed: () async {
                      _onLoading();
                      var googleAccount = await Autenticar.getGoogleAcount();

                      if (googleAccount == null) {
                        _login();
                        return;
                      }

                      var credencialGoogle =
                          await Autenticar.obtenerCredencialesGoogle(
                                  googleAccount)
                              .catchError((e) {
                        print('holaa');
                      });

                      //Obtiene los método de inicio correspondiente al email pasado por parámetro.
                      List<String> metodosInicioSesion =
                          await Autenticar.metodoInicioSesion(
                              googleAccount.email);

                      var isNewUser =
                          metodosInicioSesion.isNotEmpty ? false : true;

                      if (!mounted) return;

                      await Autenticar.newOrOld(collecUsuarios, context,
                              isNewUser, credencialGoogle, 'Google')
                          .whenComplete(() => _login());
                    },
                    child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              'lib/imgs/img_google.png',
                            ),
                            alignment: Alignment(-0.9, 0),
                            scale: 5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Continuar con google',
                            //textAlign: TextAlign.justify,
                            style: GoogleFonts.roboto(
                                fontSize: 19,
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                          ),
                        ))),
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
                width: 305,
                height: 47,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.transparent),
                        padding: MaterialStateProperty.all(
                            EdgeInsetsGeometry.lerp(
                                EdgeInsets.all(0), EdgeInsets.all(0), 0)),
                        elevation: MaterialStateProperty.all(0)),
                    onPressed: () async {
                      _onLoading();
                      print('Continuar con facebook');
                      var oaUthCredential =
                          await Autenticar.obtenerCredencialesFacebook();
                      if(oaUthCredential == null){
                        _login();
                        return;
                      }
                      var credentialUser =
                          await Autenticar.iniciarSesion(oaUthCredential!);
                      bool isNewUser =
                          credentialUser?.additionalUserInfo?.isNewUser as bool;

                      isNewUser? await credentialUser?.user?.delete():null;//Si es nuevo se borra el usuario

                      await Autenticar.newOrOld(collecUsuarios, context,
                              isNewUser, oaUthCredential, 'Facebook')
                          .whenComplete(() => _login());
                    },
                    child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('lib/imgs/img_facebook.png'),
                            alignment: Alignment(-0.9, 0),
                            scale: 14.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Continuar con Facebook',
                            //textAlign: TextAlign.justify,
                            style: GoogleFonts.roboto(
                                fontSize: 19,
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                          ),
                        ))),
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
                width: 305,
                height: 47,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.transparent),
                        padding: MaterialStateProperty.all(
                            EdgeInsetsGeometry.lerp(
                                EdgeInsets.all(0), EdgeInsets.all(0), 0)),
                        elevation: MaterialStateProperty.all(0)),
                    onPressed: () async {
                      /*await Autenticar.signInWithApple();*/
                    },
                    child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('lib/imgs/img_apple.png'),
                            alignment: Alignment(-0.9, 0),
                            scale: 155,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Continuar con Apple',
                            //textAlign: TextAlign.justify,
                            style: GoogleFonts.roboto(
                                fontSize: 19,
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                          ),
                        ))),
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
                    style: GoogleFonts.roboto(
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
                    style: GoogleFonts.roboto(
                      fontSize: 17,
                    )),
                TextButton(
                    onPressed: () {
                      TranferirDatosRoll datos =
                          TranferirDatosRoll('userContraseña', collecUsuarios);
                      _irRollPage(datos);
                    },
                    child: Text(
                      'Registrarse',
                      style: GoogleFonts.roboto(
                          color: Color.fromARGB(236, 231, 64, 122),
                          fontSize: 18),
                    ))
              ],
            ),
          ),
        ),
      ],
    );

    var bodyProgress = Container(
      child: Stack(
        children: <Widget>[
          body,
          Container(
            alignment: AlignmentDirectional.center,
            decoration: const BoxDecoration(),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue[200],
                  borderRadius: BorderRadius.circular(10.0)),
              width: 50.0,
              height: 50.0,
              alignment: AlignmentDirectional.center,
              child: Transform.scale(
                scale: 0.7,
                child: const CircularProgressIndicator(
                  color: Colors.grey,
                  strokeWidth: 5,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return Scaffold(body: _loading ? bodyProgress : body);
  }

  void _cambiarEstadoBoton() {
    setState(() {
      contenidoBoton = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.circle,
            color: Colors.black,
            size: 10,
          ),
          Icon(Icons.circle, color: Colors.black, size: 10),
          Icon(Icons.circle, color: Colors.black, size: 10)
        ],
      );
    });
  }

  void _terminosDelServicio() {
    print('Terminos del servicio');
  }

  void _politicaDePrivacidad() {
    print('Politica de privacidad');
  }

  void _irRollPage(TranferirDatosRoll datos) {
    Navigator.pushNamed(context, Roll.ROUTE_NAME, arguments: datos);
  }
}

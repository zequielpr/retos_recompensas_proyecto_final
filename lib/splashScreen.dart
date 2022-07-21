import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:retos_proyecto/vista_tutor/TabPages/TaPagesSala.dart';
import 'package:retos_proyecto/vista_tutorado/Salas/ListaMisiones.dart';

import 'Roll_Data.dart';
import 'Rutas.dart';
import 'Servicios/Autenticacion/DatosNewUser.dart';
import 'Servicios/Autenticacion/EmailPassw/IniciarSessionEmailPassw.dart';
import 'Servicios/Autenticacion/EmailPassw/RecogerEmail.dart';
import 'Servicios/Autenticacion/EmailPassw/RecogerPassw.dart';
import 'Servicios/Autenticacion/login.dart';
import 'datos/TransferirDatos.dart';
import 'main.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    //'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(splashScreen());
}

class splashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Color de la barra inferior

    return MaterialApp(
      initialRoute: '/',
      routes: Rutas.getRutas(),
      theme: ThemeData(
          textTheme: const TextTheme(
              bodyText2: TextStyle(color: Colors.black, fontSize: 17),
              button: TextStyle(color: Colors.black)),
          inputDecorationTheme: const InputDecorationTheme(
              contentPadding: EdgeInsets.only(left: 10),
              constraints: BoxConstraints.expand(height: 48, width: 300),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  style: BorderStyle.solid,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(style: BorderStyle.solid, color: Colors.blue),
              )),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
          ),
          bottomAppBarTheme: const BottomAppBarTheme(color: Colors.amber),
          primaryTextTheme: TextTheme(button: TextStyle(color: Colors.black)),
          tabBarTheme: TabBarTheme(labelColor: Colors.black),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  //foregroundColor: MaterialStateProperty.all(Colors.black26),
                  overlayColor: MaterialStateProperty.all(
                      const Color.fromARGB(165, 243, 241, 241)),
                  elevation: MaterialStateProperty.all(0),
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                  textStyle: MaterialStateProperty.all(GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700))))),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    FlutterStatusbarcolor.setNavigationBarWhiteForeground(
        false); //Colores de los iconos de la barra inferior
    FlutterStatusbarcolor.setNavigationBarColor(Colors.red);

    _navigateToHome();
  }

  var datos;

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent, animate: true);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);

    FlutterStatusbarcolor.setNavigationBarWhiteForeground(true); //Colores de los iconos de la barra inferior
    FlutterStatusbarcolor.setNavigationBarColor(Colors.transparent);
    /*
    FlutterStatusbarcolor.setStatusBarWhiteForeground(
        false); //Colores de los iconos de la barra superior
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent,
        animate: false); //Color de barra superior

    FlutterStatusbarcolor.setNavigationBarColor(
        Colors.black); //Color de la barra inferior
     */

    FlutterStatusbarcolor.setNavigationBarColor(
        Colors.black); //Color de la barra inferior
    FlutterStatusbarcolor.setNavigationBarWhiteForeground(true);

    return Container(
        color: Colors.white,
        child: FlutterLogo(size: MediaQuery.of(context).size.height));
  }

  _navigateToHome() async {
    final CollectionReference CollecionUsuarios =
        FirebaseFirestore.instance.collection('usuarios');
    await Future.delayed(Duration(milliseconds: 2500), () {});
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        var datos = TransferirCollecion(CollecionUsuarios);
        Navigator.pushReplacementNamed(context, Login.ROUTE_NAME,
            arguments: datos);
      } else {
        DocumentReference docUser =
            CollecionUsuarios.doc(FirebaseAuth.instance.currentUser?.uid);
        await docUser.get().then((value) {
          Roll_Data.ROLL_USER_IS_TUTORADO = value['rol_tutorado'];
          datos = TransferirDatosInicio(value['rol_tutorado']);

          if (!mounted) return;
          Navigator.pushReplacementNamed(context, Inicio.ROUTE_NAME,
              arguments: datos);
        });
      }
    });
  }
}

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:retos_proyecto/vista_tutor/TabPages/TaPagesSala.dart';
import 'package:retos_proyecto/vista_tutorado/Salas/ListaMisiones.dart';

import 'Servicios/Autenticacion/DatosNewUser.dart';
import 'Servicios/Autenticacion/emailPassword.dart';
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
    return MaterialApp(initialRoute: '/', routes: {
      '/': (context) => MyHomePage(),
      Login.ROUTE_NAME: (context) => const Login(),
      Roll.ROUTE_NAME: (context) => const Roll(),
      NombreUsuario.ROUTE_NAME: (context) => const NombreUsuario(),
      IniSesionEmailPassword.ROUTE_NAME: (context) =>
          const IniSesionEmailPassword(),
      Inicio.ROUTE_NAME: (context) => Inicio(),
      ListaMisiones.ROUTE_NAME: (context) => const ListaMisiones(),
      TabPagesSala.ROUTE_NAME: (context) => const TabPagesSala(),
      RecogerPassw.ROUTE_NAME: (context) => const RecogerPassw(),
      RecogerEmail.ROUTE_NAME: (context) => const RecogerEmail(),
      IniSesionEmailPassword.ROUTE_NAME: (context) => const IniSesionEmailPassword(),
    });
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  var datos;

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(
        false); //Colores de los iconos de la barra superior
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent,
        animate: false); //Color de barra superior

    FlutterStatusbarcolor.setNavigationBarColor(
        Colors.black); //Color de la barra inferior
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
        var datos = TransferirDatosLogin(CollecionUsuarios);
        Navigator.pushReplacementNamed(context, Login.ROUTE_NAME,
            arguments: datos);
      } else {
        DocumentReference docUser =
            CollecionUsuarios.doc(FirebaseAuth.instance.currentUser?.uid);
        await docUser.get().then((value) => {
              datos = TransferirDatosInicio(value['rol_tutorado']),
              Navigator.pushReplacementNamed(context, Inicio.ROUTE_NAME,
                  arguments: datos)
            });
      }
    });
  }
}

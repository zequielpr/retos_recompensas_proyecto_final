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
import 'package:auto_route/auto_route.dart';
import 'package:retos_proyecto/MediaQuery.dart';

import 'Colores.dart';
import 'Rutas.gr.dart';
import 'datos/Roll_Data.dart';
import 'Rutas.dart';
import 'Servicios/Autenticacion/DatosNewUser.dart';
import 'Servicios/Autenticacion/EmailPassw/IniciarSessionEmailPassw.dart';
import 'Servicios/Autenticacion/EmailPassw/RecogerEmail.dart';
import 'Servicios/Autenticacion/EmailPassw/RecogerPassw.dart';
import 'Servicios/Autenticacion/login.dart';
import 'datos/TransferirDatos.dart';
import 'datos/UsuarioActual.dart';
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
  final _appRouter = AppRouter();
  @override
  Widget build(BuildContext context) {
    //Color de la barra inferior

    return MaterialApp.router(
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
      theme: ThemeData(
          textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                textStyle: MaterialStateProperty.all(TextStyle(fontSize: 20)),
                  foregroundColor:
                      MaterialStateProperty.all(Colores.colorPrincipal))),
          textTheme: const TextTheme(
              bodyText2: TextStyle(color: Colors.black, fontSize: 17),
              button: TextStyle(color: Colors.black)),
          inputDecorationTheme: InputDecorationTheme(
              labelStyle: TextStyle(color: Colors.black),
              contentPadding: EdgeInsets.all(10),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  style: BorderStyle.solid,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    style: BorderStyle.solid, color: Colores.colorPrincipal),
              )),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
          ),
          primaryTextTheme: TextTheme(button: TextStyle(color: Colors.black)),
          tabBarTheme: TabBarTheme(labelColor: Colors.black),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(
                      Color.fromARGB(236, 255, 255, 255)),
                  //foregroundColor: MaterialStateProperty.all(Colors.black26),
                  overlayColor: MaterialStateProperty.all(
                      const Color.fromARGB(165, 243, 241, 241)),
                  elevation: MaterialStateProperty.all(0),
                  backgroundColor:
                      MaterialStateProperty.all(Colores.colorPrincipal),
                  textStyle: MaterialStateProperty.all(GoogleFonts.roboto(
                      fontSize: 16, fontWeight: FontWeight.w700))))),
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

    FlutterStatusbarcolor.setNavigationBarWhiteForeground(
        true); //Colores de los iconos de la barra inferior
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
      if (user == null || user.emailVerified == false) {
        var datos = TransferirCollecion(CollecionUsuarios);
        if (!mounted) return;

        context.router.replace(LoginRouter(args: datos));
      } else {
        //Guardar usuario actual
        CurrentUser.setCurrentUser();
        DocumentReference docUser =
            CollecionUsuarios.doc(FirebaseAuth.instance.currentUser?.uid);
        await docUser.get().then((value) {
          Roll_Data.ROLL_USER_IS_TUTORADO = value['rol_tutorado'];
          if (!mounted) return;
          context.router.replace(MainRouter());
        });
      }
    });
  }
}

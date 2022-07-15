import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';

import 'Servicios/Autenticacion/DatosNewUser.dart';
import 'Servicios/Autenticacion/login.dart';
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

  //Crea instancia de firebase y obtiene la coleccion de usuarios
  final CollectionReference CollecionUsuarios = FirebaseFirestore.instance
      .collection('usuarios');



  Widget build(BuildContext context) {
    //FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    return MaterialApp(
      title: 'Splash Screen',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
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

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);//Colores de los iconos de la barra superior
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent, animate: false); //Color de barra superior

    FlutterStatusbarcolor.setNavigationBarColor(Colors.black); //Color de la barra inferior
    return Container(
        color: Colors.white,
        child: FlutterLogo(size: MediaQuery.of(context).size.height));
  }

  _navigateToHome() async {
    final CollectionReference CollecionUsuarios =
    FirebaseFirestore.instance.collection('usuarios');
    await Future.delayed(Duration(milliseconds: 2500), () {});
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {

      //Probando la consulta:
      //Generar consulta para comprobar si el nombre de usuario esta en uso

      /*
      await CollecionUsuarios.where("nombre_usuario", isEqualTo: "maikel11").get().then((value) => {
        if(value.docs.isEmpty){
          print("nombre de usuario disponible")
        }else{
          print("Nombre de usuario no disponible")
        }
      });
       */



      if (user == null) {;
       Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => Login(CollecionUsuarios)));
      } else {
        //Si el usuario esta registrado
        late bool isTutorado;

        DocumentReference docUser =
            CollecionUsuarios.doc(FirebaseAuth.instance.currentUser?.uid);
        await docUser.get().then((value) => {
        Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => Inicio(value['rol_tutorado']))),
              if (value['rol_tutorado'])
                {
                  print("Es tutorado")
                }
              else
                {
                  //_widgetOptions.clear();

                  print("Es tutor")
                }
            });


      }
    });
  }
}

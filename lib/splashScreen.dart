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
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_route/auto_route.dart';
import 'package:retos_proyecto/MediaQuery.dart';
import 'package:retos_proyecto/recursos/DateActual.dart';
import 'package:retos_proyecto/recursos/Valores.dart';

import 'Colores.dart';
import 'Rutas.gr.dart';
import 'datos/Roll_Data.dart';
import 'Rutas.dart';
import 'Servicios/Autenticacion/DatosNewUser.dart';
import 'Servicios/Autenticacion/EmailPassw/IniciarSessionEmailPassw.dart';
import 'Servicios/Autenticacion/EmailPassw/RecogerEmail.dart';
import 'Servicios/Autenticacion/EmailPassw/RecogerPassw/RecogerPassw.dart';
import 'Servicios/Autenticacion/login.dart';
import 'datos/TransferirDatos.dart';
import 'datos/UsuarioActual.dart';
import 'l10n/l10n.dart';
import 'main.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

late  AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }

  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    showBadge: false
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  isFlutterLocalNotificationsInitialized = true;
}


@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  await setupFlutterNotifications();

/*  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        'xxxxxxxxxxxxxx',
        'xxxxx',
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            color: Colors.blue,
            playSound: true,
            icon: '@mipmap/ic_launcher',
          ),
        ));
    print('final');
  }*/
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await setupFlutterNotifications();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);


  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  runApp(splashScreen());
}

class splashScreen extends StatelessWidget {
  final _appRouter = AppRouter();
  @override
  Widget build(BuildContext context) {
    //Color de la barra inferior
    Valores.setValores(context);
    return MaterialApp.router(
      supportedLocales: L10n.all,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
      theme: ThemeData(
          primaryColor: Colores.colorPrincipal,
          textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                  textStyle: MaterialStateProperty.all(TextStyle(fontSize: 15)),
                  foregroundColor:
                      MaterialStateProperty.all(Colores.colorPrincipal))),
          textTheme: TextTheme(
            subtitle1: GoogleFonts.roboto(color: Colors.black),
            bodyText2: GoogleFonts.roboto(color: Colors.black),
          ),
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
    DateActual.getActualDateTime();
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
        child: Image.asset('lib/imgs/ic_launcher.png', scale: 10.0));
  }

  _navigateToHome() async {
    final CollectionReference CollecionUsuarios =
        FirebaseFirestore.instance.collection('usuarios');
    await Future.delayed(const Duration(milliseconds: 1900), () {});
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null || user.emailVerified == false) {
        var datos = TransferirCollecion(CollecionUsuarios);
        if (mounted) context.router.replace(OnboadingRouter());
      } else {
        //Guardar usuario actual
        CurrentUser.setCurrentUser();
        DocumentReference docUser =
            CollecionUsuarios.doc(CurrentUser.getIdCurrentUser());
        await docUser.get().then((value) {
          Roll_Data.ROLL_USER_IS_TUTORADO = value['rol_tutorado'];
          if (!mounted) return;
          context.router.replace(MainRouter());
        });
      }
    }).onError((handleError) {
      print('holaaaaaaa');
    });
  }
}

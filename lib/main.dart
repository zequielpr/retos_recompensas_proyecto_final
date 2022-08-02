import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:retos_proyecto/Rutas.gr.dart';
import 'package:retos_proyecto/Servicios/Notificaciones/Badge.dart';
import 'package:retos_proyecto/datos/Roll_Data.dart';
import 'package:retos_proyecto/splashScreen.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';

import 'Servicios/Notificaciones/notificaciones_bandeja.dart';
import 'Servicios/Autenticacion/login.dart';
import 'datos/TransferirDatos.dart';

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  State<Main> createState() => MainState();
}

//Clase donde se probara to el proceso de crear una misión
class MainState extends State<Main> {
  List<int> _badgeCounts = List<int>.generate(5, (index) => index);
  List<bool> _badgeShows = List<bool>.generate(5, (index) => false);
  var count_notificaciones;
  void initState() {
    _badgeShows[1] = false;
    super.initState();
    //Mostrar el badge
    mostrarBadge(bool mostrar, cantidad) {
      setState(() {
        _badgeShows[1] = mostrar;
        _badgeCounts[1] = cantidad;
      });
    }

    //CallBack que actualiza el widget y muestra cuantas notificaciones hay
    Badge.isNewNotifications(mostrarBadge);


    //Actualizar widget de nitificaciion
    void actualizarWidgetNitificaciones(actualizar){
      actualizar();
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('se ha recibido una nueva notificacion');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        print('Se debería mostrar la notificacion');
        print(notification.title);
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                //channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ));
        print('final');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title.toString()),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body.toString())],
                  ),
                ),
              );
            });
      }
    });
  }

  final CollectionReference CollecionUsuarios = FirebaseFirestore.instance
      .collection('usuarios'); //Coleccion en la que se guardarán los usuarios

  void _onItemTapped(int index) {
    setState(() {
      routes.setActiveIndex(index);
    });
  }

  late TabsRouter routes;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: AutoTabsScaffold(
        routes: const [
          HomeRouter(),
          NotificacionesRouter(),
          SalasRouter(),
          AdminPerfilUserRouter()
        ],
        bottomNavigationBuilder: (_, tabsRouter) {
          routes = tabsRouter;
          return CustomNavigationBar(
            iconSize: 30.0,
            selectedColor: Color(0xff040307),
            strokeColor: Color(0x30040307),
            unSelectedColor: Color(0xffacacac),
            backgroundColor: Colors.white,
            items: [
              CustomNavigationBarItem(
                icon: Icon(Icons.home),
              ),
              CustomNavigationBarItem(
                icon: Icon(Icons.notifications),
                badgeCount: _badgeCounts[1],
                showBadge: _badgeShows[1],
              ),
              CustomNavigationBarItem(
                icon: Icon(Icons.meeting_room),
              ),
              CustomNavigationBarItem(
                icon: Icon(Icons.account_circle_rounded),
              ),
            ],
            currentIndex: routes.activeIndex,
            onTap: (index) {
              routes.setActiveIndex(index);
              if (routes.canPopSelfOrChildren) {
                switch (routes.activeIndex) {
                  case 0:
                    routes.navigate(const HomeRouter());
                    return;
                  case 1:
                    routes.navigate(const NotificacionesRouter());
                    return;
                  case 2:
                    routes.navigate(const SalasRouter());
                    return;
                  case 3:
                    routes.navigate(const AdminPerfilUserRouter());
                    return;
                  default:
                    return;
                }
              }

              if(index == 1){
                Badge.setStatusNewMision();
              }

            },
          );
        },
      ),
    );
  }

  //Metodo que evitará que la aplicacion se salga sin preguntar
  Future<bool> _onWillPop() async {
    if (routes.activeIndex > 0) {
      _onItemTapped(0);
      return false;
    }
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }
}

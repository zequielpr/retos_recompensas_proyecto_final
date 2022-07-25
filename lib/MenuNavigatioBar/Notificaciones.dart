import 'package:flutter/material.dart';
import 'package:retos_proyecto/datos/CollecUsers.dart';

import '../Servicios/Notificaciones/notificaciones_bandeja.dart';

class Notificaciones extends StatefulWidget {
  const Notificaciones({Key? key}) : super(key: key);

  @override
  State<Notificaciones> createState() => NotificacionesState();
}

class NotificacionesState extends State<Notificaciones> {

  void actualizar(){
    setState((){});
  }


  @override
  Widget build(BuildContext context) {
    print('holaaa');
    return Scaffold(
        appBar: AppBar(
          title: Align(alignment: Alignment.center, child: Text('Notificaciones'),),
        ),
        body: BandejaNotificaciones.getBandejaNotificaciones(
            CollecUser.COLECCION_USUARIOS, context));
    ;
  }
}

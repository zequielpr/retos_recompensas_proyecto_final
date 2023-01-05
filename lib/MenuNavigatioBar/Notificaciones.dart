import 'package:flutter/material.dart';
import 'package:retos_proyecto/datos/CollecUsers.dart';

import '../Servicios/Notificaciones/notificaciones_bandeja.dart';

class Notificaciones extends StatefulWidget {
  const Notificaciones({Key? key}) : super(key: key);

  @override
  State<Notificaciones> createState() => _NotificacionesState();
}

class _NotificacionesState extends State<Notificaciones> {

  GlobalKey _scaffold = GlobalKey();
 void initState(){
   super.initState();
   setState((){});
 }
 @override
 void didChangeDependencies() {
    // TODO: implement didChangeDependencies
   setState(() {

   });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
        appBar: AppBar(
          title: Align(alignment: Alignment.center, child: Text('Notificaciones'),),
        ),
        body: BandejaNotificaciones.getBandejaNotificaciones(
            CollecUser.COLECCION_USUARIOS, context));
    ;
  }
}

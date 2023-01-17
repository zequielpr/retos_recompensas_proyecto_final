import 'package:flutter/material.dart';
import 'package:retos_proyecto/datos/Colecciones.dart';

import '../Servicios/Notificaciones/notificaciones_bandeja.dart';
import 'Perfil/admin_usuarios/Admin_tutores.dart';

class Notificaciones extends StatefulWidget {
  const Notificaciones({Key? key}) : super(key: key);

  @override
  State<Notificaciones> createState() => _NotificacionesState();
}

class _NotificacionesState extends State<Notificaciones> {
  GlobalKey _scaffold = GlobalKey();
  void initCurrentTutor(currentTutor) {
    if (mounted) setState(() {});
  }

  void initState() {
    UsuarioTutores.setCurrentUser(initCurrentTutor);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffold,
        appBar: AppBar(
          title: Align(
            alignment: Alignment.center,
            child: Text('Notificaciones'),
          ),
        ),
        body: BandejaNotificaciones.getBandejaNotificaciones(
            Coleciones.COLECCION_USUARIOS, context));
    ;
  }
}

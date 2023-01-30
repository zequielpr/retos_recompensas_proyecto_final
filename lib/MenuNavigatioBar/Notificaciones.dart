import 'package:flutter/material.dart';
import 'package:retos_proyecto/datos/Colecciones.dart';

import '../Servicios/Notificaciones/notificaciones_bandeja.dart';
import 'Perfil/admin_usuarios/Admin_tutores.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Notificaciones extends StatefulWidget {
  const Notificaciones({Key? key}) : super(key: key);

  @override
  State<Notificaciones> createState() => _NotificacionesState();
}

class _NotificacionesState extends State<Notificaciones> {
  GlobalKey _scaffold = GlobalKey();
  AppLocalizations? valores;
  void initCurrentTutor(currentTutor) {
    if (mounted) setState(() {});
  }

  void initState() {
    UsuarioTutores.setCurrentUser(initCurrentTutor);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    valores = AppLocalizations.of(context);
    return Scaffold(
        key: _scaffold,
        appBar: AppBar(
          title: Align(
            alignment: Alignment.center,
            child: Text(valores?.notificaciones as String),
          ),
        ),
        body: BandejaNotificaciones(context, valores).getBandejaNotificaciones());
    ;
  }
}

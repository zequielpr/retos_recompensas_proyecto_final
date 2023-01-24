import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:retos_proyecto/MediaQuery.dart';
import 'package:retos_proyecto/datos/Colecciones.dart';
import 'package:retos_proyecto/datos/UsuarioActual.dart';

import '../../../Servicios/Autenticacion/EmailPassw/RecogerPassw/Widget_Recoger_Passw.dart';
import '../../../datos/TransferirDatos.dart';
import '../../../datos/ValidarDatos.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ChangePasswd extends StatefulWidget {
  final BuildContext contextPerfil;
  const ChangePasswd({Key? key, required this.contextPerfil}) : super(key: key);

  @override
  State<ChangePasswd> createState() => _ChangePasswdState(contextPerfil);
}

class _ChangePasswdState extends State<ChangePasswd> {
  final BuildContext contextPerfil;
  _ChangePasswdState(this.contextPerfil);
  AppLocalizations? valores;
  TrasnferirDatosNombreUser arg = TrasnferirDatosNombreUser.SoloNombre('userName');

  @override
  Widget build(BuildContext context) {
    valores = AppLocalizations.of(context);

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('${valores?.actualizar_passw}'),
        ),
        body: Padding(
          padding: EdgeInsets.only(
              left: Pantalla.getPorcentPanntalla(5, context, 'x'),
              right: Pantalla.getPorcentPanntalla(5, context, 'x'),
              top: Pantalla.getPorcentPanntalla(5, context, 'y')),
          child:  Widget_Recoger_Passw(context, valores, arg, setState, false).getTextFieldPasswd(),
        ));
  }
}

//Recoger contraseña
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:retos_proyecto/recursos/MediaQuery.dart';
import 'package:retos_proyecto/Rutas.gr.dart';
import 'package:retos_proyecto/Servicios/Autenticacion/DatosNewUser.dart';
import 'package:retos_proyecto/datos/ValidarDatos.dart';
import 'package:retos_proyecto/recursos/Espacios.dart';

import '../../../../datos/TransferirDatos.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'Widget_Recoger_Passw.dart';

class RecogerPassw extends StatefulWidget {
  final TrasnferirDatosNombreUser args;
  const RecogerPassw({Key? key, required this.args}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _RecogerPassw(args);
}

class _RecogerPassw extends State<RecogerPassw> {
  final TrasnferirDatosNombreUser args;
  _RecogerPassw(this.args);
  AppLocalizations? valores;
  var paddinLeftRight;

  @override
  void dispose() {
    Widget_Recoger_Passw.setPasswController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    valores = AppLocalizations.of(context);
    paddinLeftRight = Pantalla.getPorcentPanntalla(Espacios.leftRight, context, 'x');
    return Scaffold(
      appBar: AppBar(
        title: Text(valores?.registrarse as String),
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.only(top: Pantalla.getPorcentPanntalla(Espacios.top, context, 'y'), left: paddinLeftRight, right: paddinLeftRight),
          child: Widget_Recoger_Passw(context, valores, args, setState, true).getTextFieldPasswd(),
        ),
      ),
    );
  }



}

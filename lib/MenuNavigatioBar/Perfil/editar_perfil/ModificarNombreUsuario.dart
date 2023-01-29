import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:retos_proyecto/MediaQuery.dart';

import '../../../Servicios/Autenticacion/Autenticacion.dart';
import '../../../Servicios/Autenticacion/NombreUsuario.dart';
import '../../../datos/TransferirDatos.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ModificarNombreUsuario extends StatefulWidget {
  const ModificarNombreUsuario({Key? key}) : super(key: key);

  @override
  State<ModificarNombreUsuario> createState() => _ModificarNombreUsuarioState();
}

class _ModificarNombreUsuarioState extends State<ModificarNombreUsuario> {
  TrasnferirDatosNombreUser args =
  TrasnferirDatosNombreUser.SoloNombre(NombreUsuarioWidget.nombreUsuarioActual);
  late NombreUsuarioWidget textField = NombreUsuarioWidget(setState, context, args, false);
  AppLocalizations? valores;

  @override
  void dispose() {
    textField.cancelTimer();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    valores = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text( valores?.actualizar as String),
      ),
      body: Container(
        margin: EdgeInsets.only(
            left: Pantalla.getPorcentPanntalla(6, context, 'x'),
            right: Pantalla.getPorcentPanntalla(6, context, 'x'),
            top: Pantalla.getPorcentPanntalla(6, context, 'x')),
        child: textField.textFielNombreUsuario(context),
      ),
    );
  }
}

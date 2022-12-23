import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:retos_proyecto/MediaQuery.dart';

import '../../../Servicios/Autenticacion/Autenticacion.dart';
import '../../../Servicios/Autenticacion/NombreUsuario.dart';
import '../../../datos/TransferirDatos.dart';

class ModificarNombreUsuario extends StatefulWidget {
  const ModificarNombreUsuario({Key? key}) : super(key: key);

  @override
  State<ModificarNombreUsuario> createState() => _ModificarNombreUsuarioState();
}

class _ModificarNombreUsuarioState extends State<ModificarNombreUsuario> {
  late NombreUsuarioWidget textField;
  initState() {
    TrasnferirDatosNombreUser args =
        TrasnferirDatosNombreUser.SoloNombre(NombreUsuarioWidget.nombreUsuarioActual);
    textField = NombreUsuarioWidget(setState, context, args, false);
    super.initState();
    /* userNameController.selection = TextSelection.fromPosition(
        TextPosition(offset: userNameController.text.length));*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Modificar'),
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

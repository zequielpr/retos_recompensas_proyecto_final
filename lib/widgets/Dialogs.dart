import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../recursos/MediaQuery.dart';

class Dialogos {
  static mostrarDialog(actions, String titulo, mensaje, BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        titlePadding: EdgeInsets.only(
            left: Pantalla.getPorcentPanntalla(3, context, 'x'),
            top: Pantalla.getPorcentPanntalla(3, context, 'x'),
            bottom: Pantalla.getPorcentPanntalla(1, context, 'x')),
        alignment: Alignment.center,
        actionsAlignment: MainAxisAlignment.center,
        buttonPadding: EdgeInsets.all(0),
        actionsPadding:
            EdgeInsets.only(top: Pantalla.getPorcentPanntalla(0, context, 'x')),
        contentPadding: EdgeInsets.only(
            left: Pantalla.getPorcentPanntalla(3, context, 'x'),
            right: Pantalla.getPorcentPanntalla(3, context, 'x')),
        title: Text(titulo, textAlign: TextAlign.center),
        content: mensaje.runtimeType == String? Text(
          mensaje,
          textAlign: TextAlign.center,
        ): mensaje,
        actions: actions(context),
      ),
    );
  }
}

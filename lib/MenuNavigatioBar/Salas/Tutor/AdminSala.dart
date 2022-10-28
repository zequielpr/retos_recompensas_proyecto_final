import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:retos_proyecto/MenuNavigatioBar/Perfil/AdminRoles.dart';
import 'package:retos_proyecto/datos/CollecUsers.dart';
import 'package:retos_proyecto/datos/UsuarioActual.dart';

import '../../../MediaQuery.dart';

class AdminSala {
  static Future<void> eliminarSala(
      String idSala, BuildContext context, BuildContext c) async {

    var title = const Text('Eliminar Sala', textAlign: TextAlign.center);
    var message = const Text(
      '¿Deseas eliminar esta sala?',
      textAlign: TextAlign.center,
    );

    showMessaje(title, message, context, idSala);
  }



  static showMessaje(titulo, mensaje, BuildContext contextSala, String idSala) {
    showDialog<String>(
      context: contextSala,
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
        title: titulo,
        content: mensaje,
        actions:  <Widget>[
          TextButton(
            onPressed: () {
            context.router.pop();
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await CollecUser.COLECCION_USUARIOS
                  .doc(CurrentUser.getIdCurrentUser())
                  .collection('rolTutor')
                  .doc(idSala)
                  .delete();
              context.router.pop();
              contextSala.router.pop();
            },
            child: Text('Eliminar'),
          )
        ],
      ),
    );
  }
}

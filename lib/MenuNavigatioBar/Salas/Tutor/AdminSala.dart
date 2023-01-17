import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:retos_proyecto/MenuNavigatioBar/Perfil/AdminRoles.dart';
import 'package:retos_proyecto/datos/Colecciones.dart';
import 'package:retos_proyecto/datos/UsuarioActual.dart';
import 'package:retos_proyecto/widgets/Dialogs.dart';

import '../../../MediaQuery.dart';

class AdminSala {
  static Future<void> eliminarSala(
      String idSala, BuildContext context, BuildContext c) async {
    var title = const Text('Eliminar Sala', textAlign: TextAlign.center);
    var message = const Text(
      '¿Deseas eliminar esta sala?',
      textAlign: TextAlign.center,
    );

    EliminarSalaShowMessaje(title, message, context, idSala);
  }

  static EliminarSalaShowMessaje(
      titulo, mensaje, BuildContext contextSala, String idSala) {
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
        actions: <Widget>[
          TextButton(
            onPressed: () {
              context.router.pop();
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await eliminarSalasDeUsuarios(idSala);
              context.router.pop();
              contextSala.router.pop();
            },
            child: Text('Eliminar'),
          )
        ],
      ),
    );
  }

  //Eliminar sala de usuarios tutorados
  static Future<void> eliminarSalasDeUsuarios(String idSala) async {
    await (Coleciones.COLECCION_USUARIOS
        .doc(CurrentUser.getIdCurrentUser())
        .collection('rolTutor')
        .doc(CurrentUser.getIdCurrentUser())
        .collection('salas')
        .doc(idSala)
        .collection('usersTutorados')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        Coleciones.COLECCION_USUARIOS
            .doc(element.id)
            .collection('rolTutorado')
            .doc(CurrentUser.getIdCurrentUser())
            .update({
          'salas_id': FieldValue.arrayRemove([idSala])
        });
      });
    })).catchError((onError) {}).then((value) {
      (_eliminarSala(idSala));
    });
  }

  static Future<void> _eliminarSala(idSala) async {
    await Coleciones.COLECCION_USUARIOS
        .doc(CurrentUser.getIdCurrentUser())
        .collection('rolTutor')
        .doc(CurrentUser.getIdCurrentUser())
        .collection('salas')
        .doc(idSala)
        .delete();
  }

  static Future<int> comprobarNumMisiones(String? idSala) async {
    int numeroMisiones = 0;
    await Coleciones.COLECCION_USUARIOS
        .doc(CurrentUser.getIdCurrentUser())
        .collection('rolTutor').doc(CurrentUser.getIdCurrentUser()).collection('salas')
        .doc(idSala)
        .collection('misiones')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        numeroMisiones++;
      });
    });

    return numeroMisiones;
  }

  //Eliminar mision
  static Future<void> eliminarMision(
      String? idSala, String idMision, BuildContext context) async {
    var title = 'Eliminar mision';
    var message = '¿Deseas eliminar esta misión?';
    actions(BuildContext context){
      return <Widget>[
        TextButton(
          onPressed: () {
            context.router.pop();
          },
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () async {
            await Coleciones.COLECCION_USUARIOS
                .doc(
              CurrentUser.getIdCurrentUser(),
            )
                .collection('rolTutor')
                .doc(CurrentUser.getIdCurrentUser())
                .collection('salas')
                .doc(idSala)
                .collection('misiones')
                .doc(idMision)
                .delete()
                .then(
                  (value) => context.router.pop(),
            );
          },
          child: Text('Eliminar'),
        )
      ];
    }

    Dialogos.mostrarDialog(actions, title, message, context);
  }
}

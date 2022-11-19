import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:retos_proyecto/datos/CollecUsers.dart';
import 'package:retos_proyecto/datos/UsuarioActual.dart';

import '../../../MediaQuery.dart';

class DejarTutoria {
  static eliminarTutor(BuildContext context, String idTutor) {
    dialogDejarTutoria(context, idTutor);
  }

  //preguntar antes de dejar la tutoría
  static dialogDejarTutoria(BuildContext context, String idTutor) {
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
        title: Text('Dejar tutoría', textAlign: TextAlign.center),
        content: const Text(
          'Los avances obtenidos en esta tutoría serán eliminados y no será posible recuperarlos',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => context.router.pop(),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              eliminarDeCurrentTutor();
              eliminarAvance(idTutor);
              eliminarDeListaAllUsers(idTutor);
              eliminarDeTodasSalas(idTutor);
              context.router.pop();
            },
            child: Text('ok'),
          )
        ],
      ),
    );
    ;
  }

  //eliminar id el usuario tutor
  static Future<void> eliminarDeCurrentTutor() async {
    await CollecUser.COLECCION_USUARIOS
        .doc(CurrentUser.getIdCurrentUser())
        .update({"current_tutor": ''});
  }

  //Eliminar avance otenido con el tutor
  static Future<void> eliminarAvance(idTutor) async {
    await CollecUser.COLECCION_USUARIOS
        .doc(CurrentUser.getIdCurrentUser())
        .collection('rolTutorado')
        .doc(idTutor)
        .delete();
  }

  //Eliminar de la lista de todos los usarios tutorados
  static Future<void> eliminarDeListaAllUsers(String idTutor) async {
    await CollecUser.COLECCION_USUARIOS
        .doc(idTutor)
        .collection('rolTutor')
        .doc(idTutor)
        .collection('allUsersTutorados')
        .doc('usuarios_tutorados')
        .update({
      'idUserTotorado': FieldValue.arrayRemove([CurrentUser.getIdCurrentUser()])
    });
  }

  //Eliminar de todas las salas en las que se encuentre
  static Future<void> eliminarDeTodasSalas(idTutor) async {
    await CollecUser.COLECCION_USUARIOS
        .doc(idTutor)
        .collection('rolTutor')
        .doc(idTutor)
        .collection('salas')
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        await element.reference
            .collection('usersTutorados')
            .doc(CurrentUser.getIdCurrentUser())
            .delete();
      });
    });
  }
}
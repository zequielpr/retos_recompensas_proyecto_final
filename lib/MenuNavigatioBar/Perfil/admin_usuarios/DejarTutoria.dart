import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:retos_proyecto/datos/Colecciones.dart';
import 'package:retos_proyecto/datos/UsuarioActual.dart';
import 'package:retos_proyecto/widgets/Dialogs.dart';

import '../../../recursos/MediaQuery.dart';

class DejarTutoria {
  static eliminarTutor(BuildContext context, String idTutor, AppLocalizations? valores) {
    dialogDejarTutoria(context, idTutor, valores);
  }

  //preguntar antes de dejar la tutoría
  static dialogDejarTutoria(BuildContext context, String idTutor, AppLocalizations? valores) {
    String titulo = '${valores?.dejar_tutoria}';
    String mensaje = '${valores?.avances_obtenidos_perder}';
    actions(BuildContext context){
      return <Widget>[
        TextButton(
          onPressed: () => context.router.pop(),
          child: Text('${valores?.cancelar}'),
        ),
        TextButton(
          onPressed: () async {
            eliminarDeCurrentTutor(CurrentUser.getIdCurrentUser()).whenComplete(() => eliminarAvance(idTutor));
            eliminarDeListaAllUsers(idTutor);
            eliminarDeTodasSalas(idTutor);
            context.router.pop();
          },
          child: Text('ok'),
        )
      ];
    }

    Dialogos.mostrarDialog(actions, titulo, mensaje, context);
  }

  //eliminar id el usuario tutor
  static Future<void> eliminarDeCurrentTutor(String idRemoveUser) async {
    await Coleciones.COLECCION_USUARIOS
        .doc(idRemoveUser)
        .update({"current_tutor": ''});
  }

  //Eliminar avance otenido con el tutor
  static Future<void> eliminarAvance(idTutor) async {
    await Coleciones.COLECCION_USUARIOS
        .doc(CurrentUser.getIdCurrentUser())
        .collection('rolTutorado')
        .doc(idTutor)
        .delete();
  }

  //Eliminar de la lista de todos los usarios tutorados
  static Future<void> eliminarDeListaAllUsers(String idTutor) async {
    await Coleciones.COLECCION_USUARIOS
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
    await Coleciones.COLECCION_USUARIOS
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

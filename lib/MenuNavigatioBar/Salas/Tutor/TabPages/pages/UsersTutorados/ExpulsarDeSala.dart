import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:retos_proyecto/datos/CollecUsers.dart';
import 'package:retos_proyecto/datos/UsuarioActual.dart';

import '../../../../../../widgets/Dialogs.dart';

class ExplusarDeSala {
  static Future<void> ExplusarUsuarioDesala( BuildContext context, idSala, idUsuario) async {
    explusar(context, idUsuario, idSala );
  }


  static explusar(BuildContext context, idUsuario, idSala){
      actions(BuildContext context) {
        return <Widget>[
          TextButton(
            onPressed: () {
              context.router.pop();
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              bool succeful = true;
              await CollecUser.COLECCION_USUARIOS
                  .doc(CurrentUser.getIdCurrentUser())
                  .collection('rolTutor')
                  .doc(CurrentUser.getIdCurrentUser())
                  .collection('salas')
                  .doc(idSala)
                  .collection('usersTutorados')
                  .doc(idUsuario)
                  .delete()
                  .catchError((onError) {
                succeful = false;
              }).then((value) async {
                await CollecUser.COLECCION_USUARIOS
                    .doc(idUsuario)
                    .collection('rolTutorado')
                    .doc(CurrentUser.getIdCurrentUser())
                    .update({
                  'salas_id': FieldValue.arrayRemove([idSala])
                });
              });
              context.router.pop();
            },
            child: Text('Ok'),
          ),
        ];
      }

      var titulo = const Text('Expulsar',
          textAlign: TextAlign.center);
      var message = const Text(
        '¿Deseas explusar este usuario de esta sala?',
        textAlign: TextAlign.center,
      );

      Dialogos.mostrarDialog(actions, titulo, message, context);

  }
}





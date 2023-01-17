import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:retos_proyecto/datos/Colecciones.dart';
import 'package:retos_proyecto/datos/UsuarioActual.dart';

import '../../../../../../widgets/Dialogs.dart';

class ExplusarDeSala {
  static Future<void> ExplusarUsuarioDesala( BuildContext context, idSala, idUsuario, idTutor, titulo, mensaje) async {
    explusar(context, idUsuario, idTutor, idSala, titulo, mensaje );
  }


  static explusar(BuildContext context, idUsuario, idTutor, idSala, titulo, mensaje){
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
              await Coleciones.COLECCION_USUARIOS
                  .doc(idTutor)
                  .collection('rolTutor')
                  .doc(idTutor)
                  .collection('salas')
                  .doc(idSala)
                  .collection('usersTutorados')
                  .doc(idUsuario)
                  .delete()
                  .catchError((onError) {
                succeful = false;
              }).then((value) async {
                await Coleciones.COLECCION_USUARIOS
                    .doc(idUsuario)
                    .collection('rolTutorado')
                    .doc(idTutor)
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


      Dialogos.mostrarDialog(actions, titulo, mensaje, context);

  }
}





import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:retos_proyecto/MenuNavigatioBar/Perfil/admin_usuarios/DejarTutoria.dart';

import '../../../MediaQuery.dart';
import '../../../datos/Colecciones.dart';
import '../../../datos/UsuarioActual.dart';
import '../../../widgets/Dialogs.dart';

class EliminarTutorado{


  static eliminarUserTutorado(BuildContext context, String idUserTutorado){
    dialogDejarTutoria(context, idUserTutorado);
  }



  //preguntar antes de dejar la tutoría
  static dialogDejarTutoria(BuildContext context, String idRemoveUser) {
    String titulo = 'Eliminar usuario';
   String mensaje = 'Los avances obtenidos en esta tutoría serán eliminados y no será posible recuperarlos';


    actions(BuildContext context){
      return <Widget>[
        TextButton(
          onPressed: () => context.router.pop(),
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () async {
            DejarTutoria.eliminarDeCurrentTutor(idRemoveUser);
            eliminarAvance(idRemoveUser);
            eliminarDeListaAllUsers(idRemoveUser);
            eliminarDeTodasSalas(idRemoveUser);
            context.router.pop();
          },
          child: Text('ok'),
        )
      ];
    }

    Dialogos.mostrarDialog(actions, titulo, mensaje, context);
  }




  static var usuarioTutor = CurrentUser.getIdCurrentUser();
  //Eliminar de la lista de todos los usuarios
  static Future<void> eliminarDeListaAllUsers(String idTutoro) async {
    await Coleciones.COLECCION_USUARIOS
        .doc(usuarioTutor)
        .collection('rolTutor')
        .doc(usuarioTutor)
        .collection('allUsersTutorados')
        .doc('usuarios_tutorados')
        .update({
      'idUserTotorado': FieldValue.arrayRemove([idTutoro])
    });
  }


  //Eliminar el avance del usuario
  static Future<void> eliminarAvance(idRemoveUser) async {
    await Coleciones.COLECCION_USUARIOS
        .doc(idRemoveUser)
        .collection('rolTutorado')
        .doc(usuarioTutor)
        .delete();
  }

  //Eliminar de todas las salas
  static Future<void> eliminarDeTodasSalas(idTutoro) async {
    await Coleciones.COLECCION_USUARIOS
        .doc(usuarioTutor)
        .collection('rolTutor')
        .doc(usuarioTutor)
        .collection('salas')
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        await element.reference
            .collection('usersTutorados')
            .doc(idTutoro)
            .delete();
      });
    });
  }
}
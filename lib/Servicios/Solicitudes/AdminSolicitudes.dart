import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:retos_proyecto/datos/CollecUsers.dart';
import 'package:retos_proyecto/datos/UsuarioActual.dart';

class Solicitudes {
//Apceptar solicitud-------------------------------------------------------------------------------------
  static aceptarSolicitud(
      String id_emisor,
      String id_sala,
      CollectionReference collectionReferenceUers,
      String? idCurrentUser,
      BuildContext context) async {
    await collectionReferenceUers
        .doc(idCurrentUser)
        .collection('rolTutorado')
        .doc(id_emisor.trim())
        .get()
        .then((value) async {
      if (value.exists) {
        await value.reference.update({
          'salas_id': FieldValue.arrayUnion([id_sala])
        });
        return;
      }
      //Si el usuario aun no esta bajo su tutoría
      await collectionReferenceUers
          .doc(idCurrentUser)
          .update({'current_tutor': id_emisor.trim()});
      await value.reference.set({
        'salas_id': FieldValue.arrayUnion([id_sala]),
        'puntosTotal': 0,
        'recompensa_x_200': {},
        'puntos_acumulados': 0
      });
    }).then((value) async => {
              await collectionReferenceUers
                  .doc(id_emisor)
                  .collection('rolTutor')
                  .doc(id_emisor)
                  .collection('salas')
                  .doc(id_sala)
                  .collection('usersTutorados')
                  .doc(idCurrentUser)
                  .set({'xxx': 0}).then((value) async => {
                        await addUser(
                            id_emisor, CurrentUser.getIdCurrentUser()),
                        await eliminarNotificacion(
                            id_sala,
                            collectionReferenceUers,
                            idCurrentUser,
                            context,
                            'aceptada')
                      })
            });
  }

  //Añadir el id del usuario del usuario a la lista de todos los usuarios tutorados
  static Future<void> addUser(String idTutor, idRemoveUser) async {
    var documentReference = CollecUser.COLECCION_USUARIOS
        .doc(idTutor)
        .collection('rolTutor')
        .doc(idTutor)
        .collection('allUsersTutorados')
        .doc('usuarios_tutorados');

    documentReference.update({
      'idUserTotorado': FieldValue.arrayUnion([idRemoveUser])
    }).catchError((onError){
      var error = onError.toString();

      if(error.contains('not-found')){
        documentReference.set({
          'idUserTotorado': FieldValue.arrayUnion([idRemoveUser])
        });
      };
    });
  }

//Eliminar solicitude------------------------------------------------------------------------------------
  static eliminarNotificacion(
      String id_sala,
      CollectionReference collectionReferenceUers,
      String? idCurrentUser,
      BuildContext context,
      String accion) async {
    var colorSnackBar = accion == 'aceptada' ? Colors.green : Colors.red;

    await collectionReferenceUers
        .doc(idCurrentUser)
        .collection('notificaciones')
        .doc(idCurrentUser)
        .collection('solicitudesRecibidas')
        .doc(id_sala)
        .delete()
        .then((value) async => {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: colorSnackBar,
                  content: Text('Solicitude $accion correctamente')))
            });
  }

  //Enviar solicitud-----------------------------------------------------------------------------------------
  static Future<bool> enviarSolicitud(String userName, String idSala) async {

    var resultadoFinal = false;

    await CollecUser.COLECCION_USUARIOS
        .where('nombre_usuario', isEqualTo: userName)
        .get()
        .then((resultado) async => {
              if (resultado.docs.length == 1)
                {
                  await resultado.docs[0].reference
                      .collection('notificaciones')
                      .doc(resultado.docs[0].id)
                      .collection('solicitudesRecibidas')
                      .doc(idSala)
                      .set({
                    'id_emisor': CurrentUser.getIdCurrentUser(),
                    'id_sala': idSala,
                    'nombre_emisor': CurrentUser.currentUser?.displayName
                  }).then((value) => {resultadoFinal = true}),
                }
              else
                {print("el usuario especificado no existe")}
            });

    return resultadoFinal;
  }
}

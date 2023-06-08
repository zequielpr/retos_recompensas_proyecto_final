import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ntp/ntp.dart';
import 'package:retos_proyecto/datos/Colecciones.dart';
import 'package:retos_proyecto/datos/UsuarioActual.dart';

import '../../recursos/DateActual.dart';

class Solicitudes {
//Apceptar solicitud-------------------------------------------------------------------------------------
  static aceptarSolicitud(
      DocumentSnapshot documentSnapshot,
      CollectionReference collectionReferenceUers,
      String? idCurrentUser,
      BuildContext context) async {
    cambiarStatdoSolicitud(documentSnapshot, 1);

    String id_emisor = documentSnapshot['id_emisor'];
    String id_sala = documentSnapshot['id_sala'];
    await addUserTutoria(id_emisor, id_sala, idCurrentUser!, context)
        .then((value) async {
      if (value) {
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
          await value.reference.set({
            'salas_id': FieldValue.arrayUnion([id_sala]),
            'puntosTotal': 0,
            'recompensa_x_200': {},
            'puntos_acumulados': 0
          });

          //Si el usuario aun no esta bajo su tutoría
          await collectionReferenceUers
              .doc(idCurrentUser)
              .update({'current_tutor': id_emisor.trim()});

        });
      }
    });
  }

  //Añadir usuario a la tutoría
  static Future<bool> addUserTutoria(String id_emisor, id_sala,
      String idCurrentUser, BuildContext context) async {
    try {
      DocumentReference sala = Coleciones.COLECCION_USUARIOS
          .doc(id_emisor)
          .collection('rolTutor')
          .doc(id_emisor)
          .collection('salas')
          .doc(id_sala);

      if ((await sala.get().then((value) => value.exists))) {
        await sala
            .collection('usersTutorados')
            .doc(idCurrentUser)
            .set({}).then((value) async => {
                  await addUser(id_emisor, CurrentUser.getIdCurrentUser()),
                });
        return true;
      }
      return false;
    } catch (e) {
      print('fallo$e');
      return false;
    }
  }

  //Añadir el id del usuario del usuario a la lista de todos los usuarios tutorados
  static Future<void> addUser(String idTutor, idRemoveUser) async {
    var documentReference = Coleciones.COLECCION_USUARIOS
        .doc(idTutor)
        .collection('rolTutor')
        .doc(idTutor)
        .collection('allUsersTutorados')
        .doc('usuarios_tutorados');

    documentReference.update({
      'idUserTotorado': FieldValue.arrayUnion([idRemoveUser])
    }).catchError((onError) {
      var error = onError.toString();

      if (error.contains('not-found')) {
        documentReference.set({
          'idUserTotorado': FieldValue.arrayUnion([idRemoveUser])
        });
      }
      ;
    });
  }

//Eliminar solicitude------------------------------------------------------------------------------------
  static cambiarStatdoSolicitud(DocumentSnapshot documentSnapshot, int nuevoStado) async {
    DateTime fechaActual = await DateActual.getActualDateTime();
    await documentSnapshot.reference.update({'estado':nuevoStado, 'fecha_actual': fechaActual});
  }

  //Enviar solicitud-----------------------------------------------------------------------------------------
  static Future<bool> enviarSolicitud(String userName, String idSala, String nombreSala) async {
    DateTime fechaActual = await DateActual.getActualDateTime();

    var resultadoFinal = false;

    await Coleciones.COLECCION_USUARIOS
        .where('nombre_usuario', isEqualTo: userName)
        .get()
        .then((resultado) async => {
              if (resultado.docs.length == 1)
                {
                  await Coleciones.NOTIFICACIONES
                      .doc('doc_nitificaciones')
                      .collection('solicitudes')
                      .doc()
                      .set({
                    'id_emisor': CurrentUser.getIdCurrentUser(),
                    'id_sala': idSala,
                    'nombre_emisor': CurrentUser.currentUser?.displayName,
                    'id_destinatario': resultado.docs.first.id,
                    'fecha_actual': fechaActual,
                    'estado': 0,
                    'nombre_sala': nombreSala
                  }).then((value) => resultadoFinal = true),

                  /*await resultado.docs[0].reference
                      .collection('notificaciones')
                      .doc(resultado.docs[0].id)
                      .collection('solicitudesRecibidas')
                      .doc(idSala)
                      .set({
                    'id_emisor': CurrentUser.getIdCurrentUser(),
                    'id_sala': idSala,
                    'nombre_emisor': CurrentUser.currentUser?.displayName
                  }).then((value) => {resultadoFinal = true}),*/
                }
              else
                {print("el usuario especificado no existe")}
            });

    return resultadoFinal;
  }
}

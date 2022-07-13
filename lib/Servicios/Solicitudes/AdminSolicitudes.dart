import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
        .then((value) => {
              value.exists
                  ? value.reference.update({
                      'salas_id': FieldValue.arrayUnion([id_sala])
                    })
                  : value.reference.set({
                      'salas_id': FieldValue.arrayUnion([id_sala])
                    })
            })
        .then((value) async => {
              await collectionReferenceUers
                  .doc(id_emisor)
                  .collection('rolTutor')
                  .doc(id_sala)
                  .collection('usersTutorados')
                  .doc(idCurrentUser)
                  .set({'puntosTotal': 0}).then((value) async => {
                        await eliminarNotificacion(
                            id_sala,
                            collectionReferenceUers,
                            idCurrentUser,
                            context,
                            'aceptada')
                      })
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
  static Future<bool> enviarSolicitud(String userName,
      CollectionReference collectionReferenceUsers, String idSala) async {

    var resultadoFinal = false;

    User? currentUser = FirebaseAuth.instance.currentUser;

    await collectionReferenceUsers
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
                    'id_emisor': currentUser?.uid.trim(),
                    'id_sala': idSala,
                    'nombre_emisor': currentUser?.displayName
                  }).then((value) => {resultadoFinal = true}),
                }
              else
                {print("el usuario especificado no existe")}
            });

    return resultadoFinal;
  }
}

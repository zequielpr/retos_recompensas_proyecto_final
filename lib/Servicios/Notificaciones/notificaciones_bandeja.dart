import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:retos_proyecto/MenuNavigatioBar/Perfil/cambiar_tutor_actual.dart';
import 'package:retos_proyecto/datos/Colecciones.dart';
import 'package:retos_proyecto/datos/Roll_Data.dart';
import 'package:retos_proyecto/recursos/DateActual.dart';
import '../../MenuNavigatioBar/Perfil/admin_usuarios/Admin_tutores.dart';
import '../../widgets/Cards.dart';
import '../Solicitudes/AdminSolicitudes.dart';

//Nueva bandeja de notificaciones---------------------------------------------------------------------------------
class BandejaNotificaciones {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static User? currentUser = auth.currentUser;
  static String? idCurrentUser = currentUser?.uid;

  static Widget getBandejaNotificaciones(
      CollectionReference collectionReference, BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'Misiones',
              ),
              Tab(
                text: 'Solicitudes',
              ),
            ],
          ),
          toolbarHeight: 2,
        ),
        body: TabBarView(
          children: [
            getMisiones(collectionReference),
            getSolicitudesRecibidas(collectionReference, context),
          ],
        ),
      ),
    );
  }

  //Obtener las solicitudes recibidas------------------------------------------------------------------
  static Widget getSolicitudesRecibidas(
      CollectionReference collectionReference, BuildContext context) {
    CollectionReference notificacionesRecibidas = Coleciones.NOTIFICACIONES
        .doc('doc_nitificaciones')
        .collection('solicitudes');

    return StreamBuilder(
      stream: notificacionesRecibidas.where(
          Roll_Data.ROLL_USER_IS_TUTORADO ? 'id_destinatario' : 'id_emisor',
          isEqualTo: idCurrentUser).orderBy('fecha_actual', descending: true)
    .snapshots(),
      builder: (cxt_stream, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (streamSnapshot.data?.docs.isEmpty == true) {
          return const Center(
            child: Text('Aun no tienes solicitudes'),
          );
        }

        if (streamSnapshot.hasData) {
          return ListView.builder(
            itemCount: streamSnapshot.data!.docs.length,
            itemBuilder: (ctx_lista, index) {
              final DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[index];
              if (Roll_Data.ROLL_USER_IS_TUTORADO &&
                  documentSnapshot['estado'] == 0) {
                return Cards.getCardSolicitud(documentSnapshot,
                    collectionReference, idCurrentUser, context);
              }
              return Column(children: [
                Cards.getStadoSolicitud(
                    documentSnapshot, context, documentSnapshot['estado']),
              Divider(height: 0, thickness: 0.5,)
              ],);

            },
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  //Obtener las misiones recibidas------------------------------------------------------------------
  static Widget getMisiones(CollectionReference collectionReference) {
    CollectionReference notificacionesRecibidas = Coleciones.NOTIFICACIONES
        .doc('doc_nitificaciones')
        .collection('misiones_recibidas');

    return StreamBuilder(
      stream: notificacionesRecibidas.where('id_emisor', isEqualTo: UsuarioTutores.tutorActual)
          .orderBy('fecha_actual', descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (streamSnapshot.data?.docs.isEmpty == true) {
          return const Center(
            child: Text('Aun no tienes misiones'),
          );
        }

        if (streamSnapshot.hasData) {
          return ListView.builder(
            itemCount: streamSnapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[index];
              return Column(children: [Cards.cardNotificacionMisiones(documentSnapshot, context), Divider(height: 0, thickness: 0.5,)],);
            },
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

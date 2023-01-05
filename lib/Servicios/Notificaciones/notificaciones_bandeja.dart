import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
    CollectionReference notificacionesRecibidas = collectionReference
        .doc(idCurrentUser)
        .collection('notificaciones')
        .doc(idCurrentUser)
        .collection('solicitudesRecibidas');

    return StreamBuilder(
      stream: notificacionesRecibidas.snapshots(),
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
              return Cards.getCardSolicitud(documentSnapshot,
                  collectionReference, idCurrentUser, context);
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
    CollectionReference notificacionesRecibidas = collectionReference
        .doc(idCurrentUser)
        .collection('notificaciones')
        .doc(idCurrentUser)
        .collection('misiones_recibidas');

    return StreamBuilder(
      stream: notificacionesRecibidas.orderBy('fecha', descending: true).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(),);
        }

        if(streamSnapshot.data?.docs.isEmpty == true){
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
              return Cards.cardNotificacionMisiones(documentSnapshot, context);
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

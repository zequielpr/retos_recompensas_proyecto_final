import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:retos_proyecto/MenuNavigatioBar/Perfil/cambiar_tutor_actual.dart';
import 'package:retos_proyecto/datos/Colecciones.dart';
import 'package:retos_proyecto/datos/Roll_Data.dart';
import 'package:retos_proyecto/datos/UsuarioActual.dart';
import 'package:retos_proyecto/recursos/DateActual.dart';
import '../../MenuNavigatioBar/Perfil/admin_usuarios/Admin_tutores.dart';
import '../../widgets/Cards.dart';
import '../Solicitudes/AdminSolicitudes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

//Nueva bandeja de notificaciones---------------------------------------------------------------------------------
class BandejaNotificaciones {
  static final User? _currentUser = CurrentUser.currentUser;
  static final String? _idCurrentUser = _currentUser?.uid;
  static final CollectionReference _collectionReference = Coleciones.COLECCION_USUARIOS;
  BuildContext _context;
  AppLocalizations? _valores;

  BandejaNotificaciones(this._context, this._valores);

  Widget getBandejaNotificaciones() {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom:  TabBar(
            tabs: [
              Tab(
                text: _valores?.misiones,
              ),
              Tab(
                text: _valores?.solicitudes,
              ),
            ],
          ),
          toolbarHeight: 2,
        ),
        body: TabBarView(
          children: [
            _getMisiones(),
            _getSolicitudesRecibidas(),
          ],
        ),
      ),
    );
  }

  //Obtener las solicitudes recibidas------------------------------------------------------------------
  Widget _getSolicitudesRecibidas() {
    CollectionReference notificacionesRecibidas = Coleciones.NOTIFICACIONES
        .doc('doc_nitificaciones')
        .collection('solicitudes');

    return StreamBuilder(
      stream: notificacionesRecibidas.where(
          Roll_Data.ROLL_USER_IS_TUTORADO ? 'id_destinatario' : 'id_emisor',
          isEqualTo: _idCurrentUser).orderBy('fecha_actual', descending: true)
    .snapshots(),
      builder: (cxt_stream, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (streamSnapshot.data?.docs.isEmpty == true) {
          return  Center(
            child: Text(_valores?.aun_no_solicitudes as String),
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
                    _collectionReference, _idCurrentUser, _context);
              }
              return Column(children: [
                Cards.getStadoSolicitud(
                    documentSnapshot, _context, documentSnapshot['estado']),
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
  Widget _getMisiones() {
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
          return Center(
            child: Text(_valores?.aun_no_misiones as String),
          );
        }

        if (streamSnapshot.hasData) {
          return ListView.builder(
            itemCount: streamSnapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[index];
              return Column(children: [Cards.cardNotificacionMisiones(documentSnapshot, context), const Divider(height: 0, thickness: 0.5,)],);
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

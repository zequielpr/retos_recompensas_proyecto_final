import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retos_proyecto/datos/Colecciones.dart';
import 'package:retos_proyecto/datos/UsuarioActual.dart';

class BadgeNotificaciones {
  static void isNewNotifications(mostrarBadge) {
    CollectionReference collectionReferenceUser = Coleciones.COLECCION_USUARIOS;

    bool isNewMisiones;
    collectionReferenceUser
        .doc(CurrentUser.getIdCurrentUser())
        .collection('notificaciones')
        .doc(CurrentUser.getIdCurrentUser())
        .snapshots()
        .listen((event) {
          if(event.data()!['nueva_mision'] || event.data()!['nueva_solicitud']){
            var numb_notificaciones = event.data()!['numb_misiones'] + event.data()!['numb_solicitudes'];
            mostrarBadge(true, numb_notificaciones);
          }else{
            mostrarBadge(false, 0);
          }
    });
  }

  ///actualilzar cantidad de misiones nuevas
  static void setStatusNewMision(){
    Coleciones.COLECCION_USUARIOS
        .doc(CurrentUser.getIdCurrentUser())
        .collection('notificaciones')
        .doc(CurrentUser.getIdCurrentUser()).update({'numb_misiones': 0, 'nueva_mision': false});


    print('hola');
    Coleciones.COLECCION_USUARIOS
        .doc(CurrentUser.getIdCurrentUser())
        .collection('notificaciones')
        .doc(CurrentUser.getIdCurrentUser()).update({'numb_solicitudes': 0, 'nueva_solicitud': false});
  }
}

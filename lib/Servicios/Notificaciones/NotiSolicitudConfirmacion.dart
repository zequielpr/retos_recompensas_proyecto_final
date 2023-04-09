import 'package:retos_proyecto/MenuNavigatioBar/Perfil/admin_usuarios/Admin_tutores.dart';
import 'package:retos_proyecto/datos/Colecciones.dart';
import 'package:retos_proyecto/datos/UsuarioActual.dart';
import 'package:retos_proyecto/recursos/DateActual.dart';


class NotiSolicitudConfirmacion {
  static Future<void> setNotiSolicitudNotificacion(String nombre_mision, String nombreSala) async {
    DateTime fechaActual = await DateActual.getActualDateTime();

    await Coleciones.NOTIFICACIONES
        .doc('doc_nitificaciones')
        .collection('confirm_mision_solicitud')
        .doc()
        .set({
      'fecha_actual': fechaActual,
      "id_tutor": UsuarioTutores.tutorActual,
      "nombre_mision": nombre_mision,
      "nombre_sala": nombreSala,
      "nombre_tutorado": CurrentUser.currentUser?.displayName,
      "id_emisor": CurrentUser.getIdCurrentUser()
    });
  }
}

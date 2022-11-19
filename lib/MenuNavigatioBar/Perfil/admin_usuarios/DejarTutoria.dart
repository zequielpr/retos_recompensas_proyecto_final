import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retos_proyecto/datos/CollecUsers.dart';
import 'package:retos_proyecto/datos/UsuarioActual.dart';

class DejarTutoria {


  static eliminarTutor(String idTutor){
    eliminarDeCurrentTutor();
    eliminarAvance(idTutor);
    eliminarDeListaAllUsers(idTutor);
    eliminarDeTodasSalas(idTutor);

  }


  //eliminar id el usuario tutor
  static Future<void> eliminarDeCurrentTutor() async {
    await CollecUser.COLECCION_USUARIOS
        .doc(CurrentUser.getIdCurrentUser())
        .update({"current_tutor": ''});
  }

  //Eliminar avance otenido con el tutor
  static Future<void> eliminarAvance(idTutor) async {
    await CollecUser.COLECCION_USUARIOS
        .doc(CurrentUser.getIdCurrentUser())
        .collection('rolTutorado')
        .doc(idTutor)
        .delete();
  }

  //Eliminar de la lista de todos los usarios tutorados
  static Future<void> eliminarDeListaAllUsers(String idTutor) async {
    await CollecUser.COLECCION_USUARIOS
        .doc(idTutor)
        .collection('rolTutor')
        .doc(idTutor)
        .collection('allUsersTutorados')
        .doc('usuarios_tutorados')
        .update({ 'idUserTotorado': FieldValue.arrayRemove([CurrentUser.getIdCurrentUser()])});
  }

  //Eliminar de todas las salas en las que se encuentre
  static Future<void> eliminarDeTodasSalas(idTutor)async{
    await CollecUser.COLECCION_USUARIOS
        .doc(idTutor)
        .collection('rolTutor')
        .doc(idTutor)
        .collection('salas').get().then((value){
          value.docs.forEach((element) async{
           await element.reference.collection('usersTutorados').doc(CurrentUser.getIdCurrentUser()).delete();
          });
    });
  }
}

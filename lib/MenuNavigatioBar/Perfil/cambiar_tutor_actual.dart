import 'package:flutter/material.dart';
import 'package:retos_proyecto/datos/CollecUsers.dart';
import 'package:retos_proyecto/datos/UsuarioActual.dart';

import '../../datos/Roll_Data.dart';
import 'admin_usuarios/Admin_tutores.dart';
import 'admin_usuarios/admin_tutorados.dart';

class TutorActual {
  static Future<void> setNewActualTutor(String idTutor) async {
    await CollecUser.COLECCION_USUARIOS
        .doc(CurrentUser.getIdCurrentUser())
        .update({'current_tutor': idTutor});
  }
}

class MostrarTutorActual extends StatefulWidget {
  const MostrarTutorActual({Key? key}) : super(key: key);

  @override
  State<MostrarTutorActual> createState() => _MostrarTutorActualState();
}

class _MostrarTutorActualState extends State<MostrarTutorActual> {
  void initCurrentTutor(currentTutor) {
    setState(() {});
  }

  void initState() {
    if (Roll_Data.ROLL_USER_IS_TUTORADO) {
      UsuarioTutores.setCurrentUser(initCurrentTutor);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Roll_Data.ROLL_USER_IS_TUTORADO
        ? UsuarioTutores.getAllTutores()
        : Admin_tutorados.getAllUser(context);
    ;
  }
}

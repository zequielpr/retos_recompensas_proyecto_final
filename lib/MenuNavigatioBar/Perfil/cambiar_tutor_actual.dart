import 'package:flutter/material.dart';
import 'package:retos_proyecto/datos/Colecciones.dart';
import 'package:retos_proyecto/datos/UsuarioActual.dart';

import '../../datos/Roll_Data.dart';
import 'admin_usuarios/Admin_tutores.dart';
import 'admin_usuarios/admin_tutorados.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TutorActual {
  static Future<void> setNewActualTutor(String idTutor) async {
    await Coleciones.COLECCION_USUARIOS
        .doc(CurrentUser.getIdCurrentUser())
        .update({'current_tutor': idTutor});
  }
}

class MostrarUsuarios extends StatefulWidget {
  const MostrarUsuarios({Key? key}) : super(key: key);

  @override
  State<MostrarUsuarios> createState() => _MostrarUsuariosState();
}

class _MostrarUsuariosState extends State<MostrarUsuarios> {
  AppLocalizations? valores;
  @override
  Widget build(BuildContext context) {
    valores = AppLocalizations.of(context);
    return Roll_Data.ROLL_USER_IS_TUTORADO
        ? UsuarioTutores.getAllTutores(valores)
        : Admin_tutorados.getAllUser(valores);
  }
}

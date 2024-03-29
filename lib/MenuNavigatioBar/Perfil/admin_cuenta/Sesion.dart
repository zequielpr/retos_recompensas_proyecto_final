import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:retos_proyecto/Rutas.gr.dart';

import '../../../recursos/MediaQuery.dart';
import '../../../widgets/Dialogs.dart';
import '../AdminRoles.dart';

class Sesion {
  static dialogCerrarSesion(BuildContext context, espararCerrarSesion, AppLocalizations? valores) {
    var titulo ='${valores?.cerrar_sesion}';
    var mensaje ='${valores?.desea_cerrar_sesion}';

    List<TextButton> actions(BuildContext context) {
      return [
        TextButton(
          onPressed: () => context.router.pop(),
          child: Text('No'),
        ),
        TextButton(
          onPressed: () => cerrarSesion(context, espararCerrarSesion),
          child: Text('Ok'),
        )
      ];
    }

    Dialogos.mostrarDialog(actions, titulo, mensaje, context);
  }

  static Future<void> cerrarSesion(BuildContext context, espararCerrarSesion) async {
    espararCerrarSesion(true);
    await FirebaseAuth.instance.signOut().then((value) async =>
        {await _p(), context.router.replace(SplashScreenRouter())}).whenComplete(() => espararCerrarSesion(false));
  }

  static Future<void> _p() async {
    try {
      await GoogleSignIn().disconnect();
    } catch (e) {}
  }
}

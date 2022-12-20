import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:retos_proyecto/MenuNavigatioBar/Perfil/admin_cuenta/Sesion.dart';
import 'package:retos_proyecto/datos/UsuarioActual.dart';
import 'package:retos_proyecto/widgets/Dialogs.dart';

import '../../../MediaQuery.dart';

class EliminarCuenta {
  static eliminarCuenta(BuildContext context) {
    var title = const Text('Eliminar cuenta', textAlign: TextAlign.center);
    var message = const Text(
      'Al eliminar tu cuenta no será posible recuperar tus datos',
      textAlign: TextAlign.center,
    );

    preguntarEliminarCuenta(title, message, context);
  }

  static preguntarEliminarCuenta(titulo, mensaje, BuildContext context) {
    List<Widget> actions(BuildContext context) {
      return <Widget>[
        TextButton(
            onPressed: () => context.router.pop(), child: Text('Cancelar')),
        TextButton(
          onPressed: () async =>
              await CurrentUser.currentUser?.delete().catchError((onError) {
            var error = onError.toString();

            if (error.contains('requires-recent-login')) {

              var title = const Text('Eliminar cuenta', textAlign: TextAlign.center);
              var message = const Text(
                'Inicio de session necesario',
                textAlign: TextAlign.center,
              );
              mostrarExepcion(title, message, context);
            }
          }).then((value) => Sesion.cerrarSesion(context)),
          child: Text('Ok'),
        ),
      ];
    }

    Dialogos.mostrarDialog(actions, titulo, mensaje, context);
  }

  static mostrarExepcion(titulo, mensaje, BuildContext context) {
    action() {
      return <Widget>[
        TextButton(
            onPressed: () => context.router.pop(), child: Text('Cancelar')),
      ];
    }

    Dialogos.mostrarDialog(action, titulo, mensaje, context);
  }
}

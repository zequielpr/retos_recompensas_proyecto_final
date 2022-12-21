import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:retos_proyecto/MenuNavigatioBar/Perfil/admin_cuenta/Sesion.dart';
import 'package:retos_proyecto/datos/UsuarioActual.dart';
import 'package:retos_proyecto/widgets/Dialogs.dart';

import '../../../MediaQuery.dart';

class EliminarCuenta {
  static eliminarCuenta(BuildContext context) {
    String title = 'Eliminar cuenta';
    String message =
        'Al eliminar tu cuenta no será posible recuperar tus datos';

    preguntarEliminarCuenta(title, message, context);
  }

  static preguntarEliminarCuenta(titulo, mensaje, BuildContext context) {
    List<Widget> actions(BuildContext context) {
      return <Widget>[
        TextButton(
            onPressed: () => context.router.pop(), child: Text('Cancelar')),
        TextButton(
          onPressed: () async {
            try{

              await CurrentUser.currentUser?.delete();
              Sesion.cerrarSesion(context);
            }catch(e){
              if (e.toString().contains('requires-recent-login')) {
                String title = 'Eliminar cuenta';
                String message = 'Cierra e inicia sesion para realizar esta acción';
                await context.router.pop().then((value) => mostrarExepcion(title, message, context));
                
              }
            }
          },
          child: Text('Ok'),
        ),
      ];
    }

    Dialogos.mostrarDialog(actions, titulo, mensaje, context);
  }

  static mostrarExepcion(titulo, mensaje, BuildContext context) {
    
    action(BuildContext context) {
      return <Widget>[
        TextButton(
          onPressed: () {
            context.router.pop();
          },
          child: const Text('Ok'),
        ),
      ];
    }

    Dialogos.mostrarDialog(action, titulo, mensaje, context);
  }
}

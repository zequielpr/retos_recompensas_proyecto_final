import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:retos_proyecto/MenuNavigatioBar/Perfil/admin_cuenta/Sesion.dart';
import 'package:retos_proyecto/datos/UsuarioActual.dart';

import '../../../MediaQuery.dart';

class EliminarCuenta {
  static eliminarCuenta(BuildContext context){
   var title = const Text('Eliminar cuenta', textAlign: TextAlign.center);
    var message = const Text(
      'Al eliminar tu cuenta no será posible recuperar tus datos',
      textAlign: TextAlign.center,
    );

    preguntarEliminarCuenta(title, message, context);
  }

  static preguntarEliminarCuenta(titulo, mensaje, BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        titlePadding: EdgeInsets.only(
            left: Pantalla.getPorcentPanntalla(3, context, 'x'),
            top: Pantalla.getPorcentPanntalla(3, context, 'x'),
            bottom: Pantalla.getPorcentPanntalla(1, context, 'x')),
        alignment: Alignment.center,
        actionsAlignment: MainAxisAlignment.center,
        buttonPadding: EdgeInsets.all(0),
        actionsPadding:
            EdgeInsets.only(top: Pantalla.getPorcentPanntalla(0, context, 'x')),
        contentPadding: EdgeInsets.only(
            left: Pantalla.getPorcentPanntalla(3, context, 'x'),
            right: Pantalla.getPorcentPanntalla(3, context, 'x')),
        title: titulo,
        content: mensaje,
        actions: <Widget>[
          TextButton(onPressed: ()=>context.router.pop(), child: Text('Cancelar')),
          TextButton(
            onPressed: () async => await CurrentUser.currentUser
                ?.delete().catchError((onError){
                  var error = onError.toString();

                  if(error.contains('requires-recent-login')){

                  }
            })
                .then((value) => Sesion.cerrarSesion(context)),
            child: Text('Ok'),
          ),
        ],
      ),
    );
  }
}

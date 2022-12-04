import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:retos_proyecto/datos/UsuarioActual.dart';

import '../../MediaQuery.dart';
import '../../datos/CollecUsers.dart';
import '../../datos/Roll_Data.dart';

class AdminRoll {
  static Widget getRoll(BuildContext context) {
    var dropdownValue = Roll_Data.ROLL_USER_IS_TUTORADO ? 'Tutorado' : 'Tutor';
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      const Text('', style: TextStyle(fontSize: 20)),
      DropdownButton<String>(
        value: dropdownValue,
        icon: const Padding(
          padding: EdgeInsets.only(left: 5),
          child: Icon(Icons.arrow_drop_down),
        ),
        elevation: 1,
        style: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),
        underline: Container(
          height: 0,
        ),
        onChanged: (newValor) {
          changeRoll(newValor, context);
        },
        items: <String>['Tutorado', 'Tutor']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      )
    ]);
  }

  static Future<void> changeRoll(rol_tutorado, BuildContext context) async {
    var actions = <Widget>[
      TextButton(
        onPressed: () {
          context.router.pop();
        },
        child: const Text('No'),
      ),
      TextButton(
        onPressed: () async {
          var rol = rol_tutorado == 'Tutorado' ? true : false;
          await (CollecUser.COLECCION_USUARIOS
                  .doc(CurrentUser.getIdCurrentUser())
                  .update({'rol_tutorado': rol}))
              .catchError((onError) {})
              .then((value) {});
          SystemNavigator.pop(animated: true);
        },
        child: Text('Ok'),
      ),
    ];
    var titulo = const Text('Cambiar Rol', textAlign: TextAlign.center);
    var message = const Text(
      'Desea cambiar de rol? \n al cambiar de rol se reiniciara la aplicación',
      textAlign: TextAlign.center,
    );
    showMessaje(actions, titulo, message, context);
  }

  static showMessaje(actions, titulo, mensaje, BuildContext context) {
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
        actions: actions,
      ),
    );
  }


}

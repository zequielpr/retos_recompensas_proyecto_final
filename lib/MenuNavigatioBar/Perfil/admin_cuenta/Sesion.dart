import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:retos_proyecto/Rutas.gr.dart';

import '../../../MediaQuery.dart';
import '../AdminRoles.dart';

class Sesion{

  static dialogCerrarSesion(BuildContext context) {
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
        title: Text('Cerrar sesión', textAlign: TextAlign.center),
        content: const Text(
          '¿Desea cerrar sesión?',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => context.router.pop(),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: ()=> cerrarSesion(context) ,
            child: Text('Cerrar sesión'),
          )
        ],
      ),
    );;
  }

  static Future<void>cerrarSesion(BuildContext context)async {
    await FirebaseAuth.instance.signOut().then((value) async =>
    {await _p(), context.router.replace(SplashScreenRouter())});
  }


  static Future<void> _p() async {
    try {
      await GoogleSignIn().disconnect();
    } catch (e) {}
  }
}
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:retos_proyecto/datos/CollecUsers.dart';
import 'package:retos_proyecto/datos/DatosPersonalUser.dart';
import 'package:retos_proyecto/datos/Roll_Data.dart';
import 'package:retos_proyecto/datos/UsuarioActual.dart';

import 'AdminRoles.dart';

class AdminPerfilUser extends StatefulWidget {
  const AdminPerfilUser({Key? key}) : super(key: key);

  @override
  State<AdminPerfilUser> createState() => _AdminPerfilUserState();
}

class _AdminPerfilUserState extends State<AdminPerfilUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('adminPerfil'),
      ),
      body: Column(children: <Widget>[
        ListTile(
          leading: DatosPersonales.getAvatar(CollecUser.COLECCION_USUARIOS,
              CurrentUser.getIdCurrentUser(), 30),
          title: DatosPersonales.getDato(CollecUser.COLECCION_USUARIOS,
              CurrentUser.getIdCurrentUser(), 'nombre'),
          subtitle: DatosPersonales.getDato(CollecUser.COLECCION_USUARIOS,
              CurrentUser.getIdCurrentUser(), 'nombre_usuario'),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20, top: 10),
          child: Align(
            alignment: Alignment.topLeft,
            child: AdminRoll.getRoll(context),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20, top: 10),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(CurrentUser.currentUser?.email as String,
                style: TextStyle(fontSize: 20)),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20, top: 24),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Cambiar Contraseña',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20, top: 10),
          child: Align(
            alignment: Alignment.topLeft,
            child: ElevatedButton(
                onPressed: () async {
                  //print(FirebaseAuth.instance.currentUser?.providerData);

                  await FirebaseAuth.instance.signOut().then((value) async => {
                        await _p(),
                        context.router.replaceNamed('/EsplashScreen')
                      });
                },
                child: Text("Cerrar sesión")),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20, top: 24),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Eliminar cuenta',
              style: TextStyle(fontSize: 20),
            ),
          ),
        )
      ]),
    );
    ;
  }

  static Future<void> _p() async {
    try {
      await GoogleSignIn().disconnect();
    } catch (e) {}
  }
}

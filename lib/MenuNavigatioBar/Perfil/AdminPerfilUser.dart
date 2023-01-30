import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:retos_proyecto/MediaQuery.dart';
import 'package:retos_proyecto/Rutas.gr.dart';
import 'package:retos_proyecto/datos/Colecciones.dart';
import 'package:retos_proyecto/datos/DatosPersonalUser.dart';
import 'package:retos_proyecto/datos/Roll_Data.dart';
import 'package:retos_proyecto/datos/UsuarioActual.dart';

import '../../Servicios/Autenticacion/NombreUsuario.dart';
import 'AdminRoles.dart';
import 'admin_cuenta/change_password.dart';
import 'admin_usuarios/Admin_tutores.dart';
import 'admin_usuarios/admin_tutorados.dart';
import 'cambiar_tutor_actual.dart';
import 'menu/menu_admin_perfil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AdminPerfilUser extends StatefulWidget {
  const AdminPerfilUser({Key? key}) : super(key: key);

  @override
  State<AdminPerfilUser> createState() => _AdminPerfilUserState();
}

class _AdminPerfilUserState extends State<AdminPerfilUser> {
  static var editEmailController = TextEditingController();
  AppLocalizations? valores;

  static bool editandoAtributos = false;
  static var actualizarAppBar;
  static var cerrarTextField;
  static var actualizarCuerpo;
  static var actualizarStateUsername;

  @override
  void initState() {
    CurrentUser.currentUser?.reload();
    CurrentUser.setCurrentUser();
    // TODO: implement initState
    NombreUsuarioWidget.vistaPerfil = setState;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    valores = AppLocalizations.of(context);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(valores?.perfil as String),
          actions: [
            IconButton(
              onPressed: () => MenuOption.getMenuOption(context, valores),
              icon: const Icon(Icons.menu),
            )
          ],
          bottom: PreferredSize(
            preferredSize:
                Size.fromHeight(Pantalla.getPorcentPanntalla(19, context, 'y')),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: Pantalla.getPorcentPanntalla(2, context, 'y'),
                ),
                ListTile(
                  leading: DatosPersonales.getAvatar(
                      CurrentUser.getIdCurrentUser(), 30),
                  title: Text(CurrentUser.currentUser?.displayName as String, style: TextStyle(fontSize: 25),),
                  subtitle: DatosPersonales.getDato(
                      CurrentUser.getIdCurrentUser(), 'nombre_usuario', TextStyle()),
                ),
                rolActual(),
              ],
            ),
          ),
        ),
        body: MostrarUsuarios());
  }

  Widget rolActual() {
    //________________
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      void actualizarVista() {
        setState(() {});
      }

      actualizarCuerpo = actualizarVista;

      //Contenidos____________________________
      return Column(
        children: [
          verRoll(),
        ],
      );
    });
  }

  Widget verRoll() {
    return Padding(
      padding: EdgeInsets.only(left: 20),
      child: Align(
        alignment: Alignment.topLeft,
        child: AdminRoll.getRoll(context, valores),
      ),
    );
  }
}

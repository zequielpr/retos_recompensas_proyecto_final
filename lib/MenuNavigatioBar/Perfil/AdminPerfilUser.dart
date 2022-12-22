import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:retos_proyecto/MediaQuery.dart';
import 'package:retos_proyecto/Rutas.gr.dart';
import 'package:retos_proyecto/datos/CollecUsers.dart';
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

class AdminPerfilUser extends StatefulWidget {
  const AdminPerfilUser({Key? key}) : super(key: key);

  @override
  State<AdminPerfilUser> createState() => _AdminPerfilUserState();
}

class _AdminPerfilUserState extends State<AdminPerfilUser> {
  static var editEmailController = TextEditingController();

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
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Perfil'),
          actions: [
            IconButton(
              onPressed: () => MenuOption.getMenuOption(context),
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
                  title: Text(CurrentUser.currentUser?.displayName as String),
                  subtitle: DatosPersonales.getDato(
                      CurrentUser.getIdCurrentUser(), 'nombre_usuario'),
                ),
                //_editarPerfil(),
                rolActual(),

                //_email(),
                //adminPassw(),
                //cerrarSesion(),
                //eliminarCuenta()
              ],
            ),
          ),
        ),
        body: MostrarUsuarios());
  }

  Widget _editarPerfil() {
    return Padding(
      padding: EdgeInsets.only(left: 20, top: 10),
      child: Align(
        alignment: Alignment.topLeft,
        child: TextButton(
          style: ButtonStyle(
              padding:
                  MaterialStateProperty.all(const EdgeInsets.only(left: 0))),
          child: const Text(
            'Editar perfil',
            style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.normal),
          ),
          onPressed: () => context.router.push(const EditarPerfilRouter()),
        ),
      ),
    );
  }

  Widget _email() {
    return Padding(
      padding: EdgeInsets.only(left: 20, top: 10),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(CurrentUser.currentUser?.email as String,
            style: const TextStyle(fontSize: 20)),
      ),
    );
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
        child: AdminRoll.getRoll(context),
      ),
    );
  }

  //Administrar contraseña
  Widget adminPassw() {
    return Padding(
      padding: EdgeInsets.only(left: 20, top: 10),
      child: Align(
        alignment: Alignment.topLeft,
        child: TextButton(
          style: ButtonStyle(
              padding:
                  MaterialStateProperty.all(const EdgeInsets.only(left: 0))),
          onPressed: () {
            context.router.pushWidget(ChangePasswd(contextPerfil: context));
          },
          child: const Text(
            'Cambiar Contraseña',
            style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.normal),
          ),
        ),
      ),
    );
  }

  //Cerrar sesión

  //Eliminar cuenta
  Widget eliminarCuenta() {
    return Padding(
      padding: EdgeInsets.only(left: 20, top: 17),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          'Eliminar cuenta',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  Widget virificarEmail() {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: TextButton(
          style: ButtonStyle(
              padding:
                  MaterialStateProperty.all(const EdgeInsets.only(left: 0))),
          onPressed: () => enviarLinkDevificacion(),
          child: Text(
            "Verificar email",
            style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.normal),
          ),
        ),
      ),
    );
  }

  void enviarLinkDevificacion() {
    (CurrentUser.currentUser?.sendEmailVerification())
        ?.catchError((onError) {})
        .then((value) {
      var actions = <Widget>[
        TextButton(
          onPressed: () {
            context.router.pop();
          },
          child: const Text('Ok'),
        ),
      ];

      var titulo = 'Link enviado';
      var message = 'Abra el email enviado a ${CurrentUser.currentUser?.email} para virificar tu email';

      AdminRoll.showMessaje(actions, titulo, message, context);
    });
  }
}

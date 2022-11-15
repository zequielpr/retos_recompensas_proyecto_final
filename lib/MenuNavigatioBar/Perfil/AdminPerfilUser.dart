import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:retos_proyecto/MediaQuery.dart';
import 'package:retos_proyecto/MenuNavigatioBar/Perfil/AdminTutores.dart';
import 'package:retos_proyecto/MenuNavigatioBar/Perfil/ChangePasswd.dart';
import 'package:retos_proyecto/Rutas.gr.dart';
import 'package:retos_proyecto/datos/CollecUsers.dart';
import 'package:retos_proyecto/datos/DatosPersonalUser.dart';
import 'package:retos_proyecto/datos/Roll_Data.dart';
import 'package:retos_proyecto/datos/UsuarioActual.dart';

import 'AdminRoles.dart';
import 'admin_usuarios/Admin_tutores.dart';
import 'admin_usuarios/admin_tutorados.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Perfil'),
        actions: [
          IconButton(
            onPressed: () =>  MenuOption.getMenuOption(context),
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
                title: DatosPersonales.getDato(
                    CurrentUser.getIdCurrentUser(), 'nombre'),
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
      body:  Roll_Data.ROLL_USER_IS_TUTORADO? UsuarioTutores.getAllTutores(): Admin_tutorados.getAllUser(context),
    );
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
         /* Roll_Data.ROLL_USER_IS_TUTORADO
              ? adminTutores(actualizarVista)
              : Text(
                  '',
                  style: TextStyle(fontSize: 0),
                ),*/

          CurrentUser.currentUser?.emailVerified == true
              ? Text(
                  '',
                  style: TextStyle(fontSize: 0),
                )
              : virificarEmail(),
        ],
      );
    });
  }

  //Preguntar antes de cambiar email_________________________________________
  void preguntar(String newEmail, BuildContext context, ocultarTextField) {
    var actions = <Widget>[
      TextButton(
        onPressed: () {
          ocultarTextField();
          context.router.pop();
        },
        child: const Text('Cancelar'),
      ),
      TextButton(
        onPressed: () => changeEmail(newEmail),
        child: Text('Ok'),
      ),
    ];

    var titulo = const Text('Cambiar Email', textAlign: TextAlign.center);
    var message = const Text(
      '¿Deseas modificar tu email?',
      textAlign: TextAlign.center,
    );

    AdminRoll.showMessaje(actions, titulo, message, context);
  }

  //Metodo de cambiar email_____________________________________________
  changeEmail(String newEmail) {
    const snackBar = SnackBar(
      content: Text('Email cambiado correctamente'),
    );
    print('email:  $newEmail');
    var actions = <Widget>[
      TextButton(
        onPressed: () => context.router.pop(),
        child: Text('Ok'),
      ),
    ];
    (CurrentUser.currentUser?.updateEmail(newEmail))?.catchError((onError) {
      var e = onError.toString();
      print('error: $e');
      if (e.contains('invalid-email')) {
        var title = const Text('Email no válido', textAlign: TextAlign.center);
        var message = const Text(
          'Introduzca un email válido. Ejemplo@gmail.com',
          textAlign: TextAlign.center,
        );
        AdminRoll.showMessaje(actions, title, message, context);
      } else if (e.contains('firebase_auth/unknown')) {
        var title =
            const Text('Introduzca un email', textAlign: TextAlign.center);
        var message = const Text(
          'Introduzca un nuevo email',
          textAlign: TextAlign.center,
        );
        AdminRoll.showMessaje(actions, title, message, context);
      } else if (e.contains('requires-recent-login')) {
        var title = const Text('Acción necesaria', textAlign: TextAlign.center);
        var message = const Text(
          'Cierre e inicie sesion para poder realizar esta acción',
          textAlign: TextAlign.center,
        );
        AdminRoll.showMessaje(actions, title, message, context);
      }
      print('error: $onError');
    }).then((value) {
      print('holaaa');

      context.router.pop().then((value) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        actualizarAppBar();
        cerrarTextField();
      });
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

  //Admin tutores
  Widget adminTutores(actiualizarVista) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: AdminTutores.listTutores(context, actiualizarVista),
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

      var titulo = const Text('Link enviado', textAlign: TextAlign.center);
      var message = Text(
        'Abra el email enviado a ${CurrentUser.currentUser?.email} para virificar tu email',
        textAlign: TextAlign.center,
      );

      AdminRoll.showMessaje(actions, titulo, message, context);
    });
  }
}

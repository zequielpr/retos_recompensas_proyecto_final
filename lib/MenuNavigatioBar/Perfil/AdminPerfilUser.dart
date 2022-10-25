import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:retos_proyecto/MediaQuery.dart';
import 'package:retos_proyecto/MenuNavigatioBar/Perfil/ChangePasswd.dart';
import 'package:retos_proyecto/Rutas.gr.dart';
import 'package:retos_proyecto/datos/CollecUsers.dart';
import 'package:retos_proyecto/datos/DatosPersonalUser.dart';
import 'package:retos_proyecto/datos/UsuarioActual.dart';

import 'AdminRoles.dart';

class AdminPerfilUser extends StatefulWidget {
  const AdminPerfilUser({Key? key}) : super(key: key);

  @override
  State<AdminPerfilUser> createState() => _AdminPerfilUserState();
}

class _AdminPerfilUserState extends State<AdminPerfilUser> {
  static var editEmailController = TextEditingController();
  late IconButton iconButonEdit = IconButton(
    tooltip: 'Editar',
    splashColor: Colors.transparent,
    visualDensity: VisualDensity.compact,
    onPressed: () {
      setState(() {
        guardarEmail = true;
        editEmailController.text = actualEmail;
      });
    },
    icon: const Icon(
      Icons.edit,
      size: 16,
    ),
  );

  bool guardarEmail = false;

  late var butonGuardar = (context) {
    return ElevatedButton(
        onPressed: () => preguntar(editEmailController.text, context),
        child: Text('Guardar'));
  };

  //TextField para recoger el nuevo email
  late dynamic fieldNewEmail = SizedBox(
    width: Pantalla.getPorcentPanntalla(60, context, 'x'),
    child: TextField(
      autofocus: true,
      keyboardType: TextInputType.emailAddress,
      controller: editEmailController,
      decoration: const InputDecoration(
        focusedBorder: UnderlineInputBorder(),
        border: UnderlineInputBorder(),
      ),
    ),
  );

  var actualEmail = CurrentUser.currentUser?.email as String;
  var TextActualEmail = Text(CurrentUser.currentUser?.email as String,
      style: const TextStyle(fontSize: 20));

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
          padding: EdgeInsets.only(left: 20),
          child: Align(
            alignment: Alignment.topLeft,
            child: Row(
              children: [
                guardarEmail ? fieldNewEmail : TextActualEmail,
                Padding(
                    padding: EdgeInsets.only(
                        left: Pantalla.getPorcentPanntalla(5, context, 'x'))),
                guardarEmail ? butonGuardar(context) : iconButonEdit
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 20,
          ),
          child: Align(
            alignment: Alignment.topLeft,
            child: TextButton(
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(const EdgeInsets.only(left: 0))),
              onPressed: () {context.router.pushWidget(ChangePasswd(contextPerfil: context));},
              child: const Text(
                'Cambiar Contraseña',
                style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.normal),
              ),
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
                        context.router.replace(SplashScreenRouter())
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

  void ocultarTextField() {
    setState(() {
      guardarEmail = false;
    });
  }

  void preguntar(String newEmail, BuildContext context) {
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

  changeEmail(String newEmail) {
    print('email:  $newEmail');
    var message;
    var title;
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
    });
  }

  static Future<void> _p() async {
    try {
      await GoogleSignIn().disconnect();
    } catch (e) {}
  }
}

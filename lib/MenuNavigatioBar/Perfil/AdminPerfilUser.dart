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

  static bool guardarEmail = false;
  static var actualizarAppBar;
  static var cerrarTextField;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(Pantalla.getPorcentPanntalla(7.8, context, 'y')),
        child: getAppBar(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListTile(
              leading: DatosPersonales.getAvatar(CollecUser.COLECCION_USUARIOS,
                  CurrentUser.getIdCurrentUser(), 30),
              title: DatosPersonales.getDato(CollecUser.COLECCION_USUARIOS,
                  CurrentUser.getIdCurrentUser(), 'nombre'),
              subtitle: DatosPersonales.getDato(CollecUser.COLECCION_USUARIOS,
                  CurrentUser.getIdCurrentUser(), 'nombre_usuario'),
            ),
            cuerpo()
          ],
        ),
      ),
    );
    ;
  }

  static Widget getAppBar() {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      actualizarAppBar = () {
        setState(() {});
      };
      return AppBar(
        actions: [
          guardarEmail
              ? IconButton(
                  onPressed: () => cerrarTextField(), icon: Icon(Icons.close))
              : Text('')
        ],
        centerTitle: true,
        title: Text('adminPerfil'),
      );
    });
  }

  Widget cuerpo() {
    //________________
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      cerrarTextField = () {
        setState(() {
          actualizarAppBar();
          guardarEmail = false;
        });
      };

      var actualEmail = CurrentUser.currentUser?.email as String;
      late IconButton iconButonEdit = IconButton(
        tooltip: 'Editar',
        splashColor: Colors.transparent,
        visualDensity: VisualDensity.compact,
        onPressed: () {
          setState(() {
            actualizarAppBar();
            guardarEmail = true;
            editEmailController.text = actualEmail;
          });
        },
        icon: const Icon(
          Icons.edit,
          size: 16,
        ),
      );
      late var butonGuardar = (context) {
        return ElevatedButton(
            onPressed: () =>
                preguntar(editEmailController.text, context, cerrarTextField),
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

      var TextActualEmail = Text(CurrentUser.currentUser?.email as String,
          style: const TextStyle(fontSize: 20));

      //Contenidos____________________________
      return Column(
        children: [
          verRoll(),
          adminEmail(
              fieldNewEmail, TextActualEmail, butonGuardar, iconButonEdit),
          adminPassw(),
          CurrentUser.currentUser?.emailVerified == true
              ? Text(
                  '',
                  style: TextStyle(fontSize: 0),
                )
              : virificarEmail(),
          cerrarSesion(),
          eliminarCuenta()
        ],
      );
    });
  }

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

  static Future<void> _p() async {
    try {
      await GoogleSignIn().disconnect();
    } catch (e) {}
  }

  static Future<void> cerrarCession(BuildContext context) async {
    var actions = <Widget>[
      TextButton(
        onPressed: () => context.router.pop(),
        child: Text('Cancelar'),
      ),
      TextButton(
        onPressed: () async {
          await FirebaseAuth.instance.signOut().then((value) async =>
              {await _p(), context.router.replace(SplashScreenRouter())});
        },
        child: Text('Cerrar sesión'),
      )
    ];

    var title = const Text('Cerrar sesión', textAlign: TextAlign.center);
    var message = const Text(
      '¿Desea cerrar sesión?',
      textAlign: TextAlign.center,
    );

    AdminRoll.showMessaje(actions, title, message, context);
    //print(FirebaseAuth.instance.currentUser?.providerData);
  }

  Widget verRoll() {
    return Padding(
      padding: EdgeInsets.only(left: 20, top: 10),
      child: Align(
        alignment: Alignment.topLeft,
        child: AdminRoll.getRoll(context),
      ),
    );
  }

  //AdministrarEmail
  Widget adminEmail(
      fieldNewEmail, TextActualEmail, butonGuardar, iconButonEdit) {
    return Padding(
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
    );
  }

  //Administrar contraseña
  Widget adminPassw() {
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
  Widget cerrarSesion() {
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
          onPressed: () => cerrarCession(context),
          child: Text(
            "Cerrar sesión",
            style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.normal),
          ),
        ),
      ),
    );
  }

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
          onPressed: ()=>veificarEmail(),
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

  void veificarEmail(){
    (CurrentUser.currentUser?.sendEmailVerification())?.catchError((onError){}).then((value) {
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

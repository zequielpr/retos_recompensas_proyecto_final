import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:retos_proyecto/MediaQuery.dart';
import 'package:retos_proyecto/Rutas.gr.dart';
import 'package:retos_proyecto/datos/CollecUsers.dart';
import 'package:retos_proyecto/widgets/Dialogs.dart';

import '../../../datos/TransferirDatos.dart';

class RecoveryPassw extends StatefulWidget {
  const RecoveryPassw({Key? key}) : super(key: key);

  @override
  State<RecoveryPassw> createState() => _RecoveryPasswState();
}

class _RecoveryPasswState extends State<RecoveryPassw> {
  var emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.help),
            onPressed: () {},
          ),
        ],
        titleTextStyle: TextStyle(),
        title: Align(
          alignment: Alignment.center,
          child: Text(
            'Reestablecer',
            style: TextStyle(color: Colors.black, fontSize: 25),
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(
            left: Pantalla.getPorcentPanntalla(6, context, 'x'),
            right: Pantalla.getPorcentPanntalla(6, context, 'x'),
            top: Pantalla.getPorcentPanntalla(4, context, 'y')),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Contraseña olvidada',
                  style: GoogleFonts.roboto(
                      fontSize: 25, fontWeight: FontWeight.w400)),
            ),
            Text(
                'Se te enviará un link a tu correo eltronico mediante el cual, podrás reestablecer tu contraseña',
                style: GoogleFonts.roboto(
                    fontSize: 17, fontWeight: FontWeight.w200)),
            Container(
              margin: EdgeInsets.only(
                  top: Pantalla.getPorcentPanntalla(2, context, 'y'),
                  bottom: Pantalla.getPorcentPanntalla(2, context, 'y')),
              child: TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                autofocus: true,
                decoration: InputDecoration(
                    hintText: 'escribe tu email aquí', labelText: 'Email'),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  enviarLinkRecovPassw(emailController.text);
                },
                child: Text('Restablecer'))
          ],
        ),
      ),
    );
  }

  //Enviar link

  void enviarLinkRecovPassw(String email) {
    bool enviar = true;
    (FirebaseAuth.instance.sendPasswordResetEmail(email: email))
        .catchError((e) {
      enviar = false;
      late String title;
      late String message;
      var ex = e.toString();
      actions(BuildContext context){
        return <Widget>[
          TextButton(
            onPressed: () {
              context.router.pop();
            },
            child: const Text('Ok'),
          ),
        ];
      };
      print('error $ex');
      if (ex.contains('invalid-email')) {
        title = 'Email no válido';
        message = 'Introduzca un email válido. Ejemplo@gmail.com';
      } else if (ex.contains('user-not-found')) {
        title = 'Usuario no encontrado';
        message =
            'No existe ningún usuario registrado con el emeail:${emailController.text}';
      } else if (ex.contains('firebase_auth/unknown')) {
        title = 'Introduzca un email';
        message =
            'Es necesario introducir un email para reestablecer su contraseña';
      } else if (ex.contains('too-many-requests')) {
        title = 'Demasiados intentos';
        message = 'Rebice su email inbox o intentelo más tarde';
      } else {
        title = 'Ha ocurrido un error';
        message = 'Intentelo más tarde';
      }

      Dialogos.mostrarDialog(actions, title, message, context);
    }).then((value) {
      var message = 'Link enviado a ${emailController.text}';

      actions(BuildContext context){
        return <Widget>[
          TextButton(
            onPressed: () => context.router.replace(IniSesionEmailPasswordRouter(
                args: TransDatosInicioSesion('', false, true, emailController.text,
                ))),
            child: const Text('OK'),
          ),
        ];
      }
      String titulo = 'Link enviado';
      enviar ? Dialogos.mostrarDialog(actions, titulo, message, context) : null;
    });
  }

  //Mostrar mensaje:
  void mostrarMensaje(title, message, acction) {
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
            left: Pantalla.getPorcentPanntalla(3, context, 'x'), right: Pantalla.getPorcentPanntalla(3, context, 'x')),
        title: Text(title, textAlign: TextAlign.center),
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          acction,
        ],
      ),
    );
  }
}

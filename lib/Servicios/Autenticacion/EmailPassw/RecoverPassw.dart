import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:retos_proyecto/recursos/MediaQuery.dart';
import 'package:retos_proyecto/Rutas.gr.dart';
import 'package:retos_proyecto/datos/Colecciones.dart';
import 'package:retos_proyecto/recursos/Espacios.dart';
import 'package:retos_proyecto/widgets/Dialogs.dart';

import '../../../datos/TransferirDatos.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecoveryPassw extends StatefulWidget {
  const RecoveryPassw({Key? key}) : super(key: key);

  @override
  State<RecoveryPassw> createState() => _RecoveryPasswState();
}

class _RecoveryPasswState extends State<RecoveryPassw> {
  var emailController = TextEditingController();
  var leftRight;
  AppLocalizations? valores;
  @override
  Widget build(BuildContext context) {
    valores = AppLocalizations.of(context);
    leftRight = Pantalla.getPorcentPanntalla(Espacios.leftRight, context, 'x');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        titleTextStyle: TextStyle(),
        title: Text(
          valores?.reestablecer as String,
          style: TextStyle(color: Colors.black, fontSize: 25),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(
            left: leftRight,
            right: leftRight,
            top: Pantalla.getPorcentPanntalla(Espacios.top, context, 'y')),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(valores?.passw_olvidada as String,
                  style: GoogleFonts.roboto(
                      fontSize: 25, fontWeight: FontWeight.w400)),
            ),
            Text(valores?.contenido_passw_olvidada as String,
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  color: Colors.grey,
                )),
            Container(
              margin: EdgeInsets.only(
                  top: Pantalla.getPorcentPanntalla(2, context, 'y'),
                  bottom: Pantalla.getPorcentPanntalla(4, context, 'y')),
              child: TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                autofocus: true,
                decoration: InputDecoration(
                    hintText: valores?.escribe_email_aqui, labelText: 'Email'),
              ),
            ),
            SizedBox(
              width: Pantalla.getPorcentPanntalla(50, context, 'x'),
              height: Pantalla.getPorcentPanntalla(6, context, 'y'),
              child: ElevatedButton(
                  onPressed: () {
                    enviarLinkRecovPassw(emailController.text);
                  },
                  child: Text(valores?.reestablecer as String)),
            )
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
      actions(BuildContext context) {
        return <Widget>[
          TextButton(
            onPressed: () {
              context.router.pop();
            },
            child: const Text('Ok'),
          ),
        ];
      }

      ;
      print('error $ex');
      if (ex.contains('invalid-email')) {
        title = valores?.email_incorrecto as String;
        message =
            '${valores?.introduzca_email_valido}. ${valores?.ejemplo}@gmail.com';
      } else if (ex.contains('user-not-found')) {
        title = valores?.email_no_encontrado as String;
        message =
            '${valores?.contenido_email_no_econtra} ${emailController.text}';
      } else if (ex.contains('firebase_auth/unknown')) {
        title = valores?.introdc_correo_electronico as String;
        message = valores?.intro_email_contenido as String;
      } else if (ex.contains('too-many-requests')) {
        title = valores?.demasiados_intentos as String;
        message = valores?.demasiados_intententos_content as String;
      } else {
        title = valores?.ha_error as String;
        message = valores?.intentelo_mas_tarde as String;
      }

      Dialogos.mostrarDialog(actions, title, message, context);
    }).then((value) {
      var message =
          '${valores?.link_enviado} ${valores?.a} ${emailController.text}';

      actions(BuildContext context) {
        return <Widget>[
          TextButton(
            onPressed: () =>
                context.router.replace(IniSesionEmailPasswordRouter(
                    args: TransDatosInicioSesion(
              '',
              false,
              true,
              emailController.text,
            ))),
            child: const Text('OK'),
          ),
        ];
      }

      String titulo = valores?.link_enviado as String;
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
            left: Pantalla.getPorcentPanntalla(3, context, 'x'),
            right: Pantalla.getPorcentPanntalla(3, context, 'x')),
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

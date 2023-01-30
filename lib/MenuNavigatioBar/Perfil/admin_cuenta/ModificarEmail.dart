import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:retos_proyecto/recursos/Espacios.dart';

import '../../../MediaQuery.dart';
import '../../../datos/UsuarioActual.dart';
import '../../../widgets/Dialogs.dart';
import '../AdminRoles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ModificarEmail extends StatefulWidget {
  const ModificarEmail({Key? key}) : super(key: key);

  @override
  State<ModificarEmail> createState() => _ModificarEmailState();
}

class _ModificarEmailState extends State<ModificarEmail> {
  var emailControler = TextEditingController();
  AppLocalizations? valores;

  @override
  void initState() {
    emailControler.text = CurrentUser.currentUser?.email as String;
    super.initState();
  }
  var leftRight;

  @override
  Widget build(BuildContext context) {
    valores = AppLocalizations.of(context);
    leftRight = Pantalla.getPorcentPanntalla(Espacios.leftRight, context, 'x');
    return Scaffold(
        appBar: AppBar(
          title: Text(valores?.modificar_email as String),
        ),
        body: Container(
          margin: EdgeInsets.only(
              left: leftRight,
              right: leftRight,
              top: Pantalla.getPorcentPanntalla(Espacios.top, context, 'y')),
          child: Column(
            children: [
              TextField(
                keyboardType: TextInputType.emailAddress,
                autofocus: true,
                controller: emailControler,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () => setState(() {
                      emailControler.text = '';
                    }),
                    icon: Icon(
                      Icons.cancel_outlined,
                      color: Colors.black38,
                    ),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: Pantalla.getPorcentPanntalla(3, context, 'y'),),
            SizedBox(
                width: Pantalla.getPorcentPanntalla(50, context, 'x'),
                height: Pantalla.getPorcentPanntalla(6, context, 'y'),
                child: ElevatedButton(
                    onPressed: () => changeEmail(emailControler.text),
                    child: Text(valores?.guardar as String)))
            ],
          ),
        ));
    ;
  }

  //Metodo de cambiar email_____________________________________________
  changeEmail(String newEmail) {
    bool emailCambiado = true;
    var title;
    var message;
    SnackBar snackBar = SnackBar(
      content: Text('${valores?.email_actualizado_correct}'),
    );
    //print('email:  $newEmail');
    (CurrentUser.currentUser?.updateEmail(newEmail))?.catchError((onError) {
      var e = onError.toString();
      if (e.contains('invalid-email')) {
        title = valores?.email_incorrecto as String;
        message = '${valores?.introduzca_email_valido}. ${valores?.ejemplo}@gmail.com';
      } else if (e.contains('firebase_auth/unknown')) {
        title = '${valores?.introdc_correo_electronico}';
        message = '${valores?.introdc_correo_electronico}';
      } else if (e.contains('requires-recent-login')) {
        title ='${valores?.accion_necesaria}';
        message = '${valores?.accion_necesaria_contenido}';
      } else if (e.contains('email-already-in-use')) {
        title ='${valores?.email_en_uso}';
        message = '${valores?.email_en_uso_contenido}';
      }
      emailCambiado = false;
      _mostrarExepcion(title, message);
    }).then((value) {
      if (emailCambiado) ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  //Mostrar exepcion_______________________________________
  _mostrarExepcion(titulo, mensaje) {

    action(BuildContext context){
      return <Widget>[
        TextButton(
          onPressed: () => context.router.pop(),
          child: Text('Ok'),
        ),
      ];
    }

    Dialogos.mostrarDialog(action, titulo, mensaje, context);
  }




}

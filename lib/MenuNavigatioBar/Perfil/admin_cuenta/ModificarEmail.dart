import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../MediaQuery.dart';
import '../../../datos/UsuarioActual.dart';
import '../../../widgets/Dialogs.dart';
import '../AdminRoles.dart';

class ModificarEmail extends StatefulWidget {
  const ModificarEmail({Key? key}) : super(key: key);

  @override
  State<ModificarEmail> createState() => _ModificarEmailState();
}

class _ModificarEmailState extends State<ModificarEmail> {
  var emailControler = TextEditingController();

  @override
  void initState() {
    emailControler.text = CurrentUser.currentUser?.email as String;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Cambiar email'),
        ),
        body: Container(
          margin: EdgeInsets.only(
              left: Pantalla.getPorcentPanntalla(5, context, 'x'),
              right: Pantalla.getPorcentPanntalla(5, context, 'x'),
              top: Pantalla.getPorcentPanntalla(5, context, 'y')),
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
              ElevatedButton(
                  onPressed: () => changeEmail(emailControler.text),
                  child: Text('Guardar'))
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
    const snackBar = SnackBar(
      content: Text('Email cambiado correctamente'),
    );
    //print('email:  $newEmail');
    (CurrentUser.currentUser?.updateEmail(newEmail))?.catchError((onError) {
      var e = onError.toString();
      if (e.contains('invalid-email')) {
        title = 'Email no válido';
        message = 'Introduzca un email válido. Ejemplo@gmail.com';
      } else if (e.contains('firebase_auth/unknown')) {
        title = 'Introduzca un email';
        message = 'Introduzca un email';
      } else if (e.contains('requires-recent-login')) {
        title ='Acción necesaria';
        message = 'Cierre e inicie sesion para poder realizar esta acción';
      } else if (e.contains('email-already-in-use')) {
        title ='Email en usao';
        message = 'El email introducido ya esta en uso';
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

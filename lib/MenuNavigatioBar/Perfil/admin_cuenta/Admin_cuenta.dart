import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:retos_proyecto/Rutas.gr.dart';
import 'package:retos_proyecto/widgets/Dialogs.dart';

import '../../../datos/UsuarioActual.dart';
import 'EliminarCuenta.dart';
import 'ModificarEmail.dart';
import 'Sesion.dart';

class AdminCuenta extends StatefulWidget {
  const AdminCuenta({Key? key}) : super(key: key);

  @override
  State<AdminCuenta> createState() => _AdminCuentaState();
}

class _AdminCuentaState extends State<AdminCuenta> {
  var arrowSize = 16.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Cuenta'),
      ),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Card(
              elevation: 0,
              margin: EdgeInsets.all(0),
              child: ListTile(
                leading: Icon(Icons.email_outlined),
                onTap: () => context.router.push(ModificarEmailRouter()),
                visualDensity: VisualDensity.compact,
                title: Text(CurrentUser.currentUser?.email as String),
                trailing: Icon(
                  Icons.arrow_forward_ios_sharp,
                  size: arrowSize,
                ),
              ),
            ),
            _needVerificarEmail(),
            Card(
              elevation: 0,
              margin: EdgeInsets.all(0),
              child: ListTile(
                leading: Icon(Icons.password),
                onTap: () => context.router
                    .push(ChangePasswdRouter(contextPerfil: context)),
                visualDensity: VisualDensity.compact,
                title: Text('Camiar contraseña'),
                trailing: Icon(
                  Icons.arrow_forward_ios_sharp,
                  size: arrowSize,
                ),
              ),
            ),
            Card(
              elevation: 0,
              margin: EdgeInsets.all(0),
              child: ListTile(
                leading: Icon(Icons.delete_forever_outlined),
                onTap: () => EliminarCuenta.eliminarCuenta(context),
                visualDensity: VisualDensity.compact,
                title: Text('Eliminar cuenta'),
                trailing: Icon(
                  Icons.arrow_forward_ios_sharp,
                  size: arrowSize,
                ),
              ),
            ),
            Card(
              elevation: 0,
              margin: EdgeInsets.all(0),
              child: ListTile(
                leading: Icon(Icons.logout),
                onTap: () => Sesion.dialogCerrarSesion(context),
                visualDensity: VisualDensity.compact,
                title: Text('Cerrar sesión'),
                trailing: Icon(
                  Icons.arrow_forward_ios_sharp,
                  size: arrowSize,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //Mostrar si el usuario necesita veirifar su email
  Widget _needVerificarEmail() {
    print('holaaaaaaaaaaa');
    CurrentUser.currentUser?.reload();
    CurrentUser.setCurrentUser();
    return CurrentUser.currentUser?.emailVerified == false
        ? Card(
            elevation: 0,
            margin: EdgeInsets.all(0),
            child: ListTile(
              leading: Icon(Icons.warning_amber_rounded),
              onTap: () => CurrentUser.currentUser
                  ?.sendEmailVerification()
                  .then((value) => _linkEnviado()),
              visualDensity: VisualDensity.compact,
              title: Text('Verificar email'),
              trailing: Icon(
                Icons.arrow_forward_ios_sharp,
                size: arrowSize,
              ),
            ),
          )
        : SizedBox();
  }

  void _linkEnviado() {
    String titulo = 'Link enviado';
    String mensaje =
        'Se ha enviado un link al nuevo correo, abre el link para verificar el correo';
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

    Dialogos.mostrarDialog(actions, titulo, mensaje, context);
  }
}

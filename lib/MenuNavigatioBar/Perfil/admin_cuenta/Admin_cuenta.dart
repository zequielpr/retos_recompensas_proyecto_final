import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:retos_proyecto/Loanding.dart';
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
  bool isWaiting = false;
  var body;
  var loanding;
  @override
  Widget build(BuildContext context) {
    body = Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _getCardodEmail(),
          _needVerificarEmail(),
          _getCardCambiarPssw(),
          /* Card(
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
            ),*/
          _getCardCerrarSesion()
        ],
      ),
    );
    loanding = Loanding.getLoanding(body, context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Cuenta'),
      ),
      body: isWaiting?loanding:body,
    );
  }

  Card _getCardodEmail(){
    return Card(
      elevation: 0,
      margin: EdgeInsets.all(0),
      child: ListTile(
        leading: Icon(Icons.email_outlined),
        onTap: () => context.router.push(ModificarEmailRouter()),
        visualDensity: VisualDensity.compact,
        title: Text(_getEmail()),
        trailing: Icon(
          Icons.arrow_forward_ios_sharp,
          size: arrowSize,
        ),
      ),
    );
  }
  //Mostrar si el usuario necesita veirifar su email
  Widget _needVerificarEmail() {
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
  String _getEmail(){
    try{
      return CurrentUser.currentUser?.email as String;
    }catch(e){
      return '';
    }
  }

  Card _getCardCambiarPssw(){
    return Card(
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
    );
  }

  Card _getCardCerrarSesion(){
    return Card(
      elevation: 0,
      margin: EdgeInsets.all(0),
      child: ListTile(
        leading: Icon(Icons.logout),
        onTap: () => Sesion.dialogCerrarSesion(context, espararCerrarSesion),
        visualDensity: VisualDensity.compact,
        title: Text('Cerrar sesión'),
        trailing: Icon(
          Icons.arrow_forward_ios_sharp,
          size: arrowSize,
        ),
      ),
    );
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

  void espararCerrarSesion(isWaiting){
    setState(() {
      this.isWaiting = isWaiting;
    });
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                onTap: () {},
                visualDensity: VisualDensity.compact,
                title: Text('Cambiar email'),
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
                leading: Icon(Icons.password),
                onTap: () {},
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
                onTap: () {},
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
}

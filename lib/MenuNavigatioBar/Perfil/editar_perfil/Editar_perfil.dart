import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:retos_proyecto/Rutas.gr.dart';
import 'package:retos_proyecto/Servicios/Autenticacion/DatosNewUser.dart';
import 'package:retos_proyecto/datos/DatosPersonalUser.dart';
import 'package:retos_proyecto/datos/UsuarioActual.dart';

import '../../../Servicios/Autenticacion/NombreUsuario.dart';
import '../../../datos/Colecciones.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditarPerfil extends StatefulWidget {
  const EditarPerfil({Key? key}) : super(key: key);

  @override
  State<EditarPerfil> createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {
  AppLocalizations? valores;
  void initState() {
    // TODO: implement initState
    NombreUsuarioWidget.vistaModificarUserName = setState;

    Coleciones.COLECCION_USUARIOS
        .doc(CurrentUser.getIdCurrentUser())
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        NombreUsuarioWidget.nombreUsuarioActual = documentSnapshot['nombre_usuario'];
      }
  });}


  var arrowSize = 16.0;
  @override
  Widget build(BuildContext context) {
    valores = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(valores?.editar_perfil as String),
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
                leading: Icon(Icons.edit),
                onTap: () => context.router.push(ModificarNombreRouter()),
                visualDensity: VisualDensity.compact,
                title:Text(CurrentUser.currentUser?.displayName as String),
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
                leading: Icon(Icons.edit),
                onTap: () => context.router.push(ModificarNombreUsuarioRouter()),
                visualDensity: VisualDensity.compact,
                title: DatosPersonales.getDato(CurrentUser.getIdCurrentUser(), 'nombre_usuario', TextStyle()),
                trailing: Icon(
                  Icons.arrow_forward_ios_sharp,
                  size: arrowSize,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

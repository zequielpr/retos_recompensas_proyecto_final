import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:retos_proyecto/Rutas.gr.dart';

class EditarPerfil extends StatefulWidget {
  const EditarPerfil({Key? key}) : super(key: key);

  @override
  State<EditarPerfil> createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {
  var arrowSize = 16.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Editar Perfil'),
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
                title: Text('Nombre'),
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
                title: Text('Nombre de usuario'),
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

  //Editar email
//Editar nombre de usuario
//Editar nombre1
}

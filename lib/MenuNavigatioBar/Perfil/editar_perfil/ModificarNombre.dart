import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:retos_proyecto/MediaQuery.dart';
import 'package:retos_proyecto/datos/CollecUsers.dart';
import 'package:retos_proyecto/datos/UsuarioActual.dart';

import '../../../Servicios/Autenticacion/NombreUsuario.dart';
import '../../../datos/TransferirDatos.dart';

class ModificarNombre extends StatefulWidget {
  const ModificarNombre({Key? key}) : super(key: key);

  @override
  State<ModificarNombre> createState() => _ModificarNombreState();
}

class _ModificarNombreState extends State<ModificarNombre> {
  @override
  void initState() {
    nameController.text = CurrentUser.currentUser?.displayName as String;
    // TODO: implement initState
    super.initState();
  }

  var nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Modificar'),
        ),
        body: Container(
          margin: EdgeInsets.only(
              left: Pantalla.getPorcentPanntalla(6, context, 'x'),
              right: Pantalla.getPorcentPanntalla(6, context, 'x'),
              top: Pantalla.getPorcentPanntalla(6, context, 'x')),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: Text(
                    'Nombre',
                    style: GoogleFonts.roboto(
                        fontSize: 25, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0),
                child: TextField(
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  autofocus: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: "Nombre"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SizedBox(
                  width: 200,
                  height: 42,
                  child: ElevatedButton(
                    style: ButtonStyle(elevation: MaterialStateProperty.all(0)),
                    onPressed: () => _guardarNombre(nameController.text),
                    child: Text('Guardar',
                        style: GoogleFonts.roboto(
                            fontSize: 17, fontWeight: FontWeight.w600)),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Future<void> _guardarNombre(String nombre) async{
    var mensaje = 'Nombre actualizado correctamente';
    if (nombre.length <= 30) {
      await CollecUser.COLECCION_USUARIOS
          .doc(CurrentUser.getIdCurrentUser())
          .update({'nombre': nombre}).then(
              (value) => CurrentUser.currentUser?.updateDisplayName(nombre));
      NombreUsuarioWidget.vistaModificarUserName(() {});
      NombreUsuarioWidget.vistaPerfil(() {});

      final snackBar = SnackBar(
        content: Text(mensaje),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      context.router.pop();
      return;
    }

    actions(BuildContext context){
      return <Widget>[
        TextButton(
          onPressed: () {
            context.router.pop();
          },
          child: const Text('Ok'),
        ),
      ];
    }
    var titulo = const Text('Nombre', textAlign: TextAlign.center);
    var message = const Text(
      'Introduzca 30 0 menos caracteres',
      textAlign: TextAlign.center,
    );


  }
}

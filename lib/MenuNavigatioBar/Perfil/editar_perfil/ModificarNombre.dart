import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:retos_proyecto/MediaQuery.dart';
import 'package:retos_proyecto/datos/Colecciones.dart';
import 'package:retos_proyecto/datos/UsuarioActual.dart';

import '../../../Servicios/Autenticacion/NombreUsuario.dart';
import '../../../datos/TransferirDatos.dart';
import '../../../datos/ValidarDatos.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ModificarNombre extends StatefulWidget {
  const ModificarNombre({Key? key}) : super(key: key);

  @override
  State<ModificarNombre> createState() => _ModificarNombreState();
}

class _ModificarNombreState extends State<ModificarNombre> {
  AppLocalizations? valores;
  @override
  void initState() {
    nameController.text = CurrentUser.currentUser?.displayName as String;
    // TODO: implement initState
    super.initState();
  }

  var nameController = TextEditingController();
  var mostrarMensajeError = false;
  @override
  Widget build(BuildContext context) {
    valores = AppLocalizations.of(context);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(valores?.actualizar as String),
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
                  child: Text(valores?.nombre as String,
                    style: GoogleFonts.roboto(
                        fontSize: 25, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0),
                child: TextField(
                  maxLength: 30,
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  autofocus: true,
                  onChanged: (nombre) => _validarNombre(nombre),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: valores?.nombre),
                ),
              ),
              mostrarMensajeError == true?mensajeError:Text(''),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SizedBox(
                  width: 200,
                  height: 42,
                  child: ElevatedButton(
                    style: ButtonStyle(elevation: MaterialStateProperty.all(0)),
                    onPressed: mostrarMensajeError== false?() =>  _guardarNombre(nameController.text):null,
                    child: Text(valores?.guardar as String,
                        style: GoogleFonts.roboto(
                            fontSize: 17, fontWeight: FontWeight.w600)),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  void _validarNombre(String nombre) {
    if(!Validar.validarNombre(nombre)){
      setState(() {
        mostrarMensajeError = true;
      });
      return;
    }
    setState(() {
      mostrarMensajeError = false;
    });
  }

  late   Align mensajeError =  Align(child: Text(valores?.entre_3_30_caracteres as String,
    style: TextStyle(color: Colors.red, fontSize: 13),
  ), alignment: Alignment.centerLeft,);

  Future<void> _guardarNombre(String nombre) async {
    var mensaje = valores?.nombre_actualizado_correct as String;
    if (nombre.length <= 30 && nombre.length > 2) {
      await Coleciones.COLECCION_USUARIOS
          .doc(CurrentUser.getIdCurrentUser())
          .update({'nombre': nombre}).then(
              (value) => CurrentUser.currentUser?.updateDisplayName(nombre));
      CurrentUser.currentUser?.reload();
      CurrentUser.setCurrentUser();
      NombreUsuarioWidget.vistaModificarUserName(() {});
      NombreUsuarioWidget.vistaPerfil(() {});

      final snackBar = SnackBar(
        content: Text(mensaje),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      context.router.pop();
      return;
    }
  }
}

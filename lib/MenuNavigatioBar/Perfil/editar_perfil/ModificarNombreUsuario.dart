import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Servicios/Autenticacion/Autenticacion.dart';
class ModificarNombreUsuario extends StatefulWidget {
  const ModificarNombreUsuario({Key? key}) : super(key: key);

  @override
  State<ModificarNombreUsuario> createState() => _ModificarNombreUsuarioState();
}

class _ModificarNombreUsuarioState extends State<ModificarNombreUsuario> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Modificar nombre de usuario'),
        ),
        body: Text(''),);
  }
}

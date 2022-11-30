import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ModificarNombre extends StatefulWidget {
  const ModificarNombre({Key? key}) : super(key: key);


  @override
  State<ModificarNombre> createState() => _ModificarNombreState();
}

class _ModificarNombreState extends State<ModificarNombre> {
  var userNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modificar nombre'),
      ),
      body: Text('hola'),
    );
  }
}
